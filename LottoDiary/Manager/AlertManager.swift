//
//  AlertManager.swift
//  LottoDiary
//
//  Created by Madeline on 3/20/24.
//

import Foundation
import UIKit

class AlertManager {
    static let shared = AlertManager()
    
    private init() {}
    
    func showAlert(on viewController: UIViewController,
                   title: String,
                   message: String,
                   confirmButtonText: String = "확인",
                   cancelButtonText: String? = nil,
                   confirmAction: (() -> Void)? = nil,
                   cancelAction: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let ok = UIAlertAction(title: confirmButtonText, style: .default) { _ in
            confirmAction?()
        }
        alert.addAction(ok)
        
        if let cancelButtonText = cancelButtonText {
            let cancel = UIAlertAction(title: cancelButtonText, style: .cancel) { _ in
                cancelAction?()
            }
            alert.addAction(cancel)
        }
        
        DispatchQueue.main.async {
            viewController.present(alert, animated: true)
        }
    }
    
    func showOKayAlert(on viewController: UIViewController,
                   title: String,
                   message: String,
                   confirmButtonText: String = "확인",
                   confirmAction: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let ok = UIAlertAction(title: confirmButtonText, style: .default) { _ in
            confirmAction?()
        }
        alert.addAction(ok)
        
        DispatchQueue.main.async {
            viewController.present(alert, animated: true)
        }
    }

}
