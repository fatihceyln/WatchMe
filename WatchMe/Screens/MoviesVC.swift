//
//  MoviesVC.swift
//  WatchMe
//
//  Created by Fatih Kilit on 11.08.2022.
//

import UIKit

class MoviesVC: UIViewController {
    
    private var scrollView: UIScrollView!
    private var contentView: UIView!
    
    private var collectionView: UICollectionView!
    
    private var popularMoviesResult: [PopularMoviesResult] = []
    
    private var shouldDownloadMore: Bool = false
    private var page: Int = 1

    override func viewDidLoad() {
        super.viewDidLoad()

        configureVC()
        
        configureScrollView()
        configureContentView()
        configureCollectionView()
        
        getPopularMovies(page: page)
    }
    
    private func getPopularMovies(page: Int) {
        shouldDownloadMore = false
        NetworkingManager.shared.getPopularMovies(page: page) { [weak self] result in
            guard let self = self else { return }
            self.shouldDownloadMore = true
            
            switch result {
            case .success(let popularMovies):
                self.popularMoviesResult.append(contentsOf: popularMovies)
                self.collectionView.reloadDataOnMainThread()
            case .failure(let error):
                print(error.rawValue)
            }
        }
    }
    
    private func configureCollectionView() {
        
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: UIHelper.createFlowLayout())
        contentView.addSubview(collectionView)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.backgroundColor = .systemBackground
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(ContentCell.self, forCellWithReuseIdentifier: ContentCell.reuseID)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            collectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            collectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            collectionView.heightAnchor.constraint(equalToConstant: 400)
        ])
    }
    
    private func configureScrollView() {
        scrollView = UIScrollView(frame: .zero)
        view.addSubview(scrollView)
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        scrollView.pinToEdges(of: view)
    }
    
    private func configureContentView() {
        contentView = UIView(frame: .zero)
        scrollView.addSubview(contentView)
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.pinToEdges(of: scrollView)
        
        // widthAnchor and heightAnchor have to be specified.
        NSLayoutConstraint.activate([
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            contentView.heightAnchor.constraint(equalTo: scrollView.heightAnchor)
        ])
    }
    
    private func configureVC() {
        navigationController?.setNavigationBarHidden(true, animated: true)
        view.backgroundColor = .systemBackground
    }
}

extension MoviesVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        popularMoviesResult.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ContentCell.reuseID, for: indexPath) as! ContentCell
        cell.set(movie: popularMoviesResult[indexPath.row])
        
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetX = scrollView.contentOffset.x
        let contentWidth = scrollView.contentSize.width
        let width = scrollView.frame.width

        if offsetX >= contentWidth - (width * 3) && shouldDownloadMore {
            shouldDownloadMore = false
            print("Downloading")
            self.page += 1

            getPopularMovies(page: page)
        }
    }
}
