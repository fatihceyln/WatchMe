//
//  ContentDetailVC.swift
//  WatchMe
//
//  Created by Fatih Kilit on 13.08.2022.
//

import UIKit
import WebKit

class ContentDetailVC: WMDataLoadingVC, WKUIDelegate {
    
    private var scrollView: UIScrollView!
    private var containerStackView: UIStackView!
    
    private var headerView: HeaderView!
    private var overviewLabel: WMBodyLabel!
    private var castView: CastView!
    private var similarSectionView: SectionView!
    
    private let padding: CGFloat = 16
    
    private var contentDetail: ContentDetail!
    private var cast: [Cast] = []
    private var videoResult: VideoResult?
    
    private var similarContents: [ContentResult] = []
    
    private var emptyView: UIView!
    
    private var webView: WKWebView!
    
    private var isSaved: Bool {
        Store.isSaved(content: contentDetail)
    }
    
    init(contentDetail: ContentDetail, videoResult: VideoResult?) {
        super.init(nibName: nil, bundle: nil)
        self.contentDetail = contentDetail
        self.videoResult = videoResult
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        navigationItem.backButtonTitle = ""
        title = contentDetail.isMovie ? contentDetail.title : contentDetail.name
        
        configureScrollView()
        configureContainerStackView()
        
        configureHeaderView()
        configureOverviewLabel()
        configureWebView()
        configureCastView()
        configureSimilarSectionView()
        
        setViewData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: true)
        
        updateRightBarButton()
    }
    
    @objc private func updateContent() {
        Store.update(content: contentDetail)
        
        updateRightBarButton()
    }
    
    private func updateRightBarButton() {
        if isSaved {
            let checkmarkButton = UIBarButtonItem(image: UIImage(systemName: "checkmark"), style: .done, target: self, action: #selector(updateContent))
            
        
            navigationItem.rightBarButtonItem = checkmarkButton
        } else {
            let plusButton = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .done, target: self, action: #selector(updateContent))
            
        
            navigationItem.rightBarButtonItem = plusButton
        }
    }
}

extension ContentDetailVC {
    private func getCast() {
        let urlString = contentDetail.isMovie ? ApiUrls.movieCredits(id: contentDetail.id?.description ?? "") : ApiUrls.showCredits(id: contentDetail.id?.description ?? "")
        
        NetworkingManager.shared.downloadCast(urlString: urlString) { [weak self] result in
            
            guard let self = self else { return }
            switch result {
            case .success(let cast):
                if cast.isEmpty {
                    self.configureEmptyView(superStackView: self.castView, collectionView: self.castView.collectionView, message: "No casts info")
                    return
                }
                
                if cast.count > 10 {
                    self.cast = Array(cast.prefix(upTo: 10))
                } else {
                    self.cast = cast
                }
                
                self.castView.collectionView.reloadDataOnMainThread()
            case .failure(let error):
                self.configureEmptyView(superStackView: self.castView, collectionView: self.castView.collectionView, message: "No casts info")
                print(error)
            }
        }
    }
    
    private func getSimilarContents() {
        let urlString = contentDetail.isMovie ? ApiUrls.similarMovies(movieId: contentDetail.id?.description ?? "", page: 1) : ApiUrls.similarShows(showId: contentDetail.id?.description ?? "", page: 1)
        
        NetworkingManager.shared.downloadContent(urlString: urlString) { [weak self] result in
            
            guard let self = self else { return }
            
            switch result {
            case .success(let similarContents):
                if similarContents.isEmpty {
                    self.configureEmptyView(superStackView: self.similarSectionView, collectionView: self.similarSectionView.collectionView, message: "No similar movies info")
                    return
                }
                
                self.similarContents = similarContents
                self.similarSectionView.collectionView.reloadDataOnMainThread()
            case .failure(let error):
                self.configureEmptyView(superStackView: self.similarSectionView, collectionView: self.similarSectionView.collectionView, message: "No similar movies info")
                print(error)
            }
        }
    }
    
    private func getContentDetail(urlString: String) {
        showLoadingView()
        NetworkingManager.shared.downloadContentDetail(urlString: urlString) { [weak self] result in
            guard let self = self else { return }
            self.dismissLoadingView()
            
            switch result {
            case .success(let contentDetail):
                
                guard let id = contentDetail.id?.description else { return }
                let urlString = contentDetail.isMovie ? ApiUrls.movieVideo(id: id) : ApiUrls.showVideo(id: id)
                
                self.getVideo(urlString: urlString) { [weak self] videoResult in
                    guard let self = self else { return }
                    DispatchQueue.main.async {
                        self.navigationController?.pushViewController(ContentDetailVC(contentDetail: contentDetail, videoResult: videoResult), animated: true)
                    }
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        self.scrollView.setContentOffset(CGPoint(x: 0, y: -self.view.safeAreaInsets.top), animated: true)
                        if !self.cast.isEmpty {
                            self.castView.collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .left, animated: true)
                        }
                        if !self.similarContents.isEmpty {
                            self.similarSectionView.collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .left, animated: true)
                        }
                    }
                }
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func getPersonDetail(urlString: String) {
        showLoadingView()
        
        NetworkingManager.shared.downloadPerson(urlString: urlString) { [weak self] result in
            guard let self = self else { return }
            self.dismissLoadingView()
            
            switch result {
            case .success(let person):
                DispatchQueue.main.async {
                    self.navigationController?.pushViewController(PersonDetailVC(actor: person), animated: true)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func getVideo(urlString: String, completion: @escaping(VideoResult?) -> ()) {
        NetworkingManager.shared.downloadVideo(urlString: urlString) { [weak self] result in
            guard let _ = self else { completion(nil); return }
            
            completion(result)
        }
    }
}

extension ContentDetailVC {
    private func setViewData() {
        headerView.setHeaderView(contentDetail: contentDetail)
        overviewLabel.text = contentDetail?.overview
        
        getCast()
        getSimilarContents()
    }
}

extension ContentDetailVC {
    private func configureHeaderView() {
        headerView = HeaderView(superContainerView: containerStackView)
    }
    
    private func configureOverviewLabel() {
        overviewLabel = WMBodyLabel(textAlignment: .left)
        containerStackView.addArrangedSubview(overviewLabel)
    }
    
    private func configureCastView() {
        castView = CastView(superContainerView: containerStackView)
        castView.collectionView.delegate = self
        castView.collectionView.dataSource = self
    }
    
    private func configureSimilarSectionView() {
        similarSectionView = SectionView(containerStackView: containerStackView, title: "\(contentDetail.isMovie ? "Similar Movies" : "Similar Shows")")
        similarSectionView.collectionView.delegate = self
        similarSectionView.collectionView.dataSource = self
    }
    
    private func configureEmptyView(superStackView: UIStackView, collectionView: UICollectionView, message: String) {
        DispatchQueue.main.async {
            collectionView.removeFromSuperview()
            
            self.emptyView = UIView(frame: .zero)
            superStackView.addArrangedSubview(self.emptyView)
            
            self.emptyView.translatesAutoresizingMaskIntoConstraints = false
            self.emptyView.backgroundColor = .systemBackground
            self.emptyView.heightAnchor.constraint(equalToConstant: 30).isActive = true
            
            let messageLabel = WMBodyLabel(textAlignment: .left)
            self.emptyView.addSubview(messageLabel)
            messageLabel.text = message
            messageLabel.pinToEdges(of: self.emptyView)
        }
    }
    
    private func configureWebView() {
        
        guard let videoResult = videoResult else { return }
        
        let webConfiguration = WKWebViewConfiguration()
        
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        containerStackView.addArrangedSubview(webView)
        
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.uiDelegate = self
        webView.scrollView.isScrollEnabled = false
        
        let myURL = URL(string:"https://www.youtube.com/embed/\(videoResult.key ?? "")")
        let myRequest = URLRequest(url: myURL!)
        webView.load(myRequest)
        webView.heightAnchor.constraint(equalToConstant: (UIScreen.main.bounds.width - (2 * padding)) * 0.5625).isActive = true
        webView.backgroundColor = .red
    }
}

extension ContentDetailVC {
    private func configureScrollView() {
        scrollView = UIScrollView(frame: .zero)
        view.addSubview(scrollView)
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsVerticalScrollIndicator = false
        
        scrollView.pinToEdges(of: view)
    }
    
    private func configureContainerStackView() {
        containerStackView = UIStackView(frame: .zero)
        scrollView.addSubview(containerStackView)
        
        containerStackView.translatesAutoresizingMaskIntoConstraints = false
        
        containerStackView.isLayoutMarginsRelativeArrangement = true
        containerStackView.layoutMargins = UIEdgeInsets(top: 2 * padding, left: padding, bottom: 2 * padding, right: padding)
        
        containerStackView.axis = .vertical
        containerStackView.distribution = .fill
        containerStackView.spacing = 20
        
        containerStackView.pinToEdges(of: scrollView)
        containerStackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
    }
}

extension ContentDetailVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == castView.collectionView {
            return cast.count
        } else if collectionView == similarSectionView.collectionView {
            return similarContents.count
        }
        
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == castView.collectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TopBilledCell.reuseID, for: indexPath) as! TopBilledCell
            cell.set(cast: cast[indexPath.row])
            
            return cell
        } else if collectionView == similarSectionView.collectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ContentCell.reuseID, for: indexPath) as! ContentCell
            cell.set(content: similarContents[indexPath.row])
            
            return cell
        }
        
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == similarSectionView.collectionView {
            let urlString = contentDetail.isMovie ? ApiUrls.movieDetail(id: similarContents[indexPath.row].id?.description ?? "") : ApiUrls.showDetail(id: similarContents[indexPath.row].id?.description ?? "")
            
            self.getContentDetail(urlString: urlString)
        } else if collectionView == castView.collectionView {
            guard let personId = cast[indexPath.row].id?.description else { return }
            let urlString = ApiUrls.person(id: personId)
            
            self.getPersonDetail(urlString: urlString)
        }
    }
}
