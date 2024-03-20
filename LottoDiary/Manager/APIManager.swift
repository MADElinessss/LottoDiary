//
//  APIManager.swift
//  LottoDiary
//
//  Created by Madeline on 3/7/24.
//

import Alamofire
import Foundation
import UIKit

struct APIManager {
    
    static let shared = APIManager()
    
    func lottoCallRequest(drwNumber: Int, completionHandler: @escaping (Result<Lotto, AFError>) -> Void) {
        let url = "https://www.dhlottery.co.kr/common.do?method=getLottoNumber&drwNo=\(drwNumber)"
        
        AF.request(url, method: .get).responseDecodable(of: Lotto.self) { response in
            completionHandler(response.result)
        }
    }
    
    func kakaoMapCallRequest(areaX: Double, areaY: Double, on viewController: UIViewController, completionHandler: @escaping (Result<SearchResult, AFError>) -> Void) {
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
            case .success(let data):
                completionHandler(.success(data))
            case .failure(let error):
                self.handleError(error, on: viewController)
            }
        }
    }
    
    private func handleError(_ error: AFError, on viewController: UIViewController) {
        // 네트워크 연결 실패 에러 처리
        if let urlError = error.underlyingError as? URLError, urlError.code == .notConnectedToInternet {
            AlertManager.shared.showAlert(on: viewController,
                                          title: "네트워크 오류",
                                          message: "네트워크 연결이 단절되었습니다.\n잠시 후 다시 시도해주세요.")
        } else {
            // 기타 에러 처리
            AlertManager.shared.showAlert(on: viewController,
                                          title: "오류 발생",
                                          message: "알 수 없는 오류가 발생했습니다.\n\(error.localizedDescription)")
        }
    }
}

