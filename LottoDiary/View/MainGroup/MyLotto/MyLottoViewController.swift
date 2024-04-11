//
//  MyLottoViewController.swift
//  LottoDiary
//
//  Created by Madeline on 3/11/24.
//

import SnapKit
import UIKit

final class MyLottoViewController: BaseViewController {

    let tableView = UITableView()
    var viewModel: MainViewModel

    init(viewModel: MainViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupBindings()
        viewModel.apiRequest()
        
    }
    
    func setupBindings() {
        viewModel.outputLotto.bind { lotto in
            guard let lotto = lotto else { return }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }

        viewModel.errorMessage.bind { [weak self] errorMessage in
            guard let message = errorMessage, !message.isEmpty else { return }
            DispatchQueue.main.async {
                AlertManager.shared.showAlert(on: self!, title: "오류", message: message)
            }
        }
    }
    
    override func configureHierarchy() {
        view.addSubview(tableView)
    }
    
    override func configureLayout() {
        tableView.snp.makeConstraints { make in
            make.verticalEdges.equalTo(view)
            make.leading.equalTo(view.safeAreaLayoutGuide).inset(8)
            make.trailing.equalTo(view.safeAreaLayoutGuide).inset(8)
        }
    }
    
    override func configureView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .background
        tableView.register(MyLottoTableViewCell.self, forCellReuseIdentifier: "MyLottoTableViewCell")
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")
        tableView.separatorStyle = .none
        tableView.isScrollEnabled = false
        
        configureNavigationBar(title: "나의 로또", rightBarButton: nil)
    }
}

extension MyLottoViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return 2
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MyLottoTableViewCell", for: indexPath) as! MyLottoTableViewCell
            let lotto = viewModel.outputLotto.value
            cell.configureView(with: lotto)
            cell.chevronImage.isHidden = true
            cell.clipsToBounds = true
            cell.layer.cornerRadius = 15
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)
            if indexPath.row == 0 {
                cell.textLabel?.text = "QR 코드 인식"
            } else {
                cell.textLabel?.text = "번호 직접 입력"
            }
            
            cell.clipsToBounds = true
            cell.layer.cornerRadius = 15
            cell.selectionStyle = .none
            
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 170
        } else {
            return 60
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if section == 1 {
            let headerLabel = UILabel()
            headerLabel.text = "결과 확인하기"
            headerLabel.font = .pretendard(size: 14, weight: .regular)
            return headerLabel
        } else {
            return nil
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 1 {
            return 24
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // "QR 코드 인식"
        if indexPath.section == 1 && indexPath.row == 0 {
            let vc = QRCodeViewController()
            navigationController?.pushViewController(vc, animated: true)
        } else {
            // "번호 직접 입력"
            let vc = MyLottoResultViewController()
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}
