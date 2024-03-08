//
//  FormatterManager.swift
//  LottoDiary
//
//  Created by Madeline on 3/7/24.
//

import Foundation

class FormatterManager {
    
    static let shared = FormatterManager()
    
    private init() { }
    
    private let numberFormatter = NumberFormatter()
    private let dateFormatter = DateFormatter()
    
    func numberDecimal(_ number: Double) -> String {
        numberFormatter.numberStyle = .decimal
        let result = numberFormatter.string(from: number as NSNumber)
        
        return result ?? "0"
    }
    
    func numberTwoPoints(_ number: Double) -> String {
        numberFormatter.maximumFractionDigits = 2
        let result = numberFormatter.string(from: number as NSNumber)
        
        return result ?? "0"
    }
    
    func drawDateFormat(date: String) -> String {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd"
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "yyyy.MM.dd"
        
        if let dateObj = inputFormatter.date(from: date) {
            let result = outputFormatter.string(from: dateObj)
            return result
        } else {
            return "Invalid date"
        }
    }
}
