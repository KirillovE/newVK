//
//  IntFormatting.swift
//  newVK
//
//  Created by Евгений Кириллов on 12.04.2018.
//  Copyright © 2018 Триада. All rights reserved.
//

import Foundation

class Formatting {
    
    private let intFormatter: NumberFormatter = {
        let fmtr = NumberFormatter()
        fmtr.usesGroupingSeparator = true
        fmtr.numberStyle = .decimal
        return fmtr
    }()
    
    private let dateFormatter = DateFormatter()
    
    func formatInt(_ number: Int) -> String {
        let niceNumber = intFormatter.string(from: NSNumber(integerLiteral: number))
        
        if let niceString = niceNumber {
            return niceString
        } else {
            return "нет данных"
        }
    }
    
    func formatDate(_ date: Double, outputFormat: String) -> String {
        dateFormatter.dateFormat = outputFormat
        let numberDate = Date(timeIntervalSince1970: date)
        let formattedDate = dateFormatter.string(from: numberDate)
        
        return formattedDate
    }
    
}

extension Formatting {
    
    enum DateOutputFormat: String {
        case day = "dd.MM.yyyy"
        case time = "HH.mm"
    }
    
    func formatDate(_ date: Double, outputFormat: DateOutputFormat) -> String {
        return formatDate(date, outputFormat: outputFormat.rawValue)
    }

}
