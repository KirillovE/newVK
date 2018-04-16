//
//  ImagesFromWeb.swift
//  newVK
//
//  Created by Евгений Кириллов on 16.04.2018.
//  Copyright © 2018 Триада. All rights reserved.
//

import AlamofireImage

class ImagesFromWeb {
    
    private let downloader = ImageDownloader()
    
    func setImage(fromPath urlString: String, to imageView: UIImageView) {
        guard let url = URL(string: urlString) else { return }
        let urlRequest = URLRequest(url: url)
        downloader.download(urlRequest) { response in
            if let image = response.result.value {
                imageView.image = image
            }
        }
    }
    
}
