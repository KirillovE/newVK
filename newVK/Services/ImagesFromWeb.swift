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
        DispatchQueue.global().async {
            self.downloader.download(urlRequest) { response in
                guard let image = response.result.value else { return }
                DispatchQueue.main.async {
                    imageView.image = image
                }
            }
        }
        
    }
    
    func setTableImage(fromPath urlString: String, to imageView: UIImageView, table: UITableView, cell: UITableViewCell, index: IndexPath) {
        
        guard let url = URL(string: urlString) else { return }
        let urlRequest = URLRequest(url: url)
        DispatchQueue.global().async {
            self.downloader.download(urlRequest) { response in
                guard let image = response.result.value else { return }
                guard let newIndex = table.indexPath(for: cell),
                    newIndex == index else { return }
                DispatchQueue.main.async {
                    imageView.image = image
                }
            }
        }
        
    }
    
}
