//
//  NewsAttributesFrames.swift
//  newVK
//
//  Created by Евгений Кириллов on 12.04.2018.
//  Copyright © 2018 Триада. All rights reserved.
//

import UIKit

extension NewsCell {
    
    func likeImageFrame() {
        let labelOrigin = CGPoint(x: inset, y: attributeOriginY)
        viewWithTag(1)?.frame = CGRect(origin: labelOrigin, size: attributeImageSize)
    }
    
    func likeCountFrame() {
        let labelSize = getLabelSize(text: numberOfLikes.text!, font: numberOfLikes.font)
        let labelX = (viewWithTag(1)?.frame.origin.x)! + (viewWithTag(1)?.frame.width)!
        let labelOrigin = CGPoint(x: labelX, y: attributeOriginY)
        numberOfLikes.frame = CGRect(origin: labelOrigin, size: labelSize)
    }
    
    func commentsImageFrame() {
        let labelX = numberOfLikes.frame.origin.x + numberOfLikes.frame.width + insetBetweenObjects
        let labelOrigin = CGPoint(x: labelX, y: attributeOriginY)
        viewWithTag(2)?.frame = CGRect(origin: labelOrigin, size: attributeImageSize)
    }
    
    func commentsCountFrame() {
        let labelSize = getLabelSize(text: numberOfComments.text!, font: numberOfComments.font)
        let labelX = (viewWithTag(2)?.frame.origin.x)! + (viewWithTag(2)?.frame.width)!
        let labelOrigin = CGPoint(x: labelX, y: attributeOriginY)
        numberOfComments.frame = CGRect(origin: labelOrigin, size: labelSize)
    }
    
    func repostsImageFrame() {
        let labelX = numberOfComments.frame.origin.x + numberOfComments.frame.width + insetBetweenObjects
        let labelOrigin = CGPoint(x: labelX, y: attributeOriginY)
        viewWithTag(3)?.frame = CGRect(origin: labelOrigin, size: attributeImageSize)
    }
    
    func repostsCountFrame() {
        let labelSize = getLabelSize(text: numberOfReposts.text!, font: numberOfReposts.font)
        let labelX = (viewWithTag(3)?.frame.origin.x)! + (viewWithTag(3)?.frame.width)!
        let labelOrigin = CGPoint(x: labelX, y: attributeOriginY)
        numberOfReposts.frame = CGRect(origin: labelOrigin, size: labelSize)
    }
    
    func viewsImageFrame() {
        let labelX = numberOfReposts.frame.origin.x + numberOfReposts.frame.width + insetBetweenObjects
        let labelOrigin = CGPoint(x: labelX, y: attributeOriginY)
        viewWithTag(4)?.frame = CGRect(origin: labelOrigin, size: attributeImageSize)
    }
    
    func viewsCountFrame() {
        let labelSize = getLabelSize(text: numberOfViews.text!, font: numberOfViews.font)
        let labelX = (viewWithTag(4)?.frame.origin.x)! + (viewWithTag(4)?.frame.width)!
        let labelOrigin = CGPoint(x: labelX, y: attributeOriginY)
        numberOfViews.frame = CGRect(origin: labelOrigin, size: labelSize)
    }
    
}
