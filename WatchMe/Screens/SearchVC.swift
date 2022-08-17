//
//  SearchVC.swift
//  WatchMe
//
//  Created by Fatih Kilit on 11.08.2022.
//

import UIKit

class SearchVC: UIViewController {
    
    var searchBar: UISearchBar!
    var collectionView: UICollectionView!
    
    private var exploreContent: [MovieResult] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        configureSearchBar()
        configureCollectionView()
        getExploreContent()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        configureVC()
    }
    
    private func configureSearchBar() {
        searchBar = UISearchBar(frame: .zero)
        view.addSubview(searchBar)
        
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.placeholder = "Search movie or show"
        searchBar.tintColor = .red
        searchBar.returnKeyType = .search
        searchBar.delegate = self
        
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            searchBar.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    private func configureCollectionView() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: UIHelper.createExploreFlowLayout())
        view.addSubview(collectionView)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(ContentCell.self, forCellWithReuseIdentifier: ContentCell.reuseID)
        collectionView.backgroundColor = .systemBackground
        collectionView.showsVerticalScrollIndicator = false
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 10),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

extension SearchVC {
    private func getExploreContent() {
        NetworkingManager.shared.downloadMovies(urlString: ApiUrls.discoverMovies(page: 1)) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let exploreMovies):
                self.exploreContent.append(contentsOf: exploreMovies)
                self.exploreContent.shuffle()
                self.collectionView.reloadDataOnMainThread()
            case .failure(let error):
                print(error)
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

extension SearchVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        exploreContent.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ContentCell.reuseID, for: indexPath) as! ContentCell
        cell.set(movie: exploreContent[indexPath.row])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        getMovieDetail(id: exploreContent[indexPath.row].id?.description ?? "") { [weak self] movieDetail in
            guard let self = self, let movieDetail = movieDetail else { return }
            
            DispatchQueue.main.async {
                self.navigationController?.pushViewController(MovieDetailVC(movieDetail: movieDetail), animated: true)
            }
        }
    }
}

extension SearchVC: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.resignFirstResponder()
        searchBar.setShowsCancelButton(false, animated: true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
    }
}

extension SearchVC {
    private func configureVC() {
        navigationController?.setNavigationBarHidden(true, animated: true)
        view.backgroundColor = .systemBackground
        navigationItem.backButtonTitle = "Search"
    }
}
