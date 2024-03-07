//
//  APIManager.swift
//  LottoDiary
//
//  Created by Madeline on 3/7/24.
//

import Alamofire
import Foundation

struct APIManager {
    
    static let shared = APIManager()
    
    func lottoCallRequest(drwNumber: Int, completionHandler: @escaping (Lotto) -> Void) {
        
        let url = "https://www.dhlottery.co.kr/common.do?method=getLottoNumber&drwNo=\(drwNumber)"
        
        AF.request(url, method: .get).responseDecodable(of: Lotto.self) { response in
            switch response.result {
            case .success(let success):
                completionHandler(success)
            case .failure(let failure):
                print(failure)
            }
        }
    }
}
