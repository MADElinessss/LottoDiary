//
//  NumberRealmRepository.swift
//  LottoDiary
//
//  Created by Madeline on 3/23/24.
//

import Foundation
import RealmSwift

class NumberRealmRepository {
    private let realm = try! Realm()
    
    func createNumber(numbers: Number) {
        do {
            try realm.write {
                realm.add(numbers)
                print("Number added to Realm 🥟")
            }
        } catch {
            print("Number Error 🥟", error)
        }
    }
    
    func fetchNumber() -> [Number] {
        let result = realm.objects(Number.self)
        return Array(result)
    }
    
    func deleteNumber(numberId: ObjectId) {
        
        guard let numberToDelete = realm.objects(Number.self).filter("id == %@", numberId).first else {
            return
        }
        
        do {
            try realm.write {
                realm.delete(numberToDelete)
                print("🗑️ number 삭제")
            }
        } catch {
            print("🗑️ 삭제error", error)
        }
    }

    func updateNumber(number: Number) {
        guard let existingNumber = realm.object(ofType: Number.self, forPrimaryKey: number.id) else { return }

        do {
            try realm.write {
                existingNumber.title = number.title
                existingNumber.number1 = number.number1
                existingNumber.number2 = number.number2
                existingNumber.number3 = number.number3
                existingNumber.number4 = number.number4
                existingNumber.number5 = number.number5
                existingNumber.number6 = number.number6
                
            }
        } catch {
            print("Number 업데이트 실패: \(error)")
        }
    }

    
    func findNextDefaultTitle() -> String {
        let allNumbers = realm.objects(Number.self)
        // title이 옵셔널이므로 옵셔널 체이닝을 사용하여 unwrapping
        let defaultTitles = allNumbers.compactMap { $0.title.contains("나의 번호(") ? $0.title : nil }
        let numbers = defaultTitles.compactMap { title -> Int? in
            let pattern = "^나의 번호\\((\\d+)\\)$"
            if let regex = try? NSRegularExpression(pattern: pattern),
               let match = regex.firstMatch(in: title, range: NSRange(title.startIndex..., in: title)) {
                if let range = Range(match.range(at: 1), in: title) {
                    return Int(title[range])
                }
            }
            return nil
        }.sorted()
        
        var nextNumber = 1
        for number in numbers {
            if number == nextNumber {
                nextNumber += 1
            } else {
                break
            }
        }
        
        return "나의 번호(\(nextNumber))"
    }
}
