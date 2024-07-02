//
//  MainViewModel.swift
//  LottoDiary
//
//  Created by Madeline on 3/7/24.
//

import Alamofire
import RxCocoa
import RxSwift
import UIKit

class MainViewModel {
    
    let disposeBag = DisposeBag()
    
    struct Input {
        var inputDrawNumber = BehaviorSubject<Int>(value: 1110)
    }
    
    struct Output {
        var outputLotto: BehaviorSubject<Lotto?> = BehaviorSubject(value: nil)
        var errorMessage: PublishSubject<String?> = PublishSubject()
    }
    
    func transform(_ input: Input) -> Output {
        let output = Output()
        input.inputDrawNumber
            .subscribe { [weak self] drawNumber in
                self?.apiRequest(drawNumber: drawNumber, output: output)
            }
            .disposed(by: disposeBag)
        
        return output
    }
    
    func apiRequest(drawNumber: Int, output: Output) {
        if let drawNumber = FormatterManager.shared.findLottoDrawNumber() {
            APIManager.shared.lottoCallRequest(drwNumber: drawNumber) { result in
                switch result {
                case .success(let lotto):
                    output.outputLotto.onNext(lotto)
                case .failure(let error):
                    // 에러 메시지를 Observable을 통해 업데이트
                    output.errorMessage.onNext("네트워크 오류가 발생했습니다. \(error.localizedDescription)")
                }
            }
        } else {
            output.errorMessage.onNext("로또 번호를 찾을 수 없습니다.")
        }
    }
}
