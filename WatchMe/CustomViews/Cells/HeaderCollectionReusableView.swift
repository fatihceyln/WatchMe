//
//  HeaderCollectionReusableView.swift
//  WatchMe
//
//  Created by Fatih Kilit on 17.08.2022.
//

import UIKit

class HeaderCollectionReusableView: UICollectionReusableView {
    
    static let reuseID = "HeaderCollectionReusableView"
    
    private var headerLablel: WMTitleLabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureHeaderLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureHeaderLabel() {
        headerLablel = WMTitleLabel(textAlignment: .left, fontSize: 26)
        addSubview(headerLablel)
        
        NSLayoutConstraint.activate([
            headerLablel.topAnchor.constraint(equalTo: topAnchor, constant: 40),
            headerLablel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 14),
            headerLablel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -14),
            headerLablel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    func setHeader(text: String) {
        headerLablel.text = text
    }
}
