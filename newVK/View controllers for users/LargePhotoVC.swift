//
//  LargePhotoVC.swift
//  newVK
//
//  Created by Евгений Кириллов on 26.02.2018.
//  Copyright © 2018 Триада. All rights reserved.
//

import AlamofireImage

class LargePhotoVC: UIViewController {
    
// MARK: - Variables
    
    @IBOutlet weak var largePhoto: UIImageView!
    let downloader = ImageDownloader()
    var photoIndex: Int!
    var photoURL = ""
    
// MARK: - Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setImage(fromPath: photoURL, to: largePhoto)
        
        let hideNavBar = UITapGestureRecognizer(target: self, action: #selector(switchNavBarVisible))
        view.addGestureRecognizer(hideNavBar)
    }
    
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

// MARK: -

extension LargePhotoVC {
   
    @IBAction func switchNavBarVisible() {
        switch navigationController?.isNavigationBarHidden {
        case true?:
            navigationController?.setNavigationBarHidden(false, animated: true)
        default:
            navigationController?.setNavigationBarHidden(true, animated: true)
        }
    }
    
}
