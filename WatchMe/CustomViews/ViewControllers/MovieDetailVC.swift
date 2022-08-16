//
//  MovieDetailVC.swift
//  WatchMe
//
//  Created by Fatih Kilit on 13.08.2022.
//

import UIKit

class MovieDetailVC: UIViewController {
    
    private var scrollView: UIScrollView!
    private var containerStackView: UIStackView!
    
    private var headerView: HeaderView!
    private var overviewLabel: WMBodyLabel!
    private var castView: CastView!
    private var similarSectionView: SectionView!
    
    private let padding: CGFloat = 16
    
    private var movieDetail: MovieDetail!
    private var cast: [Cast] = []
    
    private var similarMovies: [MovieResult] = []
    
    private var emptyView: UIView!
    
    init(movieDetail: MovieDetail) {
        super.init(nibName: nil, bundle: nil)
        self.movieDetail = movieDetail
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        navigationItem.title = movieDetail.title
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

extension MovieDetailVC {
    private func getCast() {
        NetworkingManager.shared.downloadCast(urlString: ApiUrls.movieCredits(id: movieDetail.id?.description ?? "")) { [weak self] result in
            switch result {
            case .success(let cast):
                if cast.count > 10 {
                    self?.cast = Array(cast.prefix(upTo: 10))
                } else {
                    self?.cast = cast
                }
                self?.castView.collectionView.reloadDataOnMainThread()
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func getSimilarMovies() {
        NetworkingManager.shared.downloadMovies(urlString: ApiUrls.similarMovies(movieId: movieDetail.id?.description ?? "", page: 1)) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let similarMovies):
                self.similarMovies = similarMovies
                self.similarSectionView.collectionView.reloadDataOnMainThread()
            case .failure(let error):
                print(error)
            }
        }
    }
}

extension MovieDetailVC {
    private func setViewData() {
        headerView.setHeaderView(movieDetail: movieDetail)
        overviewLabel.text = movieDetail?.overview
        
        getCast()
        getSimilarMovies()
    }
}

extension MovieDetailVC {
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
        similarSectionView = SectionView(containerStackView: containerStackView, title: "Similar Movies")
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
            messageLabel.translatesAutoresizingMaskIntoConstraints = false
            messageLabel.text = message
            messageLabel.pinToEdges(of: self.emptyView)
        }
    }
}

extension MovieDetailVC {
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

extension MovieDetailVC: UICollectionViewDelegate, UICollectionViewDataSource {
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
            NetworkingManager.shared.downloadMovieDetail(urlString: ApiUrls.movieDetail(id: similarMovies[indexPath.row].id?.description ?? "")) { [weak self] result in
                
                guard let self = self else { return }
                
                switch result {
                case .success(let movieDetail):
                    DispatchQueue.main.async {
                        self.navigationController?.pushViewController(MovieDetailVC(movieDetail: movieDetail), animated: true)
                    }
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        self.scrollView.setContentOffset(CGPoint(x: 0, y: -self.view.safeAreaInsets.top), animated: true)
                        self.castView.collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .left, animated: true)
                        self.similarSectionView.collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .left, animated: true)
                    }
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
}
