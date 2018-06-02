//
//  NewsImageInterfaceController.swift
//  WatchExtension Extension
//
//  Created by Евгений Кириллов on 02.06.2018.
//  Copyright © 2018 Триада. All rights reserved.
//

import WatchKit
import Foundation


class NewsImageInterfaceController: WKInterfaceController {
    
    @IBOutlet var attachedImage: WKInterfaceImage!
    @IBOutlet var authorName: WKInterfaceLabel!
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
    }

}
