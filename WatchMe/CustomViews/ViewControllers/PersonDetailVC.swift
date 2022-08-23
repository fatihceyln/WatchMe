//
//  ActorDetailVC.swift
//  WatchMe
//
//  Created by Fatih Kilit on 20.08.2022.
//

import UIKit

class PersonDetailVC: WMDataLoadingVC {
    
    private var scrollView: UIScrollView!
    private var containerStackView: UIStackView!
    
    private var headerView: PersonHeaderView!
    private var biographyLabel: WMBodyLabel!
    private var showMoreButton: UIButton!
    private var moviesSectionView: SectionView!
    private var showsSectionView: SectionView!
    
    private var emptyView: UIView!
    
    private var person: Person!
    
    private var movies: [ContentResult] = []
    private var shows: [ContentResult] = []
    
    private let padding: CGFloat = 10
    private var isShowingMore: Bool = false
    
    init(actor: Person) {
        super.init(nibName: nil, bundle: nil)
        self.person = actor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        navigationItem.backButtonTitle = ""
        title = person.name
        
        configureScrollView()
        configureContainerStackView()
        
        configureHeaderView()
        configureBiographyLabel()
        configureShowMoreButton()
        
        configureMoviesSectionView()
        configureShowsSectionView()
        
        getPersonShows()
        getPersonMovies()
    }
}

extension PersonDetailVC {
    private func getPersonShows() {
        guard let personId = person.id?.description else { return }
        let urlString = ApiUrls.personShows(personId: personId)
        
        NetworkingManager.shared.downloadPersonContent(urlString: urlString) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let contents):
                if contents.isEmpty {
                    self.configureEmptyView(superStackView: self.containerStackView, collectionView: self.showsSectionView.collectionView, message: "The person haven't played in a show so far.")
                    return
                }
                
                self.shows = contents
                self.showsSectionView.collectionView.reloadDataOnMainThread()
            case .failure(let error):
                self.configureEmptyView(superStackView: self.containerStackView, collectionView: self.showsSectionView.collectionView, message: "The person haven't played in a show so far.")
                print(error)
            }
        }
    }
    
    private func getPersonMovies() {
        guard let personId = person.id?.description else { return }
        let urlString = ApiUrls.personMovies(personId: personId)
        
        NetworkingManager.shared.downloadPersonContent(urlString: urlString) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let contents):
                if contents.isEmpty {
                    self.configureEmptyView(superStackView: self.containerStackView, collectionView: self.moviesSectionView.collectionView, message: "The person haven't played in a movie so far.")
                    return
                }
                
                self.movies = contents
                self.moviesSectionView.collectionView.reloadDataOnMainThread()
            case .failure(let error):
                self.configureEmptyView(superStackView: self.containerStackView, collectionView: self.moviesSectionView.collectionView, message: "The person haven't played in a movie so far.")
                print(error)
            }
        }
    }
}

extension PersonDetailVC {
    private func configureHeaderView() {
        headerView = PersonHeaderView(superContainerView: containerStackView, person: person)
    }
    
    private func configureBiographyLabel() {
        biographyLabel = WMBodyLabel(textAlignment: .left)
        containerStackView.addArrangedSubview(biographyLabel)
        
        biographyLabel.text = person.biography
    }
    
    private func configureShowMoreButton() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            if self.biographyLabel.lineCount > 5 {
                self.biographyLabel.numberOfLines = 5
            } else {
                self.showMoreButton.isHidden = true
                self.containerStackView.setCustomSpacing(2 * self.padding, after: self.biographyLabel)
            }
        }
        
        showMoreButton = UIButton(frame: .zero)
        containerStackView.addArrangedSubview(showMoreButton)
        containerStackView.setCustomSpacing(0, after: biographyLabel)
        
        showMoreButton.translatesAutoresizingMaskIntoConstraints = false
        
        showMoreButton.setTitle("Read more...", for: .normal)
        showMoreButton.contentHorizontalAlignment = .left
        showMoreButton.setTitleColor(.link, for: .normal)
        
        showMoreButton.addTarget(self, action: #selector(showMoreButtonAction), for: .touchUpInside)
    }
    
    @objc private func showMoreButtonAction() {
        if !isShowingMore {
            showMoreButton.setTitle("Less", for: .normal)
            biographyLabel.numberOfLines = 0
            isShowingMore = true
        } else {
            showMoreButton.setTitle("Read more...", for: .normal)
            biographyLabel.numberOfLines = 5
            isShowingMore = false
        }
    }
    
    private func configureMoviesSectionView() {
        moviesSectionView = SectionView(containerStackView: containerStackView, title: "Movies")
        moviesSectionView.collectionView.delegate = self
        moviesSectionView.collectionView.dataSource = self
    }
    
    private func configureShowsSectionView() {
        showsSectionView = SectionView(containerStackView: containerStackView, title: "Shows")
        showsSectionView.collectionView.delegate = self
        showsSectionView.collectionView.dataSource = self
    }
}

extension PersonDetailVC {
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
}

extension PersonDetailVC {
    private func getContent(urlString: String) {
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

extension PersonDetailVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == moviesSectionView.collectionView {
            return movies.count
        }
        
        return shows.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ContentCell.reuseID, for: indexPath) as! ContentCell
        
        if collectionView == moviesSectionView.collectionView {
            cell.set(content: movies[indexPath.row])
            
            return cell
        }
        
        cell.set(content: shows[indexPath.row])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == moviesSectionView.collectionView {
            guard let contentId = movies[indexPath.row].id?.description else { return }
            let urlString = ApiUrls.movieDetail(id: contentId)
            
            getContent(urlString: urlString)
        } else if collectionView == showsSectionView.collectionView {
            guard let contentId = shows[indexPath.row].id?.description else { return }
            let urlString = ApiUrls.showDetail(id: contentId)
            
            getContent(urlString: urlString)
        }
    }
}

extension PersonDetailVC {
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
        containerStackView.spacing = 2 * padding
        
        containerStackView.pinToEdges(of: scrollView)
        containerStackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
    }
}
