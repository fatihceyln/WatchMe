//
//  WMLabelWithImage.swift
//  WatchMe
//
//  Created by Fatih Kilit on 13.08.2022.
//

import UIKit

class WMLabelWithImage: UIView {

    private var image: UIImageView!
    private var label: WMBodyLabel!
    
    private var text: String!
    private var systemName: String!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(text: String, systemName: String) {
        self.init(frame: .zero)
        
        self.text = text
        self.systemName = systemName
        
        configureImage()
        configurelabel()
    }
    
    private func configureImage() {
        image = UIImageView(frame: .zero)
        addSubview(image)
        
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = UIImage(systemName: systemName)
        image.contentMode = .scaleAspectFit
        image.tintColor = .secondaryLabel
        
        NSLayoutConstraint.activate([
            image.leadingAnchor.constraint(equalTo: leadingAnchor),
            image.centerYAnchor.constraint(equalTo: centerYAnchor),
            image.heightAnchor.constraint(equalToConstant: 25),
            image.widthAnchor.constraint(equalToConstant: 25)
        ])
    }
    
    private func configurelabel() {
        label = WMBodyLabel(textAlignment: .left)
        addSubview(label)
        
        label.text = text
        
        NSLayoutConstraint.activate([
            label.centerYAnchor.constraint(equalTo: centerYAnchor),
            label.leadingAnchor.constraint(equalTo: image.trailingAnchor, constant: 8),
            label.trailingAnchor.constraint(equalTo: trailingAnchor),
            label.heightAnchor.constraint(equalToConstant: 22)
        ])
    }
}
