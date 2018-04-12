//
//  NewsCellExtensions.swift
//  newVK
//
//  Created by Евгений Кириллов on 12.04.2018.
//  Copyright © 2018 Триада. All rights reserved.
//

import UIKit

extension NewsCell {
    
    func getLabelSize(text: String, font: UIFont) -> CGSize {
        let maxWidth = bounds.width - inset * 2
        let textBlock = CGSize(width: maxWidth, height: CGFloat.greatestFiniteMagnitude)
        let rect = text.boundingRect(with: textBlock, options: .usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font: font], context: nil)
        let width = Double(rect.size.width)
        let height = Double(rect.size.height)
        let size = CGSize(width: ceil(width), height: ceil(height))
        
        return size
    }
    
    func getCellHeight() {
        cellHeight = 2 * inset + 3 * insetBetweenObjects + avatar.frame.height + newsText.frame.height + attachedImage.frame.height + numberOfLikes.frame.height
    }
    
}
