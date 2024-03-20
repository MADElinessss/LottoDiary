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
    private let stackView = UIStackView()
    private var selectedButtons: [UIButton] = []
    private let memoTextField = UITextField()
    private let numberSelectionView = NumberSelectionView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        setupView()
        setupConstraints()
        setupButtonActions()
    }
    
    private func configureTableView() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.separatorStyle = .none
        tableView.tableFooterView = UIView()
        
    }
    
    private func setupButtonActions() {
        for (index, button) in selectedButtons.enumerated() {
            button.tag = index
            button.addTarget(self, action: #selector(selectedNumberButtonTapped(_:)), for: .touchUpInside)
        }
    }
    
    
    private func setupView() {
        view.backgroundColor = .white
        
        let leftButton = createBarButtonItem(imageName: "chevron.left", action: #selector(leftButtonTapped))
        let rightButton = UIBarButtonItem(title: "저장", style: .done, target: self, action: #selector(rightButtonTapped))
        configureNavigationBar(title: "나의 번호 편집", leftBarButton: leftButton, rightBarButton: rightButton)
        
        
        setupStackView()
        setupNumberSelectionView()
    }
    
    @objc private func selectedNumberButtonTapped(_ sender: UIButton) {
        guard let title = sender.title(for: .normal), let numberToRemove = Int(title) else { return }
        
        numberSelectionView.selectedNumbers.removeAll { $0 == numberToRemove }
        updateSelectedNumbers(numberSelectionView.selectedNumbers)
        numberSelectionView.updateUI()
    }
    
    
    @objc func leftButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func rightButtonTapped() {
        // TODO: Realm 저장
    }
    
    
    private func setupStackView() {
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 10
        view.addSubview(stackView)
        
        for _ in 0..<6 {
            let button = UIButton()
            button.backgroundColor = .lightGray
            button.setTitleColor(.white, for: .normal)
            button.layer.cornerRadius = 25
            selectedButtons.append(button)
            stackView.addArrangedSubview(button)
        }
    }
    
    private func setupNumberSelectionView() {
        numberSelectionView.onNumberSelected = { [weak self] selectedNumbers in
            self?.updateSelectedNumbers(selectedNumbers)
        }
        view.addSubview(numberSelectionView)
    }
    
    private func setupConstraints() {
        stackView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.centerX.equalTo(view)
            make.height.equalTo(50)
        }
        
        numberSelectionView.snp.makeConstraints { make in
            make.top.equalTo(stackView.snp.bottom).offset(20)
            make.left.right.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        selectedButtons.forEach { button in
            button.snp.makeConstraints { make in
                make.width.equalTo(button.snp.height)
            }
        }
    }
    
    private func updateSelectedNumbers(_ numbers: [Int]) {
        selectedButtons.forEach {
            $0.setTitle("", for: .normal)
            $0.backgroundColor = .lightGray
        }
        
        for (index, number) in numbers.enumerated() {
            if index < selectedButtons.count {
                let button = selectedButtons[index]
                button.setTitle("\(number)", for: .normal)
                button.backgroundColor = color(for: number)
            }
        }
    }
    
    private func color(for drawNumber: Int) -> UIColor {
        switch drawNumber {
        case 1...10:
            return UIColor(named: "lotteryYellow") ?? .yellow
        case 11...20:
            return UIColor(named: "lotteryBlue") ?? .blue
        case 21...30:
            return UIColor(named: "lotteryRed") ?? .red
        case 31...40:
            return UIColor(named: "lotteryGray") ?? .gray
        case 41...45:
            return UIColor(named: "lotteryGreen") ?? .green
        default:
            return .lightGray
        }
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
            return 300
        } else {
            return 100
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.selectionStyle = .none
        
        if indexPath.section == 0 {
            // 번호 선택 섹션
            setupNumberSelectionView()
            cell.contentView.addSubview(numberSelectionView)
            numberSelectionView.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
        } else if indexPath.section == 1 {
            // 번호 메모 섹션
            setupMemoTextField()
            cell.contentView.addSubview(memoTextField)
            memoTextField.snp.makeConstraints { make in
                make.edges.equalToSuperview().inset(16)
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? "번호 선택" : "번호 메모"
    }
    
    private func setupMemoTextField() {
        let number: Int = 1
        memoTextField.placeholder = "나의 번호(\(number)"
        memoTextField.borderStyle = .roundedRect
    }
}
