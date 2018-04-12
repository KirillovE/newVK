//
//  IntFormatting.swift
//  newVK
//
//  Created by Евгений Кириллов on 12.04.2018.
//  Copyright © 2018 Триада. All rights reserved.
//

import Foundation

class IntFormatting {
    
    private let formatter: NumberFormatter = {
        let fmtr = NumberFormatter()
        fmtr.usesGroupingSeparator = true
        fmtr.numberStyle = .decimal
        return fmtr
    }()
    
    func formatInt(_ number: Int) -> String {
        let niceNumber = formatter.string(from: NSNumber(integerLiteral: number))
        
        if let niceString = niceNumber {
            return niceString
        } else {
            return "нет данных"
        }
    }
    
}
