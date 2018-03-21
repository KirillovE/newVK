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
    var photoIndex: Int!
    var photoURL = ""
    
// MARK: - Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadLargePhoto(from: photoURL)
        
        let hideNavBar = UITapGestureRecognizer(target: self, action: #selector(switchNavBarVisible))
        view.addGestureRecognizer(hideNavBar)
    }
    
    func loadLargePhoto(from urlString: String) {
        let url = URL(string: urlString)
        DispatchQueue.global().async {
            guard let data = try? Data(contentsOf: url!) else { return }
            DispatchQueue.main.async {
                guard let image = UIImage(data: data) else { return }
                self.largePhoto.image = image
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
