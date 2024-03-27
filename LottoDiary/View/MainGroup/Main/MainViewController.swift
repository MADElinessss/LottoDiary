//
//  MainViewController.swift
//  LottoDiary
//
//  Created by Madeline on 3/7/24.
//

import SnapKit
import UIKit
import RealmSwift

final class MainViewController: BaseViewController {
    let logoImage = UIImageView()
    let titleView = UIView()
    let titleLabel = UILabel()
    let tableView = MainTableView()
    let viewModel = MainViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Realm 데이터베이스 파일 위치 출력
        if let url = Realm.Configuration.defaultConfiguration.fileURL {
            print("Realm Database File URL: \(url)")
        }

        setupBindings()
        viewModel.apiRequest(on: self)
        configureNavigationBar(title: "로또 일기")
        
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func setupBindings() {
        
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
        view.addSubview(tableView)
    }
    
    func configureNavigationBar(title: String) {
        let logoImageView = UIImageView(image: UIImage(named: "appstore"))
        logoImageView.contentMode = .scaleAspectFit
        titleView.addSubview(logoImageView)

        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = .systemFont(ofSize: 16, weight: .bold)
        titleView.addSubview(titleLabel)

        logoImageView.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.height.equalTo(40)
        }

        titleLabel.snp.makeConstraints { make in
            make.left.equalTo(logoImageView.snp.right).offset(8)
            make.centerY.equalToSuperview()
            make.right.lessThanOrEqualToSuperview()
        }

        self.navigationItem.titleView = titleView
    }

    override func configureLayout() {
        tableView.snp.makeConstraints { make in
            make.top.equalTo(view)
            make.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide).inset(16)
        }
    }
    
    override func configureView() {
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
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MyLottoTableViewCell", for: indexPath) as! MyLottoTableViewCell
            
//             cell.clipsToBounds = true
//             cell.layer.cornerRadius = 15
            
            viewModel.outputLotto.bind { [weak self] lotto in
                guard let lotto = lotto else { return }
                print("🥔🥔", lotto)
                cell.configureView(with: lotto)
            }
            return cell
        } else  {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MenuTableViewCell", for: indexPath) as! MenuTableViewCell
            cell.onItemTapped = { [weak self] itemIndex in
                self?.navigateToViewController(for: itemIndex)
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let height = UIScreen.main.bounds.height
        
        if indexPath.section == 0 {
            if height > 700 {
                return height * 0.2
            } else {
                return height * 0.24
            }
            
        } else {
            if height > 700 {
                return height * 0.42
            } else {
                return height * 0.53
            }
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat.leastNonzeroMagnitude
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNonzeroMagnitude
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            let vc = MyLottoViewController()
            navigationController?.pushViewController(vc, animated: true)
        } else if indexPath.section == 2 {
            let vc = WebViewController(urlString: "https://www.dhlottery.co.kr/", navigationTitle: "로또 구매하기")
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func navigateToViewController(for index: Int) {
        switch index {
        case 0:
            
            // 나의 번호 목록
            let vc = ListMyNumberViewController()
            navigationController?.pushViewController(vc, animated: true)
            
        case 1:
            // 나의 당첨내역
            print("winning")
            // let vc = WinningHistoryViewController()
            // navigationController?.pushViewController(vc, animated: true)
        case 2:
            // 번호 생성기
            let vc = RandomNumberMakerViewController()
            navigationController?.pushViewController(vc, animated: true)
        case 3:
            // 복권 판매점
            let vc = MapViewController()
            navigationController?.pushViewController(vc, animated: true)
        default:
            break
        }
    }
}
