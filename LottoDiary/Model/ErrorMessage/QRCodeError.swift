//
//  QRCodeError.swift
//  LottoDiary
//
//  Created by Madeline on 4/1/24.
//

import Foundation

enum QRCodeError: Error, LocalizedError {
    case cameraAccessDenied
    case invalidDeviceInput
    case invalidQRCode
    
    var errorDescription: String? {
        switch self {
        case .cameraAccessDenied:
            return "카메라 접근 권한이 없습니다. 설정에서 권한을 허용해주세요."
        case .invalidDeviceInput:
            return "카메라를 사용할 수 없습니다. 장치를 확인해주세요."
        case .invalidQRCode:
            return "유효하지 않은 QR 코드입니다. 다른 QR 코드를 스캔해주세요."
        }
    }
}
