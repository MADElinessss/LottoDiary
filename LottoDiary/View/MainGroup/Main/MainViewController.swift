//
//  MainViewController.swift
//  LottoDiary
//
//  Created by Madeline on 3/7/24.
//

import SnapKit
import UIKit

final class MainViewController: BaseViewController {
    let logoImage = UIImageView()
    let titleView = UIView()
    let titleLabel = UILabel()
    let tableView = MainTableView()
    let viewModel = MainViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupBindings()
        viewModel.apiRequest(on: self)
    }
    
    func setupBindings() {
        viewModel.outputLotto.bind { [weak self] lotto in
            guard let lotto = lotto else { return }
        }
        
        viewModel.errorMessage.bind { [weak self] errorMessage in
            guard let message = errorMessage, !message.isEmpty else { return }
            DispatchQueue.main.async {
                AlertManager.shared.showAlert(on: self!, title: "오류", message: message)
            }
        }
    }
    
    private func showErrorAlert(message: String) {
        let alert = UIAlertController(title: "오류", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default))
        DispatchQueue.main.async {
            self.present(alert, animated: true)
        }
    }
    
    override func configureHierarchy() {
        titleView.addSubview(logoImage)
        titleView.addSubview(titleLabel)
        view.addSubview(tableView)
    }
    
    override func configureLayout() {
        logoImage.snp.makeConstraints { make in
            make.center.equalTo(titleView)
            make.size.equalTo(30)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleView).inset(16)
            make.centerX.equalTo(titleView)
        }

        tableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide).inset(8)
        }
    }
    
    override func configureView() {
        logoImage.image = UIImage(named: "appstore")
        logoImage.contentMode = .scaleAspectFit
        titleLabel.text = "로또 일기"
        titleLabel.font = .systemFont(ofSize: 16, weight: .bold)
        
        self.navigationItem.titleView = titleView
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .background
        tableView.register(MyLottoTableViewCell.self, forCellReuseIdentifier: "MyLottoTableViewCell")
        tableView.register(MenuTableViewCell.self, forCellReuseIdentifier: "MenuTableViewCell")
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")
        tableView.separatorStyle = .none
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
            viewModel.outputLotto.bind { [weak self] lotto in
                guard let lotto = lotto else { return }
                print("🥔🥔", lotto)
                cell.configureView(with: lotto)
            }
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
            return 320
        } else {
            return 60
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            let vc = MyLottoViewController()
            navigationController?.pushViewController(vc, animated: true)
        } else if indexPath.section == 2 {
            let vc = WebViewController()
            navigationController?.pushViewController(vc, animated: true)
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
            let vc = ListMyNumberViewController()
            navigationController?.pushViewController(vc, animated: true)
        case 3:
            // 복권 판매점
            let vc = KakaoMapViewController()
            navigationController?.pushViewController(vc, animated: true)
        default:
            break
        }
    }
}
