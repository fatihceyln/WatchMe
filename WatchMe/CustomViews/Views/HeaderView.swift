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
    
    let padding: CGFloat = 10

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
        configurePosterImageView()
        configureTitleLabel()
    }
    
    private func configureView() {
        superContainerView.addSubview(self)
        
        translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: superContainerView.topAnchor),
            leadingAnchor.constraint(equalTo: superContainerView.leadingAnchor),
            trailingAnchor.constraint(equalTo: superContainerView.trailingAnchor),
            heightAnchor.constraint(equalToConstant: 250)
        ])
        
        backgroundColor = .yellow
    }
    
    private func configurePosterImageView() {
        posterImageView = WMPosterImageView(frame: .zero)
        addSubview(posterImageView)
        
        NSLayoutConstraint.activate([
            posterImageView.topAnchor.constraint(equalTo: topAnchor, constant: padding),
            posterImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            posterImageView.widthAnchor.constraint(equalToConstant: 150),
            posterImageView.heightAnchor.constraint(equalToConstant: 225)
        ])
        
        posterImageView.backgroundColor = .red
    }
    
    private func configureTitleLabel() {
        titleLabel = WMTitleLabel(textAlignment: .left, fontSize: 20)
        addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: posterImageView.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: posterImageView.trailingAnchor, constant: 2 * padding),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
            titleLabel.heightAnchor.constraint(equalToConstant: 23)
        ])
        
        titleLabel.backgroundColor = .black
    }
}
