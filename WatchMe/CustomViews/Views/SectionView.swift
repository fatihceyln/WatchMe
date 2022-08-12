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
    
    var superView: UIView!
    var topAnchorPoint: NSLayoutYAxisAnchor!
    var title: String!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(superView: UIView, topAnchorPoint: NSLayoutYAxisAnchor, title: String) {
        self.init(frame: .zero)
        self.superView = superView
        self.topAnchorPoint = topAnchorPoint
        self.title = title
        
        configureContainerView()
        configureTitle()
        configureCollectionView()
    }
    
    private func configureContainerView() {
        superView.addSubview(self)
        translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: topAnchorPoint, constant: 50),
            leadingAnchor.constraint(equalTo: superView.leadingAnchor, constant: 10),
            trailingAnchor.constraint(equalTo: superView.trailingAnchor, constant: -10),
            heightAnchor.constraint(equalToConstant: 420)
        ])
    }
    
    private func configureTitle() {
        titleLabel = WMTitleLabel(textAlignment: .left, fontSize: 26)
        addSubview(titleLabel)
        
        titleLabel.text = title
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
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
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.heightAnchor.constraint(equalToConstant: 360)
        ])
    }
}
