//
//  WMPosterImageView.swift
//  WatchMe
//
//  Created by Fatih Kilit on 11.08.2022.
//

import UIKit

class WMPosterImageView: UIImageView {
    
    var dataTask: URLSessionDataTask?

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
//        NetworkingManager.shared.downloadImage(urlString: urlString) { [weak self] image in
//            guard let self = self else { return }
//            DispatchQueue.main.async {
//                self.image = image
//            }
//        }
        
        guard let url = URL(string: urlString) else { return }
        image = nil
        
        if let cachedImage = NetworkingManager.shared.cache.object(forKey: urlString as NSString) {
            self.image = cachedImage
            return
        }
        
        self.dataTask = URLSession.shared.dataTask(with: url, completionHandler: { [weak self] (data, response, error) in
            guard
                let self = self,
                let data = data,
                let image = UIImage(data: data) else {
                return
            }
            
            DispatchQueue.main.async {
                self.image = image
                
                NetworkingManager.shared.cache.setObject(image, forKey: urlString as NSString)
            }
        })
        
        dataTask?.resume()
    }
    
    func cancelDownloading() {
        dataTask?.cancel()
        dataTask = nil
    }
}
