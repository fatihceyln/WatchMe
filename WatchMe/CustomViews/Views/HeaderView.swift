//
//  HeaderView.swift
//  WatchMe
//
//  Created by Fatih Kilit on 13.08.2022.
//

import UIKit

enum HeaderType {
    case movie, show
}

class HeaderView: UIView {
    
    private var superContainerView: UIStackView!
    
    private var posterImageView: WMPosterImageView!
    private var titleLabel: WMTitleLabel!
    
    private var attributesStackView: UIStackView!
    private var dateLabel: WMLabelWithImage!
    private var genreLabel: WMLabelWithImage!
    private var runtimeLabel: WMLabelWithImage!
    private var statusLabel: WMLabelWithImage!
    
    private var headerType: HeaderType!
    
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
    
    func setHeaderView(movieDetail: MovieDetail) {
        posterImageView.downloadImage(urlString: ApiUrls.image(path: movieDetail.posterPath ?? ""))
        titleLabel.text = movieDetail.title
        dateLabel.setWMLabelWithImage(text: movieDetail.releaseDateString, systemImage: SystemImages.calendarImage)
        genreLabel.setWMLabelWithImage(text: movieDetail.genresString, systemImage: SystemImages.filmImage)
        runtimeLabel.setWMLabelWithImage(text: movieDetail.runtimeString, systemImage: SystemImages.clockImage)
    }
    
    func setHeaderView(showDetail: ShowDetail) {
        configureStatusLabel()
        
        posterImageView.downloadImage(urlString: ApiUrls.image(path: showDetail.posterPath ?? ""))
        titleLabel.text = showDetail.name
        dateLabel.setWMLabelWithImage(text: showDetail.startEndDate, systemImage: SystemImages.calendarImage)
        genreLabel.setWMLabelWithImage(text: showDetail.genresString, systemImage: SystemImages.filmImage)
        runtimeLabel.setWMLabelWithImage(text: showDetail.season, systemImage: SystemImages.clockImage)
        statusLabel.setWMLabelWithImage(text: showDetail.status, systemImage: SystemImages.infoImage)
    }
    
    private func configureView() {
        superContainerView.addArrangedSubview(self)
        
        translatesAutoresizingMaskIntoConstraints = false
        
        heightAnchor.constraint(equalToConstant: 250).isActive = true
    }
    
    private func configurePosterImageView() {
        posterImageView = WMPosterImageView(frame: .zero)
        addSubview(posterImageView)
        
        NSLayoutConstraint.activate([
            posterImageView.topAnchor.constraint(equalTo: topAnchor, constant: padding),
            posterImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            posterImageView.widthAnchor.constraint(equalToConstant: 150),
            posterImageView.heightAnchor.constraint(equalToConstant: 225)
        ])
        
        posterImageView.backgroundColor = .gray.withAlphaComponent(0.15)
    }
    
    private func configureTitleLabel() {
        titleLabel = WMTitleLabel(textAlignment: .left, fontSize: 22)
        addSubview(titleLabel)
        
        titleLabel.numberOfLines = 2
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: posterImageView.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: posterImageView.trailingAnchor, constant: 2 * padding),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
            titleLabel.heightAnchor.constraint(equalToConstant: 50)
        ])
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
        dateLabel = WMLabelWithImage()
        attributesStackView.addArrangedSubview(dateLabel)
    }
    
    private func configureGenreLabel() {
        genreLabel = WMLabelWithImage()
        attributesStackView.addArrangedSubview(genreLabel)
    }
    
    private func configureRuntimeLabel() {
        runtimeLabel = WMLabelWithImage()
        attributesStackView.addArrangedSubview(runtimeLabel)
    }
    
    private func configureStatusLabel() {
        statusLabel = WMLabelWithImage()
        attributesStackView.addArrangedSubview(statusLabel)
    }
}
