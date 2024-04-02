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
        configureNavigationBar(title: "로또 결과 확인", rightBarButton: nil)
        
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
}

extension LottoResultViewController {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let height = UIScreen.main.bounds.height
        if indexPath.section == 0 {
            if height > 700 {
                return height * 0.18
            } else {
                return height * 0.22
            }
        } else if indexPath.section == 1 {
            return 44
        } else {
            return 60
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "MyLottoTableViewCell", for: indexPath) as! MyLottoTableViewCell
            cell.prizeLabel.isHidden = true
            if let lotto = self.lotto {
                cell.configureView(with: lotto)
            } else {
                cell.titleLabel.text = "로또 정보를 받아오는 데에 실패했어요."
            }

            cell.chevronImage.isHidden = true
            cell.clipsToBounds = true
            cell.layer.cornerRadius = 15
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            if let winningResult = self.winningResult {
                cell.textLabel?.text = "당첨 결과: \(winningResult.rank)"
            } else {
                cell.textLabel?.text = "당첨 결과 정보가 없습니다."
            }
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "NumberDisplayTableViewCell", for: indexPath) as! NumberDisplayTableViewCell
            
            let numbersToDisplay = userNumbers ?? Set<Int>()
            cell.configure(with: Array(numbersToDisplay), highlightedNumbers: winningResult?.matchedNumbers ?? Set<Int>())
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
