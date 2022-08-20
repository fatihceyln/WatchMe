//
//  HeaderView.swift
//  WatchMe
//
//  Created by Fatih Kilit on 13.08.2022.
//

import UIKit

class HeaderView: UIView {
    
    private var superContainerView: UIStackView!
    
    private var posterImageView: WMPosterImageView!
    private var titleLabel: WMTitleLabel!
    
    private var attributesStackView: UIStackView!
    private var dateLabel: WMLabelWithImage!
    private var genreLabel: WMLabelWithImage!
    private var runtimeLabel: WMLabelWithImage!
    private var statusLabel: WMLabelWithImage!
    private var ratingLabel: WMLabelWithImage!
    
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
    
    func setHeaderView(contentDetail: ContentDetail) {
        posterImageView.downloadImage(urlString: ApiUrls.image(path: contentDetail.posterPath ?? ""))
        
        if contentDetail.isMovie {
            configureRatingLabel()
            
            titleLabel.text = contentDetail.title
            dateLabel.setWMLabelWithImage(text: contentDetail.releaseDateString, systemImage: SystemImages.calendarImage)
            genreLabel.setWMLabelWithImage(text: contentDetail.genresString, systemImage: SystemImages.filmImage)
            runtimeLabel.setWMLabelWithImage(text: contentDetail.runtimeString, systemImage: SystemImages.clockImage)
            ratingLabel.setWMLabelWithImage(text: contentDetail.rating, systemImage: SystemImages.starImage)
        } else {
            configureStatusLabel()
            configureRatingLabel()
            
            titleLabel.text = contentDetail.name
            dateLabel.setWMLabelWithImage(text: contentDetail.startEndDate, systemImage: SystemImages.calendarImage)
            genreLabel.setWMLabelWithImage(text: contentDetail.genresString, systemImage: SystemImages.filmImage)
            runtimeLabel.setWMLabelWithImage(text: contentDetail.season, systemImage: SystemImages.clockImage)
            statusLabel.setWMLabelWithImage(text: contentDetail.status, systemImage: SystemImages.infoImage)
            ratingLabel.setWMLabelWithImage(text: contentDetail.rating, systemImage: SystemImages.starImage)
        }
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
        
        posterImageView.backgroundColor = .secondarySystemBackground
    }
    
    private func configureTitleLabel() {
        titleLabel = WMTitleLabel(textAlignment: .left, fontSize: 22)
        addSubview(titleLabel)
        
        titleLabel.numberOfLines = 2
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: posterImageView.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: posterImageView.trailingAnchor, constant: 2 * padding),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
        ])
    }
    
    private func configureAttributesStackView() {
        attributesStackView = UIStackView(frame: .zero)
        addSubview(attributesStackView)
        
        attributesStackView.translatesAutoresizingMaskIntoConstraints = false
        attributesStackView.axis = .vertical
        attributesStackView.distribution = .fill
        attributesStackView.spacing = padding / 2
        
        NSLayoutConstraint.activate([
            attributesStackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 2 * padding),
            attributesStackView.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            attributesStackView.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
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
    
    private func configureRatingLabel() {
        ratingLabel = WMLabelWithImage()
        attributesStackView.addArrangedSubview(ratingLabel)
    }
}
