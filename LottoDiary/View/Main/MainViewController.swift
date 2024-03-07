//
//  MainViewController.swift
//  LottoDiary
//
//  Created by Madeline on 3/7/24.
//

import UIKit

class MainViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigationBar(title: "로또 일기", leftBarButton: nil, rightBarButton: nil)
    }
    
    @objc func leftButtonTapped() {
        
        print("Left button tapped")
    }
    
    @objc func rightButtonTapped() {
        
        print("Right button tapped")
    }
    
}
