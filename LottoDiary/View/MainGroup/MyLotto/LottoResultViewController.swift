//
//  LottoResultViewController.swift
//  LottoDiary
//
//  Created by Madeline on 3/30/24.
//

import UIKit
import SnapKit

class LottoResultViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    var winningResult: (rank: String, matchedNumbers: Set<Int>)!
    var userNumbers: Set<Int>!
    var lotto: Lotto?
    
    let viewModel = NumberViewModel()
    private let tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        configureNavigationBar(title: "로또 결과 확인", leftBarButton: nil, rightBarButton: nil)
        
        setupTableView()
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.register(NumberDisplayTableViewCell.self, forCellReuseIdentifier: "NumberDisplayTableViewCell")
        tableView.register(MyLottoTableViewCell.self, forCellReuseIdentifier: "MyLottoTableViewCell")
        tableView.backgroundColor = UIColor(named: "background")
        tableView.separatorStyle = .none
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "MyLottoTableViewCell", for: indexPath) as! MyLottoTableViewCell
            
            if let lotto = self.lotto {
                cell.configureView(with: lotto)
                print("🍋")
            } else {
                cell.titleLabel.text = "로또 정보 없음"
                print("🫒")
            }

            cell.chevronImage.isHidden = true
            cell.clipsToBounds = true
            cell.layer.cornerRadius = 15
            return cell
        case 1:
            // 당첨 결과를 표시하는 셀
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell.textLabel?.text = "당첨 결과: \(winningResult.rank)"
            cell.textLabel?.font = .pretendard(size: 16, weight: .medium)
            return cell
        case 2:
            // 사용자 번호를 원형 버튼으로 표시하는 셀
            let cell = tableView.dequeueReusableCell(withIdentifier: "NumberDisplayTableViewCell", for: indexPath) as! NumberDisplayTableViewCell
            cell.configure(with: Array(userNumbers), highlightedNumbers: winningResult.matchedNumbers)
            return cell
        default:
            fatalError("Unexpected section")
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 1 {
            let headerView = UIView()
            return headerView
        } else {
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
}
