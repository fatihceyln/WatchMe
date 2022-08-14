//
//  MoviesVC.swift
//  WatchMe
//
//  Created by Fatih Kilit on 11.08.2022.
//

import UIKit


class MoviesVC: UIViewController {
    
    private var scrollView: UIScrollView!
    private var stackView: UIStackView!
    
    private var popularMovies: [MovieResult] = []
    private var nowPlayingMovies: [MovieResult] = []
    private var upcomingMovies: [MovieResult] = []
    private var topRatedMovies: [MovieResult] = []
        
    private var popularMoviesPagination: PaginationControl = PaginationControl(shouldDownloadMore: false, page: 1)
    private var nowPlayingMoviesPagination: PaginationControl = PaginationControl(shouldDownloadMore: false, page: 1)
    private var upcomingMoviesPagination: PaginationControl = PaginationControl(shouldDownloadMore: false, page: 1)
    private var topRatedMoviesPagination: PaginationControl = PaginationControl(shouldDownloadMore: false, page: 1)
    
    
    private var popularSectionView: SectionView!
    private var nowPlayingSectionView: SectionView!
    private var upcomingSectionView: SectionView!
    private var topRatedSectionView: SectionView!
    
    private let padding: CGFloat = 10

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureScrollView()
        configureStackView()
        
        configurePopularSectionView()
        configureNowPlayingSectionView()
        configureUpcomingSectionView()
        configureTopRatedSectionView()
        
        getPopularMovies(page: popularMoviesPagination.page)
        getNowPlayingMovies(page: nowPlayingMoviesPagination.page)
        getUpcomingMovies(page: upcomingMoviesPagination.page)
        getTopRatedMovies(page: topRatedMoviesPagination.page)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        configureVC()
    }
}

//MARK: SECTION VIEWS
extension MoviesVC {
    private func configurePopularSectionView() {
        popularSectionView = SectionView(containerStackView: stackView, title: "Popular")
        popularSectionView.collectionView.delegate = self
        popularSectionView.collectionView.dataSource = self
    }
    
    private func configureNowPlayingSectionView() {
        nowPlayingSectionView = SectionView(containerStackView: stackView, title: "Now Playing")
        nowPlayingSectionView.collectionView.delegate = self
        nowPlayingSectionView.collectionView.dataSource = self
    }
    
    private func configureUpcomingSectionView() {
        upcomingSectionView = SectionView(containerStackView: stackView, title: "Upcoming")
        upcomingSectionView.collectionView.delegate = self
        upcomingSectionView.collectionView.dataSource = self
    }
    
    private func configureTopRatedSectionView() {
        topRatedSectionView = SectionView(containerStackView: stackView, title: "Top Rated")
        topRatedSectionView.collectionView.delegate = self
        topRatedSectionView.collectionView.dataSource = self
    }
}

// MARK: DELEGATE, DATASOURCE
extension MoviesVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == popularSectionView.collectionView {
            return popularMovies.count
        } else if collectionView == nowPlayingSectionView.collectionView {
            return nowPlayingMovies.count
        } else if collectionView == upcomingSectionView.collectionView {
            return upcomingMovies.count
        } else if collectionView == topRatedSectionView.collectionView {
            return topRatedMovies.count
        } else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == popularSectionView.collectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ContentCell.reuseID, for: indexPath) as! ContentCell
            cell.set(movie: popularMovies[indexPath.row])
            
            return cell
        } else if collectionView == nowPlayingSectionView.collectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ContentCell.reuseID, for: indexPath) as! ContentCell
            cell.set(movie: nowPlayingMovies[indexPath.row])
            
            return cell
        } else if collectionView == upcomingSectionView.collectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ContentCell.reuseID, for: indexPath) as! ContentCell
            cell.set(movie: upcomingMovies[indexPath.row])
            
            return cell
        } else if collectionView == topRatedSectionView.collectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ContentCell.reuseID, for: indexPath) as! ContentCell
            cell.set(movie: topRatedMovies[indexPath.row])
            
            return cell
        } else {
            return UICollectionViewCell()
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetX = scrollView.contentOffset.x
        let contentWidth = scrollView.contentSize.width
        let width = scrollView.frame.width

        if offsetX >= contentWidth - (width * 3) {
            if scrollView == popularSectionView.collectionView && popularMoviesPagination.shouldDownloadMore {
                self.popularMoviesPagination.shouldDownloadMore = false
                self.popularMoviesPagination.page += 1
                
                self.getPopularMovies(page: self.popularMoviesPagination.page)
            } else if scrollView == nowPlayingSectionView.collectionView && nowPlayingMoviesPagination.shouldDownloadMore {
                self.nowPlayingMoviesPagination.shouldDownloadMore = false
                self.nowPlayingMoviesPagination.page += 1
                
                self.getNowPlayingMovies(page: self.nowPlayingMoviesPagination.page)
            } else if scrollView == upcomingSectionView.collectionView && upcomingMoviesPagination.shouldDownloadMore {
                self.upcomingMoviesPagination.shouldDownloadMore = false
                self.upcomingMoviesPagination.page += 1
                
                self.getUpcomingMovies(page: self.upcomingMoviesPagination.page)
            } else if scrollView == topRatedSectionView.collectionView && topRatedMoviesPagination.shouldDownloadMore {
                self.topRatedMoviesPagination.shouldDownloadMore = false
                self.topRatedMoviesPagination.page += 1
                
                self.getTopRatedMovies(page: self.topRatedMoviesPagination.page)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == popularSectionView.collectionView {
            
            getMovieDetail(id: popularMovies[indexPath.row].id?.description ?? "") { [weak self] movieDetail in
                guard let movieDetail = movieDetail else { return }
                DispatchQueue.main.async {
                    self?.navigationController?.pushViewController(DetailVC(movieDetail: movieDetail), animated: true)
                }
            }
            
        } else if collectionView == nowPlayingSectionView.collectionView {
        
            getMovieDetail(id: nowPlayingMovies[indexPath.row].id?.description ?? "") { [weak self] movieDetail in
                guard let movieDetail = movieDetail else { return }
                DispatchQueue.main.async {
                    self?.navigationController?.pushViewController(DetailVC(movieDetail: movieDetail), animated: true)
                }
            }
        
        } else if collectionView == upcomingSectionView.collectionView {
        
            getMovieDetail(id: upcomingMovies[indexPath.row].id?.description ?? "") { [weak self] movieDetail in
                guard let movieDetail = movieDetail else { return }
                DispatchQueue.main.async {
                    self?.navigationController?.pushViewController(DetailVC(movieDetail: movieDetail), animated: true)
                }
            }
        
        } else if collectionView == topRatedSectionView.collectionView {
        
            getMovieDetail(id: topRatedMovies[indexPath.row].id?.description ?? "") { [weak self] movieDetail in
                guard let movieDetail = movieDetail else { return }
                DispatchQueue.main.async {
                    self?.navigationController?.pushViewController(DetailVC(movieDetail: movieDetail), animated: true)
                }
            }
        
        }
    }
}

// MARK: GET METHODS
extension MoviesVC {
    private func getPopularMovies(page: Int) {
        NetworkingManager.shared.downloadMovies(urlString: ApiUrls.popularMovies(page: page)) { [weak self] result in
            guard let self = self else { return }
            self.popularMoviesPagination.shouldDownloadMore = true
            
            switch result {
            case .success(let popularMovies):
                self.popularMovies.append(contentsOf: popularMovies.filter({$0.posterPath != nil}))
                self.popularSectionView.collectionView.reloadDataOnMainThread()
            case .failure(let error):
                print(error.rawValue)
            }
        }
    }
    
    private func getNowPlayingMovies(page: Int) {
        NetworkingManager.shared.downloadMovies(urlString: ApiUrls.nowPlayingMovies(page: page)) { [weak self] result in
            guard let self = self else { return }
            self.nowPlayingMoviesPagination.shouldDownloadMore = true
            
            switch result {
            case .success(let nowPlayingMovies):
                self.nowPlayingMovies.append(contentsOf: nowPlayingMovies.filter({$0.posterPath != nil}))
                self.nowPlayingSectionView.collectionView.reloadDataOnMainThread()
            case .failure(let error):
                print(error.rawValue)
            }
        }
    }
    
    private func getUpcomingMovies(page: Int) {
        NetworkingManager.shared.downloadMovies(urlString: ApiUrls.upcomingMovies(page: page)) { [weak self] result in
            guard let self = self else { return }
            self.upcomingMoviesPagination.shouldDownloadMore = true
            
            switch result {
            case .success(let upcomingMovies):
                self.upcomingMovies.append(contentsOf: upcomingMovies.filter({$0.posterPath != nil}))
                self.upcomingSectionView.collectionView.reloadDataOnMainThread()
            case .failure(let error):
                print(error.rawValue)
            }
        }
    }
    
    private func getTopRatedMovies(page: Int) {
        NetworkingManager.shared.downloadMovies(urlString: ApiUrls.topRatedMovies(page: page)) { [weak self] result in
            guard let self = self else { return }
            self.topRatedMoviesPagination.shouldDownloadMore = true
            
            switch result {
            case .success(let topRatedMovies):
                self.topRatedMovies.append(contentsOf: topRatedMovies.filter({$0.posterPath != nil}))
                self.topRatedSectionView.collectionView.reloadDataOnMainThread()
            case .failure(let error):
                print(error.rawValue)
            }
        }
    }
    
    private func getMovieDetail(id: String, completion: @escaping (MovieDetail?) -> ()) {
        NetworkingManager.shared.downloadMovieDetail(urlString: ApiUrls.movieDetail(id: id)) { result in
            switch result {
            case .success(let movieDetail):
                completion(movieDetail)
            case .failure(let error):
                print(error)
                completion(nil)
            }
        }
    }
}

// MARK: configureScrollView, configureStackView
extension MoviesVC {
    private func configureScrollView() {
        scrollView = UIScrollView(frame: .zero)
        view.addSubview(scrollView)
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsVerticalScrollIndicator = false
        
        scrollView.pinToEdges(of: view)
    }
    
    private func configureStackView() {
        stackView = UIStackView()
        scrollView.addSubview(stackView)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = UIEdgeInsets(top: 2 * padding, left: padding, bottom: 2 * padding, right: padding)
        
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 3 * padding
        
        stackView.pinToEdges(of: scrollView)
        
        // widthAnchor have to be specified.
        NSLayoutConstraint.activate([
            stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
        ])
    }
}

// MARK: configureVC
extension MoviesVC {
    private func configureVC() {
        navigationController?.setNavigationBarHidden(true, animated: true)
        view.backgroundColor = .systemBackground
    }
}
