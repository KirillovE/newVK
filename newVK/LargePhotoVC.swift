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
    var photoName: String?
    
// MARK: - View Controller life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard photoName != nil else { return }
        largePhoto.image = UIImage(named: photoName!)
        
//        let switchColorGesture = UITapGestureRecognizer(target: self, action: #selector(switchBackgroundColor))
//        let switchNavBarVisibleGesture = UITapGestureRecognizer(target: self, action: #selector(switchNavBarVisible))
//        view.addGestureRecognizer(switchColorGesture)
//        view.addGestureRecognizer(switchNavBarVisibleGesture)
        
        let switchColorAndNavGesture = UITapGestureRecognizer(target: self, action: #selector(switchBackgroundAndNavBar))
        view.addGestureRecognizer(switchColorAndNavGesture)
    }
    
// MARK: - Other methods
    
//    @IBAction func switchBackgroundColor() {
//        guard view.backgroundColor != nil else { return }
//
//        switch view.backgroundColor! {
//        case UIColor.white:
//            view.backgroundColor = UIColor.black
//        default:
//            view.backgroundColor = UIColor.white
//        }
//    }
//
//    @IBAction func switchNavBarVisible() {
//        switch navigationController?.isNavigationBarHidden {
//        case true?:
//            navigationController?.setNavigationBarHidden(false, animated: true)
//        default:
//            navigationController?.setNavigationBarHidden(true, animated: true)
//        }
//    }
    
    @IBAction func switchBackgroundAndNavBar() {
        guard view.backgroundColor != nil else { return }
        switch view.backgroundColor! {
        case UIColor.white:
            view.backgroundColor = UIColor.black
        default:
            view.backgroundColor = UIColor.white
        }

        switch navigationController?.isNavigationBarHidden {
        case true?:
            navigationController?.setNavigationBarHidden(false, animated: true)
        default:
            navigationController?.setNavigationBarHidden(true, animated: true)
        }
    }
    
}
