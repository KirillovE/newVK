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
    
    @IBOutlet weak var imageViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageViewLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageViewTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var largePhoto: UIImageView!
    var photoName: String?
    
// MARK: - View Controller life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard photoName != nil else { return }
        largePhoto.image = UIImage(named: photoName!)
        
        let viewTapGesture = UITapGestureRecognizer(target: self, action: #selector(onTap))
        view.addGestureRecognizer(viewTapGesture)
        
        updateConstraintsForSize(view.bounds.size)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        updateMinZoomScaleForSize(view.bounds.size)
    }
    
    fileprivate func updateMinZoomScaleForSize(_ size: CGSize) {
        let widthScale = size.width / largePhoto.bounds.width
        let heightScale = size.height / largePhoto.bounds.height
        let minScale = min(widthScale, heightScale)
        
        scrollView.minimumZoomScale = minScale
        scrollView.zoomScale = minScale
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

// MARK: - Extensions

extension LargePhotoVC: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return largePhoto
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        updateConstraintsForSize(view.bounds.size)
    }
    
    fileprivate func updateConstraintsForSize(_ size: CGSize) {
        
        let yOffset = max(0, (size.height - largePhoto.frame.height) / 2)
        imageViewTopConstraint.constant = yOffset
        imageViewBottomConstraint.constant = yOffset
        
        let xOffset = max(0, (size.width - largePhoto.frame.width) / 2)
        imageViewLeadingConstraint.constant = xOffset
        imageViewTrailingConstraint.constant = xOffset
        
        view.layoutIfNeeded()
    }
    
}
