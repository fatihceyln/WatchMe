//
//  TopBilledCell.swift
//  WatchMe
//
//  Created by Fatih Kilit on 14.08.2022.
//

import UIKit

class TopBilledCell: UICollectionViewCell {
    static let reuseID = "TopBilledCell"
    
    let posterImageView = WMPosterImageView(frame: .zero)
    let nameLabel = WMTitleLabel(textAlignment: .center, fontSize: 18)
    let characterLabel = WMBodyLabel(textAlignment: .center)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        posterImageView.cancelDownloading()
    }
    
    func set(cast: Cast) {
        posterImageView.downloadImage(urlString: ApiUrls.image(path: cast.profilePath ?? ""))
        nameLabel.text = cast.name
        characterLabel.text = cast.character
    }
    
    private func configure() {
        
        backgroundColor = .gray.withAlphaComponent(0.1)
        layer.cornerRadius = 10
        
        addSubviews(posterImageView, nameLabel, characterLabel)
        
        let padding: CGFloat = 8
        
        NSLayoutConstraint.activate([
            posterImageView.topAnchor.constraint(equalTo: topAnchor, constant: padding),
            posterImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            posterImageView.widthAnchor.constraint(equalToConstant: 150),
            posterImageView.heightAnchor.constraint(equalToConstant: 225),
            
            nameLabel.topAnchor.constraint(equalTo: posterImageView.bottomAnchor, constant: padding),
            nameLabel.leadingAnchor.constraint(equalTo: posterImageView.leadingAnchor),
            nameLabel.trailingAnchor.constraint(equalTo: posterImageView.trailingAnchor),
            nameLabel.heightAnchor.constraint(equalToConstant: 20),
            
            characterLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: padding / 2),
            characterLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            characterLabel.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor),
            characterLabel.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
}
