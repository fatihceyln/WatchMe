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
    private var moviesSectionView: SectionView!
    private var showsSectionView: SectionView!
    
    private var person: Person!
    
    private var movies: [ContentDetail] = []
    private var shows: [ContentDetail] = []
    
    private let padding: CGFloat = 10
    
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
    }
}

extension PersonDetailVC {

}

extension PersonDetailVC {
    private func configureHeaderView() {
        headerView = PersonHeaderView(superContainerView: containerStackView, person: person)
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
