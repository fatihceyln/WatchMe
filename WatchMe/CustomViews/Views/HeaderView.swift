//
//  HeaderView.swift
//  WatchMe
//
//  Created by Fatih Kilit on 13.08.2022.
//

import UIKit

class HeaderView: UIView {
    
    var superContainerView: UIView!
    
    private var posterImageView: WMPosterImageView!
    private var titleLabel: WMTitleLabel!
    
    private var dateLabel: WMLabelWithImage!
    private var genreLabel: WMLabelWithImage!
    private var runtimeLabel: WMLabelWithImage!
    
    private var attributesStackView: UIStackView!
    
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
        
        configureAttributesStackView()
        configureDateLabel()
        configureGenreLabel()
        configureRuntimeLabel()
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
        
        posterImageView.backgroundColor = .gray.withAlphaComponent(0.15)
    }
    
    private func configureTitleLabel() {
        titleLabel = WMTitleLabel(textAlignment: .left, fontSize: 22)
        addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: posterImageView.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: posterImageView.trailingAnchor, constant: 2 * padding),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
            titleLabel.heightAnchor.constraint(equalToConstant: 25)
        ])
        
        titleLabel.text = "Thor: Love and Thunder"
    }
    
    private func configureAttributesStackView() {
        attributesStackView = UIStackView(frame: .zero)
        addSubview(attributesStackView)
        
        attributesStackView.translatesAutoresizingMaskIntoConstraints = false
        attributesStackView.axis = .vertical
        attributesStackView.distribution = .fillEqually
        
        NSLayoutConstraint.activate([
            attributesStackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 3 * padding),
            attributesStackView.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            attributesStackView.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            attributesStackView.heightAnchor.constraint(equalToConstant: 110)
        ])
    }
    
    private func configureDateLabel() {
        dateLabel = WMLabelWithImage(text: "07/08/2022", systemName: "calendar")
        attributesStackView.addArrangedSubview(dateLabel)
    }
    
    private func configureGenreLabel() {
        genreLabel = WMLabelWithImage(text: "Action, Adventure, Fantasy", systemName: "film")
        attributesStackView.addArrangedSubview(genreLabel)
    }
    
    private func configureRuntimeLabel() {
        runtimeLabel = WMLabelWithImage(text: "1h 59m", systemName: "clock")
        attributesStackView.addArrangedSubview(runtimeLabel)
    }
}
