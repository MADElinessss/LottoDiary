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
    
    func kakaoMapCallRequest(areaX: Double, areaY: Double) {
        let url = "https://dapi.kakao.com/v2/local/search/keyword.json"
        
        let headers : HTTPHeaders = [
            "Authorization": "KakaoAK \(APIKey.kakaoReactAppKey)"
        ]
        
        let parameters: Parameters = [
            "query": "카카오프렌즈",
            "y": areaY,
            "x": areaX,
            "radius": 20000
        ]
        
        AF.request(url, method: .get, parameters: parameters, headers: headers).responseDecodable(of: SearchResult.self) { response in
            switch response.result {
            case .success(let success):
                print("❣️", success)
            case .failure(let failure):
                print("❣️", failure)
            }
        }
    }
}
