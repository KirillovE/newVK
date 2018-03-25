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
    
    // MARK:
    
    func configure(for news: NewsVC.News) {
        avatar.image = news.avatar
        authorName.text = news.name
        newsText.text = news.text
        numberOfViews.text = String(news.views)
        numberOfReposts.text = String(news.reposts)
        numberOfComments.text = String(news.comments)
        numberOfLikes.text = String(news.likes)
        
        avatar.layer.cornerRadius = avatar.frame.size.height / 2
        avatar.clipsToBounds = true
    }
}
