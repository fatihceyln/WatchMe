//
//  UIHelper.swift
//  WatchMe
//
//  Created by Fatih Kilit on 11.08.2022.
//

import UIKit

enum UIHelper {
    static func createFlowLayout() -> UICollectionViewFlowLayout {
        let padding: CGFloat = 0
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.sectionInset = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        flowLayout.itemSize = CGSize(width: 205, height: 300)
        flowLayout.scrollDirection = .horizontal
        
        return flowLayout
    }
}
