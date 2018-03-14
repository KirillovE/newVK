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
    var photo: UIImage?
    var photoIndex: Int!
    
// MARK: - View Controller life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard photo != nil else { return }
        largePhoto.image = photo
        
        let viewTapGesture = UITapGestureRecognizer(target: self, action: #selector(switchNavBarVisible))
        view.addGestureRecognizer(viewTapGesture)
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
