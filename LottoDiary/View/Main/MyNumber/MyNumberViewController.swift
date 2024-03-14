//
//  MyNumberViewController.swift
//  LottoDiary
//
//  Created by Madeline on 3/12/24.
//

import SnapKit
import UIKit

// TODO: UI 구현
final class MyNumberViewController: BaseViewController {
    
    let headerLabel = UILabel()
    let stackView = UIStackView()
    // let collectionView = UICollectionView()
    
    var no1: Int = 0
    var no2: Int = 0
    var no3: Int = 0
    var no4: Int = 0
    var no5: Int = 0
    var no6: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func configureHierarchy() {
        view.addSubview(headerLabel)
        view.addSubview(stackView)
    }
    
    override func configureLayout() {
        headerLabel.snp.makeConstraints { make in
            make.leading.equalTo(view.safeAreaLayoutGuide)
            make.top.equalTo(view.safeAreaLayoutGuide).inset(16)
        }
        stackView.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.top.equalTo(view.safeAreaLayoutGuide).inset(44)
            make.height.equalTo(30)
        }
    }
    
    override func configureView() {
        headerLabel.text = "번호 선택"
        headerLabel.font = .systemFont(ofSize: 16, weight: .regular)
        headerLabel.textColor = .black
        
        stackView.distribution = .fillEqually
        stackView.spacing = 12
        
        
        let drawNumbers = [no1, no2, no3, no4, no5, no6]
        
        for i in drawNumbers {
            let buttonColor = color(for: i)
            let button = NumberButton(backgroundColor: buttonColor, number: i)
            stackView.addArrangedSubview(button)
        }
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func color(for drawNumber: Int) -> UIColor {
        switch drawNumber {
        case 1...10:
            return UIColor(named: "lotteryYellow") ?? .yellow
        case 11...20:
            return UIColor(named: "lotteryBlue") ?? .blue
        case 21...30:
            return UIColor(named: "lotteryRed") ?? .red
        case 31...40:
            return UIColor(named: "lotteryGray") ?? .gray
        case 41...45:
            return UIColor(named: "lotteryGreen") ?? .green
        default:
            return .gray // 기본값으로 검정색 사용
        }
    }
}
