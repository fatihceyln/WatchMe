//
//  CastView.swift
//  WatchMe
//
//  Created by Fatih Kilit on 14.08.2022.
//

import UIKit

class CastView: UIStackView {
    
    private var superContainerView: UIStackView!
    private var titleLabel: WMTitleLabel!

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(superContainerView: UIStackView) {
        super.init(frame: .zero)
        self.superContainerView = superContainerView
        
        configureCastView()
        configureTitleLabel()
        configureCollectionView()
    }
    
    private func configureCastView() {
        superContainerView.addArrangedSubview(self)
        
        translatesAutoresizingMaskIntoConstraints = false
        axis = .vertical
        distribution = .fill
        spacing = 10
        
        backgroundColor = .systemPink
    }
    
    private func configureTitleLabel() {
        titleLabel = WMTitleLabel(textAlignment: .left, fontSize: 26)
        
        addArrangedSubview(titleLabel)
        
        titleLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        titleLabel.text = "Top Billed Cast"
    }
    
    private func configureCollectionView() {
        let view = UIView(frame: .zero)
        addArrangedSubview(view)
        
        view.translatesAutoresizingMaskIntoConstraints = false
        
        view.heightAnchor.constraint(equalToConstant: 300).isActive = true
        
        view.backgroundColor = .yellow
    }
    
}
