//
//  MainViewController.swift
//  LottoDiary
//
//  Created by Madeline on 3/7/24.
//

import SnapKit
import UIKit

final class MainViewController: BaseViewController {

    let tableView = UITableView()
    let viewModel = MainViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        APIManager.shared.lottoCallRequest(drwNumber: 1110) { lotto in
            print(lotto)
        }
        
    }
    
    override func configureHierarchy() {
        view.addSubview(tableView)
    }
    
    override func configureLayout() {
        tableView.snp.makeConstraints { make in
            make.verticalEdges.equalTo(view)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(8)
        }
    }
    
    override func configureView() {
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .background
        tableView.register(MyLottoTableViewCell.self, forCellReuseIdentifier: "MyLottoTableViewCell")
        tableView.register(MenuTableViewCell.self, forCellReuseIdentifier: "MenuTableViewCell")
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")
        tableView.separatorStyle = .none
        
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
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MyLottoTableViewCell", for: indexPath) as! MyLottoTableViewCell
            cell.clipsToBounds = true
            cell.layer.cornerRadius = 15
            return cell
        } else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MenuTableViewCell", for: indexPath) as! MenuTableViewCell
            cell.onItemTapped = { [weak self] itemIndex in
                self?.navigateToViewController(for: itemIndex)
            }
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)
            cell.textLabel?.text = "복권 구매"
            cell.clipsToBounds = true
            cell.layer.cornerRadius = 15
            cell.selectionStyle = .none
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 170
        } else if indexPath.section == 1 {
            return 350
        } else {
            return 60
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if section == 1 {
            let headerLabel = UILabel()
            return headerLabel
        } else {
            return nil
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 1 {
            return 4
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            let vc = MyLottoViewController()
            navigationController?.pushViewController(vc, animated: true)
        } else if indexPath.section == 2 {
            let vc = WebViewController()
            navigationController?.pushViewController(vc, animated: true)
        } else {
            
        }
    }
    
    func navigateToViewController(for index: Int) {
        switch index {
        case 0:
            // 번호 생성기
             let vc = RandomNumberMakerViewController()
             navigationController?.pushViewController(vc, animated: true)
        case 1:
            // 나의 당첨내역
            print("winning")
            // let vc = WinningHistoryViewController()
            // navigationController?.pushViewController(vc, animated: true)
        case 2:
            // 나의 번호 목록
            let vc = MyNumberViewController()
            navigationController?.pushViewController(vc, animated: true)
        case 3:
            // 복권 판매점
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let storeMapVC = storyboard.instantiateViewController(withIdentifier: "StoreMapViewControllerID") as? StoreMapViewController {
                navigationController?.pushViewController(storeMapVC, animated: true)
            } else {
                print("Failed to instantiate StoreMapViewController from storyboard")
            }
        default:
            break
        }
    }
}
