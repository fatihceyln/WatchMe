//
//  ContentCell.swift
//  WatchMe
//
//  Created by Fatih Kilit on 11.08.2022.
//

import UIKit

class ContentCell: UICollectionViewCell {
    static let reuseID = "MovieCell"
    
    let posterImageView = WMPosterImageView(frame: .zero)
    
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
    
    func set(content: ContentResult) {
        posterImageView.downloadImage(urlString: ApiUrls.image(path: content.posterPath ?? ""))
    }
    
    private func configure() {
        addSubview(posterImageView)
        
        let padding: CGFloat = 8
        
        NSLayoutConstraint.activate([
            posterImageView.topAnchor.constraint(equalTo: topAnchor, constant: padding),
            posterImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            posterImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
            posterImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -padding)
        ])
    }
}
