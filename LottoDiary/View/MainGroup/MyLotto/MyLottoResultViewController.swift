//
//  MyLottoResultViewController.swift
//  LottoDiary
//
//  Created by Madeline on 3/24/24.
//

import UIKit

class MyLottoResultViewController: BaseViewController {
    
    private let tableView = UITableView()
    private let memoTextField = UITextField()
    let viewModel = NumberViewModel()
    let resultButton = UIButton()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateTitlePlaceholder()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        setupView()
        updateTitlePlaceholder()
        
    }

    func updateTitlePlaceholder() {
        let nextTitle = viewModel.repository.findNextDefaultTitle()
        memoTextField.placeholder = nextTitle
    }
    
    private func configureTableView() {
        view.addSubview(tableView)
        view.addSubview(resultButton)
        tableView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(100)
        }
        resultButton.snp.makeConstraints { make in
            make.top.equalTo(tableView.snp.bottom)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(24)
            make.centerX.equalTo(view)
            make.height.equalTo(44)
        }
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.register(EditMyNumberTableViewCell.self, forCellReuseIdentifier: "EditMyNumberTableViewCell")
        tableView.separatorStyle = .none
        tableView.tableFooterView = UIView()
        tableView.backgroundColor = .background
        
        resultButton.backgroundColor = .point
        resultButton.layer.cornerRadius = 15
        resultButton.setTitle("결과 확인하기", for: .normal)
        resultButton.titleLabel?.font = .pretendard(size: 18, weight: .bold)
        resultButton.addTarget(self, action: #selector(resultButtonTapped), for: .touchUpInside)
    }
    
    @objc func resultButtonTapped() {
        print("👼🏻")
    }
    
    private func setupView() {
        view.backgroundColor = .background
        
        let leftButton = createBarButtonItem(imageName: "chevron.left", action: #selector(leftButtonTapped))
        
        configureNavigationBar(title: "번호 직접 입력", leftBarButton: leftButton, rightBarButton: nil)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func leftButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension MyLottoResultViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UIScreen.main.bounds.width
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "EditMyNumberTableViewCell", for: indexPath) as! EditMyNumberTableViewCell
        cell.onNumbersSelected = { [weak self] selectedNumbers in
            self?.viewModel.selectedNumbers.value = selectedNumbers
        }
        
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "번호 선택"
    }
}
