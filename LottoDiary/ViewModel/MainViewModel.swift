//
//  MainViewModel.swift
//  LottoDiary
//
//  Created by Madeline on 3/7/24.
//

import Foundation
import UIKit
import Alamofire

class MainViewModel {
    
    var inputDrawNumber: Observable<Int> = Observable(1110)
    
    var outputLotto: Observable<Lotto?> = Observable(nil)
    var errorMessage: Observable<String?> = Observable(nil)
    
    func apiRequest() {
        APIManager.shared.lottoCallRequest(drwNumber: inputDrawNumber.value) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let lotto):
                    self?.outputLotto.value = lotto
                case .failure(let error):
                    self?.errorMessage.value = "네트워크 오류 또는 기타 오류가 발생했습니다. \(error.localizedDescription)"
                }
            }
        }
    }
    
    func apiRequest(on viewController: UIViewController) {
        if let drawNumber = FormatterManager.shared.findLottoDrawNumber() {
            inputDrawNumber.value = drawNumber
            
            APIManager.shared.lottoCallRequest(drwNumber: inputDrawNumber.value) { [weak self] result in
                switch result {
                case .success(let lotto):
                    self?.outputLotto.value = lotto
                case .failure(let error):
                    // 에러 메시지를 Observable을 통해 업데이트
                    self?.errorMessage.value = "네트워크 오류 또는 기타 오류가 발생했습니다. \(error.localizedDescription)"
                }
            }
        } else {
            errorMessage.value = "로또 번호를 찾을 수 없습니다."
        }
    }
    
    private func handleError(_ error: AFError, on viewController: UIViewController) {
        var message: String = "알 수 없는 오류가 발생했습니다."
        if let urlError = error.underlyingError as? URLError, urlError.code == .notConnectedToInternet {
            message = "네트워크 연결이 단절되었습니다.\n잠시 후 다시 시도해주세요."
        }
        errorMessage.value = message
    }
}
