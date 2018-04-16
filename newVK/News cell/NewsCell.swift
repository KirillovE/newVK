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
