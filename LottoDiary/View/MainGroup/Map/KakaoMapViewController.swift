//
//  KakaoMapViewController.swift
//  LottoDiary
//
//  Created by Madeline on 3/19/24.
//

import SnapKit
import UIKit

// 0 - 지도, 1 - 테이블뷰
class KakaoMapViewController: UIViewController {
    
    let segmentControl = UISegmentedControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureSegment()
    }
    
    func configureSegment() {
        view.addSubview(segmentControl)
        
        segmentControl.selectedSegmentIndex = 0
        
        segmentControl.snp.makeConstraints { make in
            make.horizontalEdges.top.equalTo(view.safeAreaLayoutGuide)
        }
    }
}
