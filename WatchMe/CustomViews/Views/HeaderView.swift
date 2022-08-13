//
//  HeaderView.swift
//  WatchMe
//
//  Created by Fatih Kilit on 13.08.2022.
//

import UIKit

class HeaderView: UIView {
    
    var superContainerView: UIStackView!
    
    var posterImageView: WMPosterImageView!
    var titleLabel: WMTitleLabel!
    var stackView: UIStackView!
    var dateLabel: WMBodyLabel!
    var genreLabel: WMBodyLabel!
    var runtimeLabel: WMBodyLabel!

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(superContainerView: UIStackView) {
        self.init(frame: .zero)
        self.superContainerView = superContainerView
        
        configureView()
    }
    
    private func configureView() {
        superContainerView.addSubview(self)
        
        translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: superContainerView.topAnchor),
            leadingAnchor.constraint(equalTo: superContainerView.leadingAnchor),
            trailingAnchor.constraint(equalTo: superContainerView.trailingAnchor),
            heightAnchor.constraint(equalToConstant: 300)
        ])
        
        backgroundColor = .yellow
    }
}
