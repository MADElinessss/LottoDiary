//
//  NumberButton.swift
//  LottoDiary
//
//  Created by Madeline on 3/7/24.
//

import UIKit

class NumberButton: UIButton {

    init(backgroundColor: UIColor, number: Int?) {
        super.init(frame: .zero)
        self.backgroundColor = backgroundColor
        if let number = number {
            setTitle("\(number)", for: .normal)
        }
        setTitleColor(.white, for: .normal)
        configureButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureButton() {
        frame.size = CGSize(width: 30, height: 30)
        
        layer.cornerRadius = frame.height / 2
        
        titleLabel?.font = UIFont.systemFont(ofSize: 14)
        titleLabel?.textAlignment = .center
    }
}
