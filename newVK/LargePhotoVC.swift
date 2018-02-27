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
        
        let viewTapGesture = UITapGestureRecognizer(target: self, action: #selector(onTap))
        view.addGestureRecognizer(viewTapGesture)
    }
    
// MARK: - Other methods
    
    /// переключет отображение панели навигации и цвет
    @IBAction func onTap() {
        switchBackgroundColor()
        switchNavBarVisible()
    }
    
    func switchBackgroundColor() {
        guard view.backgroundColor != nil else { return }

        switch view.backgroundColor! {
        case UIColor.white:
            view.backgroundColor = UIColor.black
        default:
            view.backgroundColor = UIColor.white
        }
    }

    func switchNavBarVisible() {
        switch navigationController?.isNavigationBarHidden {
        case true?:
            navigationController?.setNavigationBarHidden(false, animated: true)
        default:
            navigationController?.setNavigationBarHidden(true, animated: true)
        }
    }
    
}
