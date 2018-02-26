//
//  LargePhotoVC.swift
//  newVK
//
//  Created by Евгений Кириллов on 26.02.2018.
//  Copyright © 2018 Триада. All rights reserved.
//

import UIKit

class LargePhotoVC: UIViewController {
    @IBOutlet weak var largePhoto: UIImageView!
    var photoName: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard photoName != nil else { return }
        largePhoto.image = UIImage(named: photoName!)
        
        navigationController?.hidesBarsOnTap = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.hidesBarsOnTap = false
    }
}
