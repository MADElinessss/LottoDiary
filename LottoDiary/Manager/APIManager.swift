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
    func lottoCallRequest(drwNumber: Int, completionHandler: @escaping (Result<Lotto, AFError>) -> Void) {
        
        let url = "https://www.dhlottery.co.kr/common.do?method=getLottoNumber&drwNo=\(drwNumber)"
        
        AF.request(url, method: .get).responseDecodable(of: Lotto.self) { response in
            completionHandler(response.result)
        }
    }
    
    func kakaoMapCallRequest(areaX: Double, areaY: Double, completionHandler: @escaping (Result<SearchResult, AFError>) -> Void) {
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
            completionHandler(response.result)
        }
    }
}
