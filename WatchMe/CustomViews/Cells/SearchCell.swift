//
//  SearchCell.swift
//  WatchMe
//
//  Created by Fatih Kilit on 17.08.2022.
//

import UIKit

class SearchCell: UITableViewCell {
    
    static let reuseID = "SearchCell"
    
    private var posterImage: WMPosterImageView!
    private var titleLabel: WMTitleLabel!
    private var yearLabel: WMBodyLabel!

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        accessoryType = .disclosureIndicator
        
        configurePosterImage()
        configureTitleLabel()
        configureYearLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        posterImage.cancelDownloading()
    }
    
    func set(movie: MovieResult) {
        posterImage.downloadImage(urlString: ApiUrls.image(path: movie.posterPath ?? ""))
        titleLabel.text = movie.title
        yearLabel.text = movie.releaseDate?.prefix(4).capitalized
    }
    
    private func configurePosterImage() {
        posterImage = WMPosterImageView(frame: .zero)
        addSubview(posterImage)
        
        NSLayoutConstraint.activate([
            posterImage.centerYAnchor.constraint(equalTo: centerYAnchor),
            posterImage.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            posterImage.widthAnchor.constraint(equalToConstant: 60),
            posterImage.heightAnchor.constraint(equalToConstant: 90)
        ])
    }
    
    private func configureTitleLabel() {
        titleLabel = WMTitleLabel(textAlignment: .left, fontSize: 18)
        addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: posterImage.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: posterImage.trailingAnchor, constant: 10),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            titleLabel.heightAnchor.constraint(equalToConstant: 40),
        ])
    }
    
    private func configureYearLabel() {
        yearLabel = WMBodyLabel(textAlignment: .left)
        addSubview(yearLabel)
        
        NSLayoutConstraint.activate([
            yearLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            yearLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            yearLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            yearLabel.heightAnchor.constraint(equalToConstant: 22)
        ])
    }
}
