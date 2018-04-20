//
//  CellHeightDelegate.swift
//  newVK
//
//  Created by Евгений Кириллов on 20.04.2018.
//  Copyright © 2018 Триада. All rights reserved.
//

import UIKit

protocol CellHeightDelegate: class {
    
    func setHeight(_ height: CGFloat, to index: IndexPath)

}
