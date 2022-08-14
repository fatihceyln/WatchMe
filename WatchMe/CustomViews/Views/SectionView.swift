//
//  SectionView.swift
//  WatchMe
//
//  Created by Fatih Kilit on 12.08.2022.
//

import UIKit

class SectionView: UIStackView {

    private var containerStackView: UIStackView!
    private var titleLabel: WMTitleLabel!
    var collectionView: UICollectionView!
    private var title: String!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(containerStackView: UIStackView, title: String) {
        self.init(frame: .zero)
        self.containerStackView = containerStackView
        self.title = title
        
        configureCastView()
        configureTitle()
        configureCollectionView()
    }
    
    private func configureCastView() {
        containerStackView.addArrangedSubview(self)
        
        translatesAutoresizingMaskIntoConstraints = false
        
        axis = .vertical
        distribution = .fill
        spacing = 5
    }
    
    private func configureTitle() {
        titleLabel = WMTitleLabel(textAlignment: .left, fontSize: 26)
        addArrangedSubview(titleLabel)
        
        titleLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        titleLabel.text = title
    }
    
    private func configureCollectionView() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: UIHelper.createFlowLayout())
        addArrangedSubview(collectionView)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        collectionView.backgroundColor = .systemBackground
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(ContentCell.self, forCellWithReuseIdentifier: ContentCell.reuseID)
        
        collectionView.heightAnchor.constraint(equalToConstant: 300).isActive = true
    }
}
