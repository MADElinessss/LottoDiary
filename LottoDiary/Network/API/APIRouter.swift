//
//  APIRouter.swift
//  LottoDiary
//
//  Created by 신정연 on 7/10/24.
//

import Alamofire
import Foundation

enum APIRouter: URLRequestConvertible {
    
    case lotto(drwNumber: Int)
    case kakaoMap(areaX: Double, areaY: Double)
    
    var method: HTTPMethod {
        return .get
    }
    
    var path: String {
        switch self {
        case .lotto(let drwNumber):
            return "https://www.dhlottery.co.kr/common.do?method=getLottoNumber&drwNo=\(drwNumber)"
        case .kakaoMap(let areaX, let areaY):
            return "https://dapi.kakao.com/v2/local/search/keyword.json"
        }
    }
    
    var headers: HTTPHeaders? {
        switch self {
        case .kakaoMap:
            return ["Authorization": "KakaoAK \(APIKey.kakaoReactAppKey)"]
        default:
            return nil
        }
    }
    
    var parameters: Parameters? {
        switch self {
        case .kakaoMap(let areaX, let areaY):
            return [
                "query": "로또",
                "y": areaY,
                "x": areaX
            ]
        default:
            return nil
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        let url = try path.asURL()
        var request = URLRequest(url: url)
        request.method = method
        request.headers = headers ?? [:]
        
        if let parameters = parameters {
            request = try URLEncoding.default.encode(request, with: parameters)
        }
        
        return request
    }
}
