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
    
    @IBOutlet weak var avatar: UIImageView! {
        didSet { avatar.translatesAutoresizingMaskIntoConstraints = false }
    }
    @IBOutlet weak var authorName: UILabel! {
        didSet { authorName.translatesAutoresizingMaskIntoConstraints = false }
    }
    @IBOutlet weak var newsText: UILabel! {
        didSet { newsText.translatesAutoresizingMaskIntoConstraints = false }
    }
    @IBOutlet weak var numberOfViews: UILabel! {
        didSet { numberOfViews.translatesAutoresizingMaskIntoConstraints = false }
    }
    @IBOutlet weak var numberOfReposts: UILabel! {
        didSet { numberOfReposts.translatesAutoresizingMaskIntoConstraints = false }
    }
    @IBOutlet weak var numberOfComments: UILabel! {
        didSet { numberOfComments.translatesAutoresizingMaskIntoConstraints = false }
    }
    @IBOutlet weak var numberOfLikes: UILabel! {
        didSet { numberOfLikes.translatesAutoresizingMaskIntoConstraints = false }
    }
    @IBOutlet weak var date: UILabel! {
        didSet { date.translatesAutoresizingMaskIntoConstraints = false }
    }
    @IBOutlet weak var attachedImage: UIImageView! {
        didSet { attachedImage.translatesAutoresizingMaskIntoConstraints = false }
    }
    
    // MARK: - Source data
    
    let inset: CGFloat = 10
    let insetBetweenObjects: CGFloat = 5
    var nameDateOriginX: CGFloat = 0
    let attributeImageSize = CGSize(width: 15, height: 15)
    var attributeOriginY: CGFloat = 0
    var attachedImageAspectRatio: Double?
    var cellHeight: CGFloat?
    let formatter = IntFormatting()
    
    // MARK: - Methods
    
    override func awakeFromNib() {
        super.awakeFromNib()
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
        
        avatar.layer.cornerRadius = avatar.frame.size.height / 2
        
        if news.attachedImageURL != "" {
            attachedImageAspectRatio = news.attachedImageWidth / news.attachedImageHeight
        }
    }
    
}
