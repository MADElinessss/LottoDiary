//
//  MainViewController.swift
//  LottoDiary
//
//  Created by Madeline on 3/7/24.
//

import SnapKit
import UIKit

class MainViewController: BaseViewController {

    let tableView = UITableView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        APIManager.shared.lottoCallRequest(drwNumber: 1109) { lotto in
            print(lotto)
        }
        
    }
    
    override func configureHierarchy() {
        view.addSubview(tableView)
    }
    
    override func configureLayout() {
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view)
        }
    }
    
    override func configureView() {
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(MyLottoTableViewCell.self, forCellReuseIdentifier: "MyLottoTableViewCell")
        
        configureNavigationBar(title: "로또 일기", leftBarButton: nil, rightBarButton: nil)
    }
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyLottoTableViewCell", for: indexPath) as! MyLottoTableViewCell
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
}
