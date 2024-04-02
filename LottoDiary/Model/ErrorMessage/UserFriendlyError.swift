//
//  UserFriendlyError.swift
//  LottoDiary
//
//  Created by Madeline on 3/31/24.
//

import Alamofire
import Foundation

enum UserFriendlyError: Error, LocalizedError {
    case connectionFailed
    case timeout
    case badRequest
    case serverError
    case dataParsingFailed
    case unknownError
    
    var errorDescription: String? {
        switch self {
        case .connectionFailed:
            return "인터넷 연결이 불안정합니다. 네트워크 연결을 확인해주세요."
        case .timeout:
            return "네트워크 요청 시간이 초과되었습니다. 잠시 후 다시 시도해주세요."
        case .badRequest:
            return "잘못된 요청입니다. 문제가 계속되면 지원팀에 문의해주세요."
        case .serverError:
            return "서버 오류가 발생했습니다. 잠시 후 다시 시도해주세요."
        case .dataParsingFailed:
            return "데이터 처리 중 오류가 발생했습니다. 문제가 계속되면 지원팀에 문의해주세요."
        case .unknownError:
            return "알 수 없는 오류가 발생했습니다. 문제가 계속되면 지원팀에 문의해주세요."
        }
    }
}
