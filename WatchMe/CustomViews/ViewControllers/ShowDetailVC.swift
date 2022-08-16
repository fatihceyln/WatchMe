//
//  ShowDetailVC.swift
//  WatchMe
//
//  Created by Fatih Kilit on 15.08.2022.
//

import UIKit

class ShowDetailVC: UIViewController {
    
    private var scrollView: UIScrollView!
    private var containerStackView: UIStackView!
    
    private var headerView: HeaderView!
    private var overviewLabel: WMBodyLabel!
    private var castView: CastView!
    private var similarSectionView: SectionView!
    
    private let padding: CGFloat = 16
    
    private var showDetail: ShowDetail!
    private var cast: [Cast] = []
    
    private var similarMovies: [MovieResult] = []
    
    private var emptyView: UIView!
    
    init(showDetail: ShowDetail) {
        super.init(nibName: nil, bundle: nil)
        self.showDetail = showDetail
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        navigationItem.title = showDetail.name
        navigationItem.backButtonTitle = "Back"
        
        configureScrollView()
        configureContainerStackView()
        
        configureHeaderView()
        configureOverviewLabel()
        configureCastView()
        configureSimilarSectionView()
        
        setViewData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
}

extension ShowDetailVC {
    private func getCast() {
        NetworkingManager.shared.downloadCast(urlString: ApiUrls.showCredits(id: showDetail.id?.description ?? "")) { [weak self] result in
            
            guard let self = self else { return }
            
            switch result {
            case .success(let cast):
                if cast.isEmpty {
                    self.configureEmptyView(superStackView: self.castView, collectionView: self.castView.collectionView, message: "No cast info")
                    return
                }
                
                if cast.count > 10 {
                    self.cast = Array(cast.prefix(upTo: 10))
                } else {
                    self.cast = cast
                }
                
                self.castView.collectionView.reloadDataOnMainThread()
            case .failure(let error):
                self.configureEmptyView(superStackView: self.castView, collectionView: self.castView.collectionView, message: "No cast info")
                print(error)
            }
        }
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
            messageLabel.translatesAutoresizingMaskIntoConstraints = false
            messageLabel.text = message
            messageLabel.pinToEdges(of: self.emptyView)
        }
    }
    
    private func getSimilarMovies() {
        NetworkingManager.shared.downloadMovies(urlString: ApiUrls.similarShows(showId: showDetail.id?.description ?? "", page: 1)) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let similarMovies):
                if similarMovies.isEmpty {
                    self.configureEmptyView(superStackView: self.similarSectionView, collectionView: self.similarSectionView.collectionView, message: "No similar movies info")
                    return
                }
                
                self.similarMovies = similarMovies
                self.similarSectionView.collectionView.reloadDataOnMainThread()
            case .failure(let error):
                self.configureEmptyView(superStackView: self.similarSectionView, collectionView: self.similarSectionView.collectionView, message: "No similar movies info")
                print(error)
            }
        }
    }
}

extension ShowDetailVC {
    private func setViewData() {
        headerView.setHeaderView(showDetail: showDetail)
        overviewLabel.text = showDetail?.overview
        
        getCast()
        getSimilarMovies()
    }
}

extension ShowDetailVC {
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
        similarSectionView = SectionView(containerStackView: containerStackView, title: "Similar Shows")
        similarSectionView.collectionView.delegate = self
        similarSectionView.collectionView.dataSource = self
    }
}

extension ShowDetailVC {
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
        NSLayoutConstraint.activate([
            containerStackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
    }
}

extension ShowDetailVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == castView.collectionView {
            return cast.count
        } else if collectionView == similarSectionView.collectionView {
            return similarMovies.count
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
            cell.set(movie: similarMovies[indexPath.row])
            
            return cell
        }
        
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == similarSectionView.collectionView {
            NetworkingManager.shared.downloadShowDetail(urlString: ApiUrls.showDetail(id: similarMovies[indexPath.row].id?.description ?? "")) { [weak self] result in
                
                guard let self = self else { return }
                switch result {
                case .success(let showDetail):
                    DispatchQueue.main.async {
                        self.navigationController?.pushViewController(ShowDetailVC(showDetail: showDetail), animated: true)
                    }
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        self.scrollView.setContentOffset(CGPoint(x: 0, y: -self.view.safeAreaInsets.top), animated: true)
                        if !self.cast.isEmpty {
                            self.castView.collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .left, animated: true)
                        }
                        if !self.similarMovies.isEmpty {
                            self.similarSectionView.collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .left, animated: true)
                        }
                    }
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
}
