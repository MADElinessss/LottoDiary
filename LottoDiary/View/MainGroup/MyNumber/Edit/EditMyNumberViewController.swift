//
//  MyNumberViewController.swift
//  LottoDiary
//
//  Created by Madeline on 3/12/24.
//

import SnapKit
import UIKit

// MARK: 로또 편집 뷰로 옮겨야됨
final class EditMyNumberViewController: BaseViewController {
    
    private let tableView = UITableView()
    private let memoTextField = UITextField()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        setupView()
        
    }
    
    private func configureTableView() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.register(EditMyNumberTableViewCell.self, forCellReuseIdentifier: "EditMyNumberTableViewCell")
        tableView.separatorStyle = .none
        tableView.tableFooterView = UIView()
        tableView.backgroundColor = .background
        
    }
    
    private func setupView() {
        view.backgroundColor = .white
        
        let leftButton = createBarButtonItem(imageName: "chevron.left", action: #selector(leftButtonTapped))
        let rightButton = UIBarButtonItem(title: "저장", style: .done, target: self, action: #selector(rightButtonTapped))
        configureNavigationBar(title: "나의 번호 편집", leftBarButton: leftButton, rightBarButton: rightButton)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func leftButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func rightButtonTapped() {
        // TODO: Realm 저장
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension EditMyNumberViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            let height = UIScreen.main.bounds.width
            return height
        } else {
            return 44
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            // 번호 선택 섹션
            let cell = tableView.dequeueReusableCell(withIdentifier: "EditMyNumberTableViewCell", for: indexPath) as! EditMyNumberTableViewCell
            cell.selectionStyle = .none
            return cell
        } else {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell.selectionStyle = .none
            cell.backgroundColor = .white
            cell.layer.cornerRadius = 15
            // 번호 메모 섹션
            setupMemoTextField()
            cell.contentView.addSubview(memoTextField)
            memoTextField.snp.makeConstraints { make in
                make.horizontalEdges.equalTo(cell.contentView.safeAreaLayoutGuide).inset(16)
                make.height.equalTo(44)
            }
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? "번호 선택" : "번호 메모"
    }
    
    private func setupMemoTextField() {
        let number: Int = 1
        memoTextField.placeholder = "나의 번호(\(number))"
        memoTextField.borderStyle = .none
        memoTextField.textColor = .black
    }
}
