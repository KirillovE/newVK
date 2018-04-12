//
//  NewsMainFrames.swift
//  newVK
//
//  Created by Евгений Кириллов on 12.04.2018.
//  Copyright © 2018 Триада. All rights reserved.
//

import UIKit

extension NewsCell {
    
    func avatarFrame() {
        let avatarSideSize: CGFloat = 45
        let avatarSize = CGSize(width: avatarSideSize, height: avatarSideSize)
        let avatarOrigin = CGPoint(x: inset, y: inset)
        avatar.frame = CGRect(origin: avatarOrigin, size: avatarSize)
    }
    
    func authorNameFrame() {
        let labelSize = getLabelSize(text: authorName.text!, font: authorName.font)
        let labelOrigin = CGPoint(x: nameDateOriginX, y: inset)
        authorName.frame = CGRect(origin: labelOrigin, size: labelSize)
    }
    
    func dateFrame() {
        let labelSize = getLabelSize(text: date.text!, font: date.font)
        let labelY = inset + avatar.frame.height - labelSize.height
        let labelOrigin = CGPoint(x: nameDateOriginX, y: labelY)
        date.frame = CGRect(origin: labelOrigin, size: labelSize)
    }
    
    func newsTextFrame() {
        let labelSize = getLabelSize(text: newsText.text!, font: newsText.font)
        let labelY = inset + avatar.frame.height + insetBetweenObjects
        let labelOrigin = CGPoint(x: inset, y: labelY)
        newsText.frame = CGRect(origin: labelOrigin, size: labelSize)
    }
    
    func attachedImageFrame() {
        guard let aspectRatio = attachedImageAspectRatio else { return }
        let imageWidth = bounds.width
        let imageHeight = imageWidth / CGFloat(aspectRatio)
        let imageSize = CGSize(width: imageWidth, height: imageHeight)
        let labelY = newsText.frame.origin.y + newsText.frame.height + insetBetweenObjects
        let labelOrigin = CGPoint(x: 0, y: labelY)
        attachedImage.frame = CGRect(origin: labelOrigin, size: imageSize)
        
        attributeOriginY = attachedImage.frame.origin.y + attachedImage.frame.height + insetBetweenObjects
    }
    
}
