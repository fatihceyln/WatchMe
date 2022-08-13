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
    
    private var shouldDownloadMore: Bool = false
    private var page: Int = 1
    
    
    private var popularSectionView: SectionView!
    private var nowPlayingSectionView: SectionView!

    override func viewDidLoad() {
        super.viewDidLoad()

        configureVC()
        
        configureScrollView()
        configureStackView()
        
        configurePopularSectionView()
//        configureNowPlayingSectionView()
        
        getPopularMovies(page: page)
//        getNowPlayingMovies(page: page)
    }
}

//MARK: SECTION VIEWS
extension MoviesVC {
    private func configurePopularSectionView() {
        popularSectionView = SectionView(stackView: stackView, topAnchorPoint: stackView.topAnchor, title: "Popular Movies")
        popularSectionView.collectionView.delegate = self
        popularSectionView.collectionView.dataSource = self
    }
    
    private func configureNowPlayingSectionView() {
        nowPlayingSectionView = SectionView(stackView: stackView, topAnchorPoint: popularSectionView.bottomAnchor, title: "Now Playing")
        nowPlayingSectionView.collectionView.delegate = self
        nowPlayingSectionView.collectionView.dataSource = self
    }
}

// MARK: DELEGATE, DATASOURCE
extension MoviesVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == popularSectionView.collectionView {
            return popularMovies.count
        }
        
        return nowPlayingMovies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == popularSectionView.collectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ContentCell.reuseID, for: indexPath) as! ContentCell
            cell.set(movie: popularMovies[indexPath.row])
            
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ContentCell.reuseID, for: indexPath) as! ContentCell
            cell.set(movie: nowPlayingMovies[indexPath.row])
            
            return cell
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetX = scrollView.contentOffset.x
        let contentWidth = scrollView.contentSize.width
        let width = scrollView.frame.width

        if offsetX >= contentWidth - (width * 3) && shouldDownloadMore {
            shouldDownloadMore = false
            print("Downloading")
            self.page += 1

            if scrollView == nowPlayingSectionView.collectionView {
                print("GET LATEST")
            } else {
                print("GET POPULAR")
            }
        }
    }
}

// MARK: GET METHODS
extension MoviesVC {
    private func getPopularMovies(page: Int) {
        shouldDownloadMore = false
        NetworkingManager.shared.downloadMovies(urlString: ApiUrls.popularMovies(page: page)) { [weak self] result in
            guard let self = self else { return }
            self.shouldDownloadMore = true
            
            switch result {
            case .success(let popularMovies):
                self.popularMovies.append(contentsOf: popularMovies)
                self.popularSectionView.collectionView.reloadDataOnMainThread()
            case .failure(let error):
                print(error.rawValue)
            }
        }
    }
    
    private func getNowPlayingMovies(page: Int) {
        shouldDownloadMore = false
        NetworkingManager.shared.downloadMovies(urlString: ApiUrls.nowPlayingMovies(page: page)) { [weak self] result in
            guard let self = self else { return }
            self.shouldDownloadMore = true
            
            switch result {
            case .success(let nowPlayingMovies):
                self.nowPlayingMovies.append(contentsOf: nowPlayingMovies)
                self.nowPlayingSectionView.collectionView.reloadDataOnMainThread()
            case .failure(let error):
                print(error.rawValue)
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
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 20
        
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
