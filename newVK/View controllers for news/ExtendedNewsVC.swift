//
//  ExtendedNewsVC.swift
//  newVK
//
//  Created by Евгений Кириллов on 02.04.2018.
//  Copyright © 2018 Триада. All rights reserved.
//

import UIKit

class ExtendedNewsVC: UIViewController {

    // MARK: - Source data
    
    var news: News!
    var imageForAvatar: UIImage!
    var imageToShow: UIImage?
    
    // MARK: - Outlets
    
    @IBOutlet weak var authorName: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var newsText: UILabel!
    @IBOutlet weak var numberOfLikes: UILabel!
    @IBOutlet weak var numberOfComments: UILabel!
    @IBOutlet weak var numberOfReposts: UILabel!
    @IBOutlet weak var numberOfViews: UILabel!
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var attachedImage: UIImageView!
    
    // MARK: - Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setAllOutlets()
    }

    func setAllOutlets() {
        authorName.text = news.name
        dateLabel.text = news.date
        newsText.text = news.text
        numberOfLikes.text = String(news.likes.count)
        numberOfComments.text = String(news.comments.count)
        numberOfReposts.text = String(news.reposts.count)
        numberOfViews.text = String(news.viewsCount)
        
        avatar.image = imageForAvatar
        avatar.layer.cornerRadius = avatar.frame.size.height / 2
        avatar.clipsToBounds = true
        attachedImage.image = imageToShow
    }
}
