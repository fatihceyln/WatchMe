//
//  DetailVC.swift
//  WatchMe
//
//  Created by Fatih Kilit on 13.08.2022.
//

import UIKit

class DetailVC: UIViewController {
    
    private var scrollView: UIScrollView!
    private var containerStackView: UIStackView!
    
    private var headerView: HeaderView!
    private var overviewLabel: WMBodyLabel!
    private var castView: CastView!
    private var similarSectionView: SectionView!
    
    private let padding: CGFloat = 16
    
    private var movieDetail: MovieDetail!
    private var cast: [Cast] = []
    
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
        
        configureScrollView()
        configureContainerStackView()
        
        configureHeaderView()
        configureOverviewLabel()
        configureCastView()
        configureSimilarSectionView()
        
        getCast()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
}

extension DetailVC {
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
}

extension DetailVC {
    private func configureHeaderView() {
        headerView = HeaderView(superContainerView: containerStackView)
        headerView.setHeaderView(movieDetail: movieDetail)
    }
    
    private func configureOverviewLabel() {
        overviewLabel = WMBodyLabel(textAlignment: .left)
        containerStackView.addArrangedSubview(overviewLabel)
        
        overviewLabel.text = movieDetail?.overview
    }
    
    private func configureCastView() {
        castView = CastView(superContainerView: containerStackView)
        castView.collectionView.delegate = self
        castView.collectionView.dataSource = self
    }
    
    private func configureSimilarSectionView() {
        similarSectionView = SectionView(containerStackView: containerStackView, title: "Similar Movies")
    }
}

extension DetailVC {
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

extension DetailVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        cast.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TopBilledCell.reuseID, for: indexPath) as! TopBilledCell
        cell.set(cast: cast[indexPath.row])
        
        return cell
    }
}
