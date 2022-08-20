//
//  PersonHeaderView.swift
//  WatchMe
//
//  Created by Fatih Kilit on 20.08.2022.
//

import UIKit

class PersonHeaderView: UIView {
    
    private var superContainerView: UIStackView!
    
    private var posterImageView: WMPosterImageView!
    private var nameLabel: WMTitleLabel!
    
    private var attributesStackView: UIStackView!
    private var dateLabel: WMLabelWithImage!
    private var locationLabel: WMLabelWithImage!
    
    private let padding: CGFloat = 10
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(superContainerView: UIStackView, person: Person) {
        self.init(frame: .zero)
        self.superContainerView = superContainerView
        
        configureView()
        
        configurePosterImageView()
        
        configureNameLabel()
        
        configureAttributesStackView()
        configureDateLabel()
        configureLocationLabel()
        
        setHeaderView(person: person)
    }
    
    private func setHeaderView(person: Person) {
        posterImageView.downloadImage(urlString: ApiUrls.image(path: person.profilePath ?? ""))
        
        nameLabel.text = person.name
        
        dateLabel.setWMLabelWithImage(text: person.birthDeathDay, systemImage: SystemImages.calendarImage)
        locationLabel.setWMLabelWithImage(text: person.birthLocation, systemImage: SystemImages.locationImage)
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
    
    private func configureNameLabel() {
        nameLabel = WMTitleLabel(textAlignment: .left, fontSize: 22)
        addSubview(nameLabel)
        
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: posterImageView.topAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: posterImageView.trailingAnchor, constant: 2 * padding),
            nameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding)
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
            attributesStackView.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 2 * padding),
            attributesStackView.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            attributesStackView.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor)
        ])
    }
    
    private func configureDateLabel() {
        dateLabel = WMLabelWithImage()
        attributesStackView.addArrangedSubview(dateLabel)
    }
    
    private func configureLocationLabel() {
        locationLabel = WMLabelWithImage()
        attributesStackView.addArrangedSubview(locationLabel)
    }
}
