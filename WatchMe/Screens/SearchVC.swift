//
//  SearchVC.swift
//  WatchMe
//
//  Created by Fatih Kilit on 11.08.2022.
//

import UIKit

class SearchVC: WMDataLoadingVC {
    
    var searchBar: UISearchBar!
    var collectionView: UICollectionView!
    
    private var exploreContent: [ContentResult] = []
    
    private var searchText: String = ""
    
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
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        searchBar.resignFirstResponder()
        searchBar.setShowsCancelButton(false, animated: true)
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
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
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
        collectionView.register(HeaderCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderCollectionReusableView.reuseID)
        
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
        
        showLoadingView()
        var reloadControl = false
        
        NetworkingManager.shared.downloadContent(urlString: ApiUrls.trendMovies()) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let exploreMovies):
                self.exploreContent.append(contentsOf: exploreMovies)
                if reloadControl {
                    self.exploreContent.shuffle()
                    self.collectionView.reloadDataOnMainThread()
                    self.dismissLoadingView()
                }
                reloadControl = true
            case .failure(let error):
                print(error)
            }
        }
        
        NetworkingManager.shared.downloadContent(urlString: ApiUrls.trendShows()) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let exploreMovies):
                self.exploreContent.append(contentsOf: exploreMovies)
                if reloadControl {
                    self.exploreContent.shuffle()
                    self.collectionView.reloadDataOnMainThread()
                    self.dismissLoadingView()
                }
                reloadControl = true
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func getContentDetail(urlString: String, completion: @escaping (ContentDetail?) -> ()) {
        showLoadingView()
        NetworkingManager.shared.downloadContentDetail(urlString: urlString) { [weak self] result in
            guard let self = self else { return }
            self.dismissLoadingView()
            
            switch result {
            case .success(let movieDetail):
                completion(movieDetail)
            case .failure(let error):
                print(error)
                completion(nil)
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

extension SearchVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        exploreContent.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ContentCell.reuseID, for: indexPath) as! ContentCell
        cell.set(content: exploreContent[indexPath.row])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if exploreContent[indexPath.row].name != nil {
            guard let id = exploreContent[indexPath.row].id?.description else { return }
            let urlString = ApiUrls.showDetail(id: id)
            getContentDetail(urlString: urlString) { [weak self] contentDetail in
                guard let self = self, let contentDetail = contentDetail else { return }
                
                guard let id = contentDetail.id?.description else { return }
                let urlString = ApiUrls.showVideo(id: id)
                
                self.getVideo(urlString: urlString) { [weak self] videoResult in
                    guard let self = self else { return }
                    DispatchQueue.main.async {
                        self.navigationController?.pushViewController(ContentDetailVC(contentDetail: contentDetail, videoResult: videoResult), animated: true)
                    }
                }
            }
        } else {
            guard let id = exploreContent[indexPath.row].id?.description else { return }
            let urlString = ApiUrls.movieDetail(id: id)
            getContentDetail(urlString: urlString) { [weak self] contentDetail in
                guard let self = self, let contentDetail = contentDetail else { return }
                
                guard let id = contentDetail.id?.description else { return }
                let urlString = ApiUrls.movieVideo(id: id)
                
                self.getVideo(urlString: urlString) { [weak self] videoResult in
                    guard let self = self else { return }
                    DispatchQueue.main.async {
                        self.navigationController?.pushViewController(ContentDetailVC(contentDetail: contentDetail, videoResult: videoResult), animated: true)
                    }
                }
            }
        }
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderCollectionReusableView.reuseID, for: indexPath) as! HeaderCollectionReusableView
        header.setHeader(text: "Explore")
        
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        CGSize(width: collectionView.bounds.width, height: 70)
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
        searchText = searchBar.text!
        searchText = searchText
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .replacingOccurrences(of: " ", with: "%20")
            .folding(options: .diacriticInsensitive, locale: .current)
            .lowercased()
        
        getSearchedContents(query: searchText)
        searchBar.text = ""
        searchBar.resignFirstResponder()
        searchBar.setShowsCancelButton(false, animated: true)
    }
}

extension SearchVC {
    private func getSearchedContents(query: String) {
        showLoadingView()
        NetworkingManager.shared.downloadContentBySearch(urlString: ApiUrls.multiSearch(query: query)) { [weak self] result in
            guard let self = self else { return }
            self.dismissLoadingView()
            
            switch result {
            case .success(let contents):
                guard !contents.isEmpty else { return }
                DispatchQueue.main.async {
                    self.navigationController?.pushViewController(SearchResultVC(contents: contents, query: query.capitalized.replacingOccurrences(of: "%20", with: " ")), animated: true)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}

extension SearchVC {
    private func configureVC() {
        navigationController?.setNavigationBarHidden(true, animated: true)
        view.backgroundColor = .systemBackground
        navigationItem.backButtonTitle = "Search"
    }
}
