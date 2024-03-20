//
//  EditMyNumberTableViewCell.swift
//  LottoDiary
//
//  Created by Madeline on 3/20/24.
//

import UIKit

class EditMyNumberTableViewCell: UITableViewCell {

    private let stackView = UIStackView()
    private var selectedButtons: [UIButton] = []
    private let numberSelectionView = NumberSelectionView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configure()
        setupConstraints()
        setupButtonActions()
        
    }
    
    func configure() {
        
        contentView.backgroundColor = .background
        contentView.addSubview(stackView)
        contentView.addSubview(numberSelectionView)
        setupNumberSelectionView()
        numberSelectionView.snp.makeConstraints { make in
            make.top.equalTo(contentView.safeAreaLayoutGuide).inset(70)
            make.horizontalEdges.bottom.equalToSuperview()
        }
        
        setupStackView()
        setupNumberSelectionView()
    }
    
    private func setupButtonActions() {
        for (index, button) in selectedButtons.enumerated() {
            button.tag = index
            button.addTarget(self, action: #selector(selectedNumberButtonTapped(_:)), for: .touchUpInside)
        }
    }
    
    @objc private func selectedNumberButtonTapped(_ sender: UIButton) {
        guard let title = sender.title(for: .normal), let numberToRemove = Int(title) else { return }
        
        numberSelectionView.selectedNumbers.removeAll { $0 == numberToRemove }
        updateSelectedNumbers(numberSelectionView.selectedNumbers)
        numberSelectionView.updateUI()
    }
    
    private func setupStackView() {
        
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 10
        stackView.backgroundColor = .background
        stackView.layer.cornerRadius = 15

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
    }
    
    private func setupConstraints() {
        stackView.snp.makeConstraints { make in
            make.top.equalTo(contentView.safeAreaLayoutGuide)
            make.horizontalEdges.equalTo(contentView.safeAreaLayoutGuide).inset(16)
            make.centerX.equalTo(contentView)
            //make.height.equalTo(50)
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
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
