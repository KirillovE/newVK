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
    var photoIndex: Int!
    
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
//        switchBackgroundColor()
//        после добавления Page View Controller изменение цвета стало работать некорректно
//        создаются View Controller'ы всегда с белым фоном
//        поэтому если перекрасить фон вокруг одной фотографии в чёрный,
//        фон соседних фотографий остаётся белым, а это некрасиво
//        с видимостью панели навигации таких проблем нет
//        может быть, когда-нибудь эту проблему решу, поэтому написанный код удалять далко
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
