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
    
    let tableView = UITableView()
    
//    var no1: Int = 0
//    var no2: Int = 0
//    var no3: Int = 0
//    var no4: Int = 0
//    var no5: Int = 0
//    var no6: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func configureHierarchy() {
        view.addSubview(tableView)
    }
    
    override func configureLayout() {
        tableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    override func configureView() {
        let leftButton = createBarButtonItem(imageName: "chevron.left", action: #selector(leftButtonTapped))
        let rightButton = createBarButtonItem(imageName: "ellipsis", action: #selector(rightButtonTapped))
        configureNavigationBar(title: "Detail View", leftBarButton: leftButton, rightBarButton: rightButton)
    }
    
    @objc func leftButtonTapped() {
        
    }
    
    @objc func rightButtonTapped() {
        
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
