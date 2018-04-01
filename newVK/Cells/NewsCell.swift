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
    @IBOutlet weak var image1: UIImageView!
    @IBOutlet weak var image2: UIImageView!
    @IBOutlet weak var image3: UIImageView!
    
    // MARK: - Methods
    
    func configure(for news: News) {
        authorName.text = news.name
        newsText.text = news.text
        numberOfViews.text = String(news.viewsCount)
        numberOfReposts.text = String(news.reposts.count)
        numberOfComments.text = String(news.comments.count)
        numberOfLikes.text = String(news.likes.count)
        date.text = news.date
        
        loadPhoto(from: news.photoURL)
        avatar.layer.cornerRadius = avatar.frame.size.height / 2
        avatar.clipsToBounds = true
    
        switch news.imageURLs.count {
        case 1:
            loadImage1(from: news.imageURLs.first!)
        case 2:
            loadImage1(from: news.imageURLs[0])
            loadImage2(from: news.imageURLs[1])
        case 3:
            loadImage1(from: news.imageURLs[0])
            loadImage2(from: news.imageURLs[1])
            loadImage3(from: news.imageURLs[2])
        default:
            break
        }
    }
    
    private func loadPhoto(from urlString: String) {
        let url = URL(string: urlString)
        DispatchQueue.global().async {
            guard let data = try? Data(contentsOf: url!) else { return }
            DispatchQueue.main.async {
                guard let image = UIImage(data: data) else { return }
                self.avatar?.image = image
            }
        }
    }
    
    private func loadImage1(from urlString: String) {
        let url = URL(string: urlString)
        DispatchQueue.global().async {
            guard let data = try? Data(contentsOf: url!) else { return }
            DispatchQueue.main.async {
                guard let image = UIImage(data: data) else { return }
                self.image1?.image = image
            }
        }
    }
    
    private func loadImage2(from urlString: String) {
        let url = URL(string: urlString)
        DispatchQueue.global().async {
            guard let data = try? Data(contentsOf: url!) else { return }
            DispatchQueue.main.async {
                guard let image = UIImage(data: data) else { return }
                self.image2?.image = image
            }
        }
    }
    
    private func loadImage3(from urlString: String) {
        let url = URL(string: urlString)
        DispatchQueue.global().async {
            guard let data = try? Data(contentsOf: url!) else { return }
            DispatchQueue.main.async {
                guard let image = UIImage(data: data) else { return }
                self.image3?.image = image
            }
        }
    }
    
}
