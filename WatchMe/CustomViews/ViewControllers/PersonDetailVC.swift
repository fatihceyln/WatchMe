//
//  ActorDetailVC.swift
//  WatchMe
//
//  Created by Fatih Kilit on 20.08.2022.
//

import UIKit

class PersonDetailVC: UIViewController {
    
    private var scrollView: UIScrollView!
    private var containerStackView: UIStackView!
    
    private var headerView: PersonHeaderView!
    private var biographyLabel: WMBodyLabel!
    private var showMoreButton: UIButton!
    private var moviesSectionView: SectionView!
    private var showsSectionView: SectionView!
    
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
        
        configureScrollView()
        configureContainerStackView()
        
        configureHeaderView()
        configureBiographyLabel()
        configureShowMoreButton()
        
        configureMoviesSectionView()
        configureShowsSectionView()
    }
}

extension PersonDetailVC {

}

extension PersonDetailVC {
    private func configureHeaderView() {
        headerView = PersonHeaderView(superContainerView: containerStackView, person: person)
    }
    
    private func configureBiographyLabel() {
        biographyLabel = WMBodyLabel(textAlignment: .left)
        containerStackView.addArrangedSubview(biographyLabel)
        
        biographyLabel.text = person.biography
        biographyLabel.numberOfLines = 5
    }
    
    private func configureShowMoreButton() {
        showMoreButton = UIButton(frame: .zero)
        containerStackView.addArrangedSubview(showMoreButton)
        containerStackView.setCustomSpacing(0, after: biographyLabel)
        
        showMoreButton.translatesAutoresizingMaskIntoConstraints = false
        
        showMoreButton.setTitle("Show more", for: .normal)
        showMoreButton.contentHorizontalAlignment = .left
        showMoreButton.tintColor = .link
        
        showMoreButton.addTarget(self, action: #selector(showMoreButtonAction), for: .touchUpInside)
    }
    
    @objc private func showMoreButtonAction() {
        if !isShowingMore {
            showMoreButton.setTitle("Show less", for: .normal)
            biographyLabel.numberOfLines = 0
            isShowingMore = true
        } else {
            showMoreButton.setTitle("Show more", for: .normal)
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
}

extension PersonDetailVC {
    private func configureScrollView() {
        scrollView = UIScrollView(frame: .zero)
        view.addSubview(scrollView)
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
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
