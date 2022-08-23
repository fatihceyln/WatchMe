//
//  EmptyWatchlistView.swift
//  WatchMe
//
//  Created by Fatih Kilit on 23.08.2022.
//

import UIKit

class EmptyWatchlistView: UIView {
    
    private var image: UIImageView!
    private var titleLabel: WMTitleLabel!
    private var bodyLabel: WMBodyLabel!
    
    private let padding: CGFloat = 10
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureImage()
        configureTitleLabel()
        configureBodyLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureImage() {
        image = UIImageView(frame: .zero)
        addSubview(image)
        
        image.translatesAutoresizingMaskIntoConstraints = false
        image.sizeToFit()
        image.image = UIImage(systemName: "plus.circle")
        image.tintColor = .tertiarySystemFill
        
        NSLayoutConstraint.activate([
            image.topAnchor.constraint(equalTo: topAnchor, constant: padding),
            image.centerXAnchor.constraint(equalTo: centerXAnchor),
            image.widthAnchor.constraint(equalToConstant: 110),
            image.heightAnchor.constraint(equalToConstant: 110)
        ])
    }
    
    private func configureTitleLabel() {
        titleLabel = WMTitleLabel(textAlignment: .center, fontSize: 22)
        addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: image.bottomAnchor, constant: padding),
            titleLabel.widthAnchor.constraint(equalTo: widthAnchor, constant: padding)
        ])
        
        titleLabel.text = "Your watchlist is empty"
    }
    
    private func configureBodyLabel() {
        bodyLabel = WMBodyLabel(textAlignment: .center)
        addSubview(bodyLabel)
        
        NSLayoutConstraint.activate([
            bodyLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: padding),
            bodyLabel.widthAnchor.constraint(equalTo: widthAnchor, constant: padding)
        ])
        
        bodyLabel.text = "Content you add to your watchlist will appear here."
    }
}
