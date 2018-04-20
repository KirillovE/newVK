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
    @IBOutlet weak private var authorName: UILabel!
    @IBOutlet weak private var newsText: UILabel!
    @IBOutlet weak private var numberOfViews: UILabel!
    @IBOutlet weak private var numberOfReposts: UILabel!
    @IBOutlet weak private var numberOfComments: UILabel!
    @IBOutlet weak private var numberOfLikes: UILabel!
    @IBOutlet weak private var date: UILabel!
    @IBOutlet weak var attachedImage: UIImageView!
    
    // MARK: - Source data
    
    private let inset: CGFloat = 15
    private let insetBetweenObjects: CGFloat = 5
    private var nameDateOriginX: CGFloat = 0
    private let attributeImageSize = CGSize(width: 15, height: 15)
    private var attributeOriginY: CGFloat = 0
    private var attachedImageAspectRatio: Double?
    private let formatter = Formatting()
    weak var heightDelegate: CellHeightDelegate?
    var index: IndexPath?
    
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
        
        guard let index = index,
            let height = getCellHeight(),
            bounds.height != height else { return }
        heightDelegate?.setHeight(height, to: index)
        
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
    
    private func setAuthorName(_ name: String) {
        authorName.text = name
        authorNameFrame()
    }
    
    private func setDate(_ timeDate: String) {
        date.text = timeDate
        dateFrame()
    }
    
    private func setNewsText(_ text: String) {
        newsText.text = text
        newsTextFrame()
    }
    
    private func setLikes(_ count: Int) {
        numberOfLikes.text = formatter.formatInt(count)
        likeCountFrame()
    }
    
    private func setComments(_ count: Int) {
        numberOfComments.text = formatter.formatInt(count)
        commentsCountFrame()
    }
    
    private func setReposts(_ count: Int) {
        numberOfReposts.text = formatter.formatInt(count)
        repostsCountFrame()
    }
    
    private func setViews(_ count: Int) {
        numberOfViews.text = formatter.formatInt(count)
        viewsCountFrame()
    }
    
}

// MARK: - Main frames

extension NewsCell {
    
    private func avatarFrame() {
        let avatarSideSize: CGFloat = 45
        let avatarSize = CGSize(width: avatarSideSize, height: avatarSideSize)
        let avatarOrigin = CGPoint(x: inset, y: inset)
        avatar.frame = CGRect(origin: avatarOrigin, size: avatarSize)
    }
    
    private func authorNameFrame() {
        let labelSize = getLabelSize(text: authorName.text!, font: authorName.font)
        let labelOrigin = CGPoint(x: nameDateOriginX, y: inset)
        authorName.frame = CGRect(origin: labelOrigin, size: labelSize)
    }
    
    private func dateFrame() {
        let labelSize = getLabelSize(text: date.text!, font: date.font)
        let labelY = inset + avatar.frame.height - labelSize.height
        let labelOrigin = CGPoint(x: nameDateOriginX, y: labelY)
        date.frame = CGRect(origin: labelOrigin, size: labelSize)
    }
    
    private func newsTextFrame() {
        let labelSize = getLabelSize(text: newsText.text!, font: newsText.font)
        let labelY = inset + avatar.frame.height + insetBetweenObjects
        let labelOrigin = CGPoint(x: inset, y: labelY)
        newsText.frame = CGRect(origin: labelOrigin, size: labelSize)
    }
    
    private func attachedImageFrame() {
        let imageSize: CGSize
        let imageViewY = newsText.frame.origin.y + newsText.frame.height + insetBetweenObjects
        let imageViewOrigin = CGPoint(x: 0, y: imageViewY)
        
        if let aspectRatio = attachedImageAspectRatio {
            let imageWidth = bounds.width
            let imageHeight = imageWidth / CGFloat(aspectRatio)
            imageSize = CGSize(width: imageWidth, height: imageHeight)
            attachedImage.frame = CGRect(origin: imageViewOrigin, size: imageSize)
            attributeOriginY = attachedImage.frame.origin.y + attachedImage.frame.height + insetBetweenObjects
        } else {
            imageSize = CGSize.zero
            attachedImage.frame = CGRect(origin: imageViewOrigin, size: imageSize)
            attributeOriginY = attachedImage.frame.origin.y
        }
    }
    
}

// MARK: - Attributes frames

extension NewsCell {
    
    private func likeImageFrame() {
        let labelOrigin = CGPoint(x: inset, y: attributeOriginY)
        viewWithTag(1)?.frame = CGRect(origin: labelOrigin, size: attributeImageSize)
    }
    
    private func likeCountFrame() {
        let labelSize = getLabelSize(text: numberOfLikes.text!, font: numberOfLikes.font)
        let labelX = (viewWithTag(1)?.frame.origin.x)! + (viewWithTag(1)?.frame.width)!
        let labelOrigin = CGPoint(x: labelX, y: attributeOriginY)
        numberOfLikes.frame = CGRect(origin: labelOrigin, size: labelSize)
    }
    
    private func commentsImageFrame() {
        let labelX = numberOfLikes.frame.origin.x + numberOfLikes.frame.width + insetBetweenObjects
        let labelOrigin = CGPoint(x: labelX, y: attributeOriginY)
        viewWithTag(2)?.frame = CGRect(origin: labelOrigin, size: attributeImageSize)
    }
    
    private func commentsCountFrame() {
        let labelSize = getLabelSize(text: numberOfComments.text!, font: numberOfComments.font)
        let labelX = (viewWithTag(2)?.frame.origin.x)! + (viewWithTag(2)?.frame.width)!
        let labelOrigin = CGPoint(x: labelX, y: attributeOriginY)
        numberOfComments.frame = CGRect(origin: labelOrigin, size: labelSize)
    }
    
    private func repostsImageFrame() {
        let labelX = numberOfComments.frame.origin.x + numberOfComments.frame.width + insetBetweenObjects
        let labelOrigin = CGPoint(x: labelX, y: attributeOriginY)
        viewWithTag(3)?.frame = CGRect(origin: labelOrigin, size: attributeImageSize)
    }
    
    private func repostsCountFrame() {
        let labelSize = getLabelSize(text: numberOfReposts.text!, font: numberOfReposts.font)
        let labelX = (viewWithTag(3)?.frame.origin.x)! + (viewWithTag(3)?.frame.width)!
        let labelOrigin = CGPoint(x: labelX, y: attributeOriginY)
        numberOfReposts.frame = CGRect(origin: labelOrigin, size: labelSize)
    }
    
    private func viewsImageFrame() {
        let labelX = numberOfReposts.frame.origin.x + numberOfReposts.frame.width + insetBetweenObjects
        let labelOrigin = CGPoint(x: labelX, y: attributeOriginY)
        viewWithTag(4)?.frame = CGRect(origin: labelOrigin, size: attributeImageSize)
    }
    
    private func viewsCountFrame() {
        let labelSize = getLabelSize(text: numberOfViews.text!, font: numberOfViews.font)
        let labelX = (viewWithTag(4)?.frame.origin.x)! + (viewWithTag(4)?.frame.width)!
        let labelOrigin = CGPoint(x: labelX, y: attributeOriginY)
        numberOfViews.frame = CGRect(origin: labelOrigin, size: labelSize)
    }
    
}

// MARK: - Service extension

extension NewsCell {
    
    private func getLabelSize(text: String, font: UIFont) -> CGSize {
        let maxWidth = bounds.width - inset * 2
        let textBlock = CGSize(width: maxWidth, height: CGFloat.greatestFiniteMagnitude)
        let rect = text.boundingRect(with: textBlock, options: .usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font: font], context: nil)
        let width = Double(rect.size.width)
        let height = Double(rect.size.height)
        let size = CGSize(width: ceil(width), height: ceil(height))
        
        return size
    }
    
    private func getCellHeight() -> CGFloat? {
        return 2 * inset + 3 * insetBetweenObjects + avatar.frame.height + newsText.frame.height + attachedImage.frame.height + numberOfLikes.frame.height
    }
    
}
