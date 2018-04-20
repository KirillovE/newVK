//
//  LargePhotoVC.swift
//  newVK
//
//  Created by Евгений Кириллов on 26.02.2018.
//  Copyright © 2018 Триада. All rights reserved.
//

import UIKit

class LargePhotoVC: UIViewController {
    
// MARK: - Variables
    
    @IBOutlet weak var largePhoto: UIImageView!
    let webImages = ImagesFromWeb()
    var photoIndex: Int!
    var photoURL = ""
    
// MARK: - Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webImages.setImage(fromPath: photoURL, to: largePhoto)
        
        let hideNavBar = UITapGestureRecognizer(target: self, action: #selector(switchNavBarVisible))
        view.addGestureRecognizer(hideNavBar)
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
