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
    
    func lottoCallRequest(drwNumber: Int, completionHandler: @escaping (Result<Lotto, UserFriendlyError>) -> Void) {
        assert(drwNumber > 0, "추첨 번호는 0보다 커야 합니다.")
        let url = "https://www.dhlottery.co.kr/common.do?method=getLottoNumber&drwNo=\(drwNumber)"
        defer {
            print("Lotto API 요청 완료: \(url)")
        }
        AF.request(url, method: .get).responseDecodable(of: Lotto.self) { response in
            switch response.result {
            case .success(let lotto):
                completionHandler(.success(lotto))
            case .failure(let error):
                let userFriendlyError = mapToUserFriendlyError(error: error)
                completionHandler(.failure(userFriendlyError))
            }
        }
    }
    
    func kakaoMapCallRequest(areaX: Double, areaY: Double, completionHandler: @escaping (Result<SearchResult, UserFriendlyError>) -> Void) {
        
        assert(areaY >= 126 && areaY <= 129, "경도는 대한민국 내에 있어야 합니다: 126도 ~ 129도 사이")
        assert(areaX >= 33 && areaX <= 38, "위도는 대한민국 내에 있어야 합니다: 33도 ~ 38도 사이")

        let url = "https://dapi.kakao.com/v2/local/search/keyword.json"
        defer {
            print("카카오맵 API 요청 종료")
        }
        let headers : HTTPHeaders = [
            "Authorization": "KakaoAK \(APIKey.kakaoReactAppKey)"
        ]
        let parameters: Parameters = [
            "query": "로또",
            "y": areaY,
            "x": areaX
        ]
        
        AF.request(url, method: .get, parameters: parameters, headers: headers).responseDecodable(of: SearchResult.self) { response in
            switch response.result {
            case .success(let searchResult):
                completionHandler(.success(searchResult))
            case .failure(let error):
                let userFriendlyError = mapToUserFriendlyError(error: error)
                completionHandler(.failure(userFriendlyError))
            }
        }
    }
    
    private func mapToUserFriendlyError(error: AFError) -> UserFriendlyError {
        if let urlError = error.underlyingError as? URLError {
            switch urlError.code {
            case .notConnectedToInternet, .cannotFindHost, .cannotConnectToHost:
                return .connectionFailed
            case .timedOut:
                return .timeout
            case .cannotParseResponse:
                return .serverError
            default:
                return .unknownError
            }
        }
        return .unknownError
    }
}
