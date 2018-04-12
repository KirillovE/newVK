//
//  NewsSettingFrames.swift
//  newVK
//
//  Created by Евгений Кириллов on 12.04.2018.
//  Copyright © 2018 Триада. All rights reserved.
//

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
        numberOfLikes.text = String(count)
        likeCountFrame()
    }
    
    func setComments(_ count: Int) {
        numberOfComments.text = String(count)
        commentsCountFrame()
    }
    
    func setReposts(_ count: Int) {
        numberOfReposts.text = String(count)
        repostsCountFrame()
    }
    
    func setViews(_ count: Int) {
        numberOfViews.text = String(count)
        viewsCountFrame()
    }
    
}
