//
//  UILabel+Ext.swift
//  WatchMe
//
//  Created by Fatih Kilit on 22.08.2022.
//

import UIKit

extension UILabel {
    var lineCount: Int {
        let maxSize = CGSize(width: frame.size.width, height: CGFloat(MAXFLOAT))
        let text = (self.text ?? "") as NSString
        let textHeight = text.boundingRect(with: maxSize, options: .usesLineFragmentOrigin, attributes: [.font: font!], context: nil).height
        let lineHeight = font.lineHeight
        return Int(ceil(textHeight / lineHeight))
    }
}
