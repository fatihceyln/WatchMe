//
//  WMPosterImageView.swift
//  WatchMe
//
//  Created by Fatih Kilit on 11.08.2022.
//

import UIKit

class WMPosterImageView: UIImageView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        translatesAutoresizingMaskIntoConstraints = false
        
        layer.cornerRadius = 10
        clipsToBounds = true
        contentMode = .scaleAspectFit
        backgroundColor = .gray.withAlphaComponent(0.15)
    }
    
    func downloadImage(urlString: String) {
        NetworkingManager.shared.downloadImage(urlString: urlString) { [weak self] image in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.image = image
            }
        }
    }
}
