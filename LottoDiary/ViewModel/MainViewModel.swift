//
//  MainViewModel.swift
//  LottoDiary
//
//  Created by Madeline on 3/7/24.
//

import Foundation

class MainViewModel {
    
    var inputDrawNumber: Observable<Int> = Observable(1110)
    
    var outputLotto: Observable<Lotto?> = Observable(nil)
    
    func apiRequest() {
        APIManager.shared.lottoCallRequest(drwNumber: inputDrawNumber.value) { lotto in
            self.outputLotto.value = lotto
        }
    }
}
