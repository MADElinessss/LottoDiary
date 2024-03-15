//
//  BaseViewController.swift
//  LottoDiary
//
//  Created by Madeline on 3/7/24.
//

import UIKit

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        configureHierarchy()
        configureLayout()
        configureView()
        view.backgroundColor = .background
    }
    
    func configureHierarchy() {
        
        
    }
    
    func configureLayout() {
        
    }
    
    func configureView() {
        
        
    }
    
    func configureNavigationBar(title: String, leftBarButton: UIBarButtonItem? = nil, rightBarButton: UIBarButtonItem? = nil) {
        self.navigationItem.title = title
        
        if let leftButton = leftBarButton {
            self.navigationItem.leftBarButtonItem = leftButton
        }
        
        if let rightButton = rightBarButton {
            self.navigationItem.rightBarButtonItem = rightButton
        }
    }
    
    func createBarButtonItem(imageName: String, action: Selector) -> UIBarButtonItem {
        let barButtonItem = UIBarButtonItem(image: UIImage(systemName: imageName), style: .plain, target: self, action: action)
        barButtonItem.tintColor = .pointSymbol
        return barButtonItem
    }
    
    /*
     let leftButton = createBarButtonItem(imageName: "chevron.left", action: #selector(leftButtonTapped))
     let rightButton = createBarButtonItem(imageName: "ellipsis", action: #selector(rightButtonTapped))
     configureNavigationBar(title: "Detail View", leftBarButton: leftButton, rightBarButton: rightButton)
     */
    
}
