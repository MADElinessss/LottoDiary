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
        configureNavigationBar()
        setupBindings()
        // viewModel.apiRequest()
        configureNavigationBar(title: "로또 일기")
        
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func setupBindings() {
        viewModel.errorMessage.bind { [weak self] errorMessage in
            guard let message = errorMessage, !message.isEmpty else { return }
            DispatchQueue.main.async {
                AlertManager.shared.showAlert(on: self!, title: "네트워크 오류", message: message)
            }
        }
    }
    
    override func configureHierarchy() {
        view.addSubview(tableView)
    }
    
    func configureNavigationBar() {
        let customNavigationBar = CustomNavigationBar(title: "로또 일기", logoImage: UIImage(named: "appstore"))
        navigationItem.titleView = customNavigationBar
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
        tableView.register(AdBannerTableViewCell.self, forCellReuseIdentifier: AdBannerTableViewCell.identifier)
        tableView.separatorStyle = .none
        tableView.isScrollEnabled = true
        tableView.showsVerticalScrollIndicator = false
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
            cell.selectionStyle = .none
            cell.clipsToBounds = true
            cell.layer.cornerRadius = 15
            
            viewModel.outputLotto.bind { lotto in
                guard let lotto = lotto else { return }
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
            let cell = tableView.dequeueReusableCell(withIdentifier: AdBannerTableViewCell.identifier, for: indexPath) as! AdBannerTableViewCell
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
            
        } else if indexPath.section == 1 {
            if height > 700 {
                return height * 0.42
            } else {
                return height * 0.53
            }
        } else {
            return height * 0.11
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            let vc = MyLottoViewController(viewModel: viewModel)
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
//             let vc = MyLottoResultViewController()
//             navigationController?.pushViewController(vc, animated: true)
            AlertManager.shared.showOKayAlert(on: self, title: "업데이트 기능", message: "곧 업데이트될 예정이에요.\n개발자를 응원해주세요🥺")
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
