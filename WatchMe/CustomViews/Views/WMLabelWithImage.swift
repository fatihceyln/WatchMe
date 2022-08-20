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
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        configureImage()
        configurelabel()
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureView() {
        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraint(equalTo: label.heightAnchor, constant: 5).isActive = true
    }
    
    func setWMLabelWithImage(text: String?, systemImage: UIImage?) {
        label.text = text
        image.image = systemImage
    }
    
    private func configureImage() {
        image = UIImageView(frame: .zero)
        addSubview(image)
        
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFit
        image.tintColor = .secondaryLabel
        
        NSLayoutConstraint.activate([
            image.leadingAnchor.constraint(equalTo: leadingAnchor),
            image.heightAnchor.constraint(equalToConstant: 25),
            image.widthAnchor.constraint(equalToConstant: 25)
        ])
    }
    
    private func configurelabel() {
        label = WMBodyLabel(textAlignment: .left)
        addSubview(label)
        
        label.numberOfLines = 2
        
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: topAnchor, constant: 2),
            label.leadingAnchor.constraint(equalTo: image.trailingAnchor, constant: 8),
            label.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
    }
}
