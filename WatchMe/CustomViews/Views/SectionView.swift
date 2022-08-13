//
//  SectionView.swift
//  WatchMe
//
//  Created by Fatih Kilit on 12.08.2022.
//

import UIKit

class SectionView: UIView {

    var titleLabel: WMTitleLabel!
    var collectionView: UICollectionView!
    
    var stackView: UIStackView!
    var topAnchorPoint: NSLayoutYAxisAnchor!
    var title: String!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(stackView: UIStackView, topAnchorPoint: NSLayoutYAxisAnchor, title: String) {
        self.init(frame: .zero)
        self.stackView = stackView
        self.topAnchorPoint = topAnchorPoint
        self.title = title
        
        configureContainerView()
        configureCollectionView()
        configureTitle()
    }
    
    private func configureContainerView() {
        stackView.addArrangedSubview(self)
        translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: topAnchorPoint),
            leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            trailingAnchor.constraint(equalTo: stackView.trailingAnchor),
            heightAnchor.constraint(equalToConstant: 400)
        ])
    }
    
    private func configureTitle() {
        titleLabel = WMTitleLabel(textAlignment: .left, fontSize: 26)
        addSubview(titleLabel)
        
        titleLabel.text = title
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            titleLabel.bottomAnchor.constraint(equalTo: collectionView.topAnchor, constant: -10),
            titleLabel.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    private func configureCollectionView() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: UIHelper.createFlowLayout())
        addSubview(collectionView)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        collectionView.backgroundColor = .systemBackground
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(ContentCell.self, forCellWithReuseIdentifier: ContentCell.reuseID)
        
        NSLayoutConstraint.activate([
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            collectionView.heightAnchor.constraint(equalToConstant: 320)
        ])
    }
}
