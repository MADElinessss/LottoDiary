//
//  KakaoMapViewController.swift
//  LottoDiary
//
//  Created by Madeline on 3/19/24.
//

import UIKit
import SnapKit

class KakaoMapViewController: UIViewController {
    
    private let segmentControl = UISegmentedControl(items: ["복권 판매점 지도", "주변 복권 판매점"])
    private var storeMapViewController: StoreMapViewController!
    private var tableViewController: StoreListViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureSegmentControl()
        configureChildViewControllers()
        setupDataPassingBetweenControllers()
        
    }
    
    private func configureSegmentControl() {
        view.addSubview(segmentControl)
        segmentControl.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(8)
            make.centerX.equalTo(view)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
        }
        segmentControl.addTarget(self, action: #selector(segmentControlValueChanged(_:)), for: .valueChanged)
        segmentControl.selectedSegmentIndex = 0
    }
    
    private func configureChildViewControllers() {
        storeMapViewController = StoreMapViewController()
        tableViewController = StoreListViewController()
        
        storeMapViewController.onSearchResultReceived = { [weak tableViewController] documents in
            tableViewController?.setDocuments(documents)
        }
        
        addChild(storeMapViewController)
        addChild(tableViewController)
        
        view.addSubview(storeMapViewController.view)
        view.addSubview(tableViewController.view)
        
        storeMapViewController.didMove(toParent: self)
        tableViewController.didMove(toParent: self)
        
        storeMapViewController.view.snp.makeConstraints { make in
            make.top.equalTo(segmentControl.snp.bottom).offset(8)
            make.left.right.bottom.equalTo(view)
        }
        
        tableViewController.view.snp.makeConstraints { make in
            make.top.equalTo(segmentControl.snp.bottom).offset(8)
            make.left.right.bottom.equalTo(view)
        }
        
        tableViewController.view.isHidden = true
    }
    
    private func setupDataPassingBetweenControllers() {
        storeMapViewController.onSearchResultReceived = { [weak self] documents in
            DispatchQueue.main.async {
                self?.tableViewController.setDocuments(documents)
            }
        }
    }
    
    @objc private func segmentControlValueChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            storeMapViewController.view.isHidden = false
            tableViewController.view.isHidden = true
        case 1:
            storeMapViewController.view.isHidden = true
            tableViewController.view.isHidden = false
            tableViewController.tableView.reloadData()
        default:
            break
        }
    }
}
