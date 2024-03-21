//
//  SixRandomNumbersViewController.swift
//  LottoDiary
//
//  Created by Madeline on 3/21/24.
//

import SnapKit
import UIKit

class SixRandomNumbersViewController: BaseViewController {
    
    let numberMakerButton = UIButton()
    let descriptionLabel = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()

        let leftButton = createBarButtonItem(imageName: "chevron.left", action: #selector(leftButtonTapped))
        
        configureNavigationBar(title: "랜덤 로또 번호 추천", leftBarButton: leftButton, rightBarButton: nil)
        
    }
    
    @objc func leftButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    override func configureHierarchy() {
        view.addSubview(numberMakerButton)
        view.addSubview(descriptionLabel)
    }
    
    override func configureLayout() {
        numberMakerButton.snp.makeConstraints { make in
            make.centerX.equalTo(view)
            make.top.equalTo(view.safeAreaLayoutGuide).inset(44)
            make.height.equalTo(44)
            make.width.equalTo(100)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.centerX.equalTo(view)
            make.top.equalTo(numberMakerButton.snp.bottom).offset(150)
        }
    }
    
    override func configureView() {
        numberMakerButton.titleLabel?.text = "로또 번호 뽑기"
        numberMakerButton.setTitleColor(.white, for: .normal)
        numberMakerButton.tintColor = .point
        numberMakerButton.layer.cornerRadius = 15
        
        descriptionLabel.text = "위 번호는 랜덤으로 뽑힙니다."
    }
    
}
