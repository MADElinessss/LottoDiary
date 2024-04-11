//
//  ListMyNumberTableViewCell.swift
//  LottoDiary
//
//  Created by Madeline on 3/20/24.
//

import UIKit

class ListMyNumberTableViewCell: UITableViewCell {
    
    let titleLabel = UILabel()
    private let stackView = UIStackView()
    private var buttons: [UIButton] = []
    let viewModel = NumberViewModel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureView()
        
    }
    private func configureView() {
        contentView.addSubview(stackView)
        contentView.addSubview(titleLabel)
        
        backgroundColor = .white
        
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 10
        
        titleLabel.text = "나의 번호(1)"
        titleLabel.font = .pretendard(size: 16, weight: .regular)
        titleLabel.textColor = .black
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(contentView.safeAreaLayoutGuide).inset(16)
            make.leading.equalTo(contentView.safeAreaLayoutGuide).offset(16)
        }
        stackView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(16)
            make.centerX.equalTo(contentView)
            make.height.equalTo(30)
        }
        
        for _ in 0..<6 {
            let button = UIButton()
            button.backgroundColor = .lightGray
            button.setTitleColor(.white, for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
            button.layer.cornerRadius = 15
            stackView.addArrangedSubview(button)
            buttons.append(button)
        }
    }
    
    func configure(with numberSet: Number) {
        titleLabel.text = numberSet.title.isEmpty ? viewModel.repository.findNextDefaultTitle() : numberSet.title


        let numbers = [numberSet.number1, numberSet.number2, numberSet.number3, numberSet.number4, numberSet.number5, numberSet.number6]
        for (index, num) in numbers.enumerated() {
            if index < buttons.count {
                let button = buttons[index]
                button.setTitle("\(num)", for: .normal)
                button.backgroundColor = color(for: num)
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
