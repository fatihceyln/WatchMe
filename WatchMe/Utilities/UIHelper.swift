//
//  UIHelper.swift
//  WatchMe
//
//  Created by Fatih Kilit on 11.08.2022.
//

import UIKit

enum UIHelper {
    static func createFlowLayout() -> UICollectionViewFlowLayout {
        let flowLayout = UICollectionViewFlowLayout()
        
        flowLayout.itemSize = CGSize(width: 205, height: 300)
        flowLayout.scrollDirection = .horizontal
        
        return flowLayout
    }
    
    static func createCastFlowLayout() -> UICollectionViewFlowLayout {
        let flowLayout = UICollectionViewFlowLayout()
        
        flowLayout.itemSize = CGSize(width: 160, height: 290)
        flowLayout.scrollDirection = .horizontal
        
        return flowLayout
    }
}
