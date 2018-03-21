//
//  ManagePageVC.swift
//  newVK
//
//  Created by Евгений Кириллов on 28.02.2018.
//  Copyright © 2018 Триада. All rights reserved.
//

import RealmSwift

class ManagePageVC: UIPageViewController {
    
    // MARK: - Source data
    
    var photoAlbum: Results<Photo>!
    var photoIndex: Int!
    
    // MARK: - Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let viewController = viewLargePhotoVC(photoIndex) {
            let viewControllers = [viewController]
            setViewControllers(viewControllers, direction: .forward, animated: false)
        }
        
        dataSource = self
    }

    func viewLargePhotoVC(_ index: Int) -> LargePhotoVC? {
        guard let storyboard = storyboard,
            let page = storyboard.instantiateViewController(withIdentifier: "LargePhotoVC") as? LargePhotoVC else {
                return nil
        }
        
        do {
            let realm = try Realm()
            photoAlbum = realm.objects(Photo.self)
        } catch {
            print(error)
        }
        
        page.photoURL = photoAlbum![index].largePhotoURL
        page.photoIndex = index
        return page
    }
}

// MARK: -

extension ManagePageVC: UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if let viewController = viewController as? LargePhotoVC,
            let index = viewController.photoIndex,
            index > 0 {
            return viewLargePhotoVC(index - 1)
        }
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if let viewController = viewController as? LargePhotoVC,
            let index = viewController.photoIndex,
            (index + 1) < photoAlbum.count {
            return viewLargePhotoVC(index + 1)
        }
        return nil
    }

}
