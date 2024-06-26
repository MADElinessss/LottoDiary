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
    
    // MARK: Decimal(,처리)
    func numberDecimal(_ number: Double) -> String {
        numberFormatter.numberStyle = .decimal
        let result = numberFormatter.string(from: number as NSNumber)
        
        return result ?? "0"
    }
    
    // MARK: 소수점 2자리
    func numberTwoPoints(_ number: Double) -> String {
        numberFormatter.maximumFractionDigits = 2
        let result = numberFormatter.string(from: number as NSNumber)
        
        return result ?? "0"
    }
    
    // MARK: yyyyMMddHHmmss Date -> String
    func dateToString(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMddHHmmss"
        return formatter.string(from: date)
    }
    
    
    // MARK: "yyyy.MM.dd" String -> String
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
    
    // MARK: "yyyy.MM.dd" Date -> String
    func formatDateToString(date: Date) -> String {
        dateFormatter.dateFormat = "yyyy.MM.dd"
        return dateFormatter.string(from: date)
    }
    
    // MARK: "yyyy.MM.dd 요일" Date -> String
    func formatDateWithDayToString(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.dateFormat = "yyyy.MM.dd EEEE"
        return dateFormatter.string(from: date)
    }
    
    // MARK: 당첨금 숫자 한국어로 번역
    func formatWinAmount(_ amount: Int) -> String {
        let billion = amount / 100000000
        let million = (amount % 100000000) / 10000
        let remainder = amount % 10000
        
        var formattedString = ""
        
        if billion > 0 {
            formattedString += "\(billion)억 "
        }
        if million > 0 {
            formattedString += "\(numberDecimal(Double(million)))만 "
        }
        if remainder > 0 {
            formattedString += "\(numberDecimal(Double(remainder)))"
        }
        
        return formattedString.trimmingCharacters(in: .whitespaces) + "원"
    }
    
    // MARK: 로또 회차 계산
    func findLottoDrawNumber(referenceDate: Date = Date(), referenceDrawNumber: Int = 1110, referenceDrawDate: String = "2024-03-09") -> Int? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        dateFormatter.timeZone = TimeZone(identifier: "Asia/Seoul")
        
        guard let referenceDrawDateTime = dateFormatter.date(from: "\(referenceDrawDate) 21:00") else {
            return nil
        }
        
        let calendar = Calendar(identifier: .gregorian)
        let components = calendar.dateComponents([.day, .hour], from: referenceDrawDateTime, to: referenceDate)
        
        guard let daysBetween = components.day, let hoursBetween = components.hour else {
            return nil
        }
        
        let totalHours = daysBetween * 24 + hoursBetween
        let weeksBetween = totalHours / 168
        
        let currentDrawNumber = referenceDrawNumber + weeksBetween
        return currentDrawNumber
    }
}
