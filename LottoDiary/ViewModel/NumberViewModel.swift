//
//  NumberViewModel.swift
//  LottoDiary
//
//  Created by Madeline on 3/23/24.
//

import Foundation
import UIKit
import RealmSwift

class NumberViewModel {
    
    let repository = NumberRealmRepository()
    var selectedNumbers: Observable<[Int]> = Observable([])
    var randomSelectedNumbers: Observable<[Int]> = Observable([])
    var inputReloadList: Observable<Void?> = Observable(nil)
    
    var outputReloadList: Observable<[Number]> = Observable([])
    
    var title: String?
    
    init() {
        inputReloadList.bind { _ in
            self.fetchNumber()
        }
    }
    
    func fetchNumber() {
        self.outputReloadList.value = repository.fetchNumber()
    }
    
    func saveNumberToRealm(title: String) {
        let number = Number()
        number.id = ObjectId.generate()
        number.title = title ?? repository.findNextDefaultTitle()
        let numbers = selectedNumbers.value
        if numbers.count >= 6 {
            number.title = title
            number.number1 = numbers[0]
            number.number2 = numbers[1]
            number.number3 = numbers[2]
            number.number4 = numbers[3]
            number.number5 = numbers[4]
            number.number6 = numbers[5]
            
            repository.createNumber(numbers: number)
        } else {
            print("선택된 숫자가 6개 미만입니다.")
        }
    }
    
    func saveRandomNumbers(title: String) {
        let number = Number()
        number.id = ObjectId.generate()
        number.title = title
        let numbers = randomSelectedNumbers.value
        if numbers.count >= 6 {
            number.title = title
            number.number1 = numbers[0]
            number.number2 = numbers[1]
            number.number3 = numbers[2]
            number.number4 = numbers[3]
            number.number5 = numbers[4]
            number.number6 = numbers[5]
            
            repository.createNumber(numbers: number)
        } else {
            print("선택된 숫자가 6개 미만입니다.")
        }
    }
    
    func updateNumber(_ number: Number) {
        repository.updateNumber(number: number)
    }
}
