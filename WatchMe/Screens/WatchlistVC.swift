//
//  WatchlistVC.swift
//  WatchMe
//
//  Created by Fatih Kilit on 11.08.2022.
//

import UIKit

class WatchlistVC: WMDataLoadingVC {
    
    private var contents: [ContentDetail] = []
    
    private var collectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Watchlist"
        configureCollectionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        getSavedContents()
    }
    
    private func getSavedContents() {
        Store.retrieveContents { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let contents):
                self.contents = contents
                self.collectionView.reloadDataOnMainThread()
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func configureCollectionView() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: UIHelper.createWatchlistFlowLayout())
        view.addSubview(collectionView)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.showsVerticalScrollIndicator = false
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(ContentCell.self, forCellWithReuseIdentifier: ContentCell.reuseID)
        collectionView.register(HeaderCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderCollectionReusableView.reuseID)
        
        collectionView.pinToEdges(of: view)
    }
}

extension WatchlistVC {
    private func getContentDetail(urlString: String, completion: @escaping (ContentDetail?) -> ()) {
        showLoadingView()
        
        NetworkingManager.shared.downloadContentDetail(urlString: urlString) { [weak self] result in
            guard let _ = self else { return }
            self?.dismissLoadingView()
            
            switch result {
            case .success(let contentDetail):
                completion(contentDetail)
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

extension WatchlistVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        contents.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let contentResult = contents[indexPath.row].asContentResult
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ContentCell.reuseID, for: indexPath) as! ContentCell
        cell.set(content: contentResult)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let content = contents[indexPath.row]
        let urlString = content.isMovie ? ApiUrls.movieDetail(id: content.id?.description ?? "") : ApiUrls.showDetail(id: content.id?.description ?? "")
        
        getContentDetail(urlString: urlString) { [weak self] contentDetail in
            guard let self = self, let contentDetail = contentDetail else { return }
            
            guard let id = contentDetail.id?.description else { return }
            let urlString = contentDetail.isMovie ? ApiUrls.movieVideo(id: id) : ApiUrls.showVideo(id: id)
            
            self.getVideo(urlString: urlString) { [weak self] videoResult in
                guard let self = self else { return }
                DispatchQueue.main.async {
                    self.navigationController?.pushViewController(ContentDetailVC(contentDetail: contentDetail, videoResult: videoResult), animated: true)
                }
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderCollectionReusableView.reuseID, for: indexPath) as! HeaderCollectionReusableView
        header.setHeader(text: "My Movies & Shows")
        
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        CGSize(width: 0, height: 70)
    }
}
