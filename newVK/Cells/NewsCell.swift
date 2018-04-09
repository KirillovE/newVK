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
    
    // MARK: - Methods
    
    func configure(for news: News) {
        authorName.text = news.name
        newsText.text = news.text
        numberOfViews.text = String(news.viewsCount)
        numberOfReposts.text = String(news.reposts.count)
        numberOfComments.text = String(news.comments.count)
        numberOfLikes.text = String(news.likes.count)
        date.text = "\(news.time) \(news.day)"
        
        loadPhoto(from: news.photoURL)
        avatar.layer.cornerRadius = avatar.frame.size.height / 2
        
        if let attachedImage = news.imageURLs.first {
            loadAttachedImage(from: attachedImage)
        }
    }
    
    private func loadPhoto(from urlString: String) {
        guard let url = URL(string: urlString) else { return }
        DispatchQueue.global().async {
            guard let data = try? Data(contentsOf: url) else { return }
            DispatchQueue.main.async {
                guard let image = UIImage(data: data) else { return }
                self.avatar?.image = image
            }
        }
    }
    
    private func loadAttachedImage(from urlString: String) {
        guard let url = URL(string: urlString) else { return }
        DispatchQueue.global().async {
            guard let data = try? Data(contentsOf: url) else { return }
            DispatchQueue.main.async {
                guard let image = UIImage(data: data) else { return }
                self.attachedImage?.image = image
            }
        }
    }
    
}
