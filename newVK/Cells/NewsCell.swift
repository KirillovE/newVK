//
//  NewsCell.swift
//  newVK
//
//  Created by Евгений Кириллов on 25.03.2018.
//  Copyright © 2018 Триада. All rights reserved.
//

import UIKit

class NewsCell: UITableViewCell {
    
    // MARK: - Outlets
    
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var authorName: UILabel!
    @IBOutlet weak var newsText: UILabel!
    @IBOutlet weak var numberOfViews: UILabel!
    @IBOutlet weak var numberOfReposts: UILabel!
    @IBOutlet weak var numberOfComments: UILabel!
    @IBOutlet weak var numberOfLikes: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var attachedImage: UIImageView!
    
    // MARK: - Source data
    
    let inset: CGFloat = 15
    let insetBetweenObjects: CGFloat = 5
    var nameDateOriginX: CGFloat = 0
    let attributeImageSize = CGSize(width: 15, height: 15)
    var attributeOriginY: CGFloat = 0
    var attachedImageAspectRatio: Double?
    var cellHeight: CGFloat?
    let formatter = Formatting()
    
    // MARK: - Methods
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        [avatar, authorName, newsText, numberOfViews, numberOfReposts, numberOfComments, numberOfLikes, date, attachedImage].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        nameDateOriginX = inset + avatar.frame.width + insetBetweenObjects
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        avatarFrame()
        authorNameFrame()
        dateFrame()
        newsTextFrame()
        attachedImageFrame()
        likeImageFrame()
        likeCountFrame()
        commentsImageFrame()
        commentsCountFrame()
        repostsImageFrame()
        repostsCountFrame()
        viewsImageFrame()
        viewsCountFrame()
    }
    
    func configure(for news: News) {
        setAuthorName(news.name)
        setNewsText(news.text)
        setViews(news.viewsCount)
        setReposts(news.reposts.count)
        setComments(news.comments.count)
        setLikes(news.likes.count)
        setDate("\(news.time) \(news.day)")
        getCellHeight()
        
        if news.sourceID < 0 {
            avatar.layer.cornerRadius = avatar.frame.size.height / 4
        } else {
            avatar.layer.cornerRadius = avatar.frame.size.height / 2
        }
        
        if news.attachedImageURL != "" {
            attachedImageAspectRatio = news.attachedImageWidth / news.attachedImageHeight
        }
    }
    
}

// MARK: - Setting frames

extension NewsCell {
    
    func setAuthorName(_ name: String) {
        authorName.text = name
        authorNameFrame()
    }
    
    func setDate(_ timeDate: String) {
        date.text = timeDate
        dateFrame()
    }
    
    func setNewsText(_ text: String) {
        newsText.text = text
        newsTextFrame()
    }
    
    func setLikes(_ count: Int) {
        numberOfLikes.text = formatter.formatInt(count)
        likeCountFrame()
    }
    
    func setComments(_ count: Int) {
        numberOfComments.text = formatter.formatInt(count)
        commentsCountFrame()
    }
    
    func setReposts(_ count: Int) {
        numberOfReposts.text = formatter.formatInt(count)
        repostsCountFrame()
    }
    
    func setViews(_ count: Int) {
        numberOfViews.text = formatter.formatInt(count)
        viewsCountFrame()
    }
    
}

// MARK: - Main frames

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

// MARK: - Attributes frames

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

// MARK: - Service extension

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
