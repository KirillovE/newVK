//
//  PhotosVC.swift
//  newVK
//
//  Created by Евгений Кириллов on 26.02.2018.
//  Copyright © 2018 Триада. All rights reserved.
//

import UIKit

class PhotosVC: UIPageViewController {

    override func setViewControllers(_ viewControllers: [UIViewController]?, direction: UIPageViewControllerNavigationDirection, animated: Bool, completion: ((Bool) -> Void)? = nil) {
        performSegue(withIdentifier: "showPhoto", sender: self)
    }
}
