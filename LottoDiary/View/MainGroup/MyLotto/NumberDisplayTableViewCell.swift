//
//  NumberDisplayTableViewCell.swift
//  LottoDiary
//
//  Created by Madeline on 3/30/24.
//

import SnapKit
import UIKit

class NumberDisplayTableViewCell: UITableViewCell {
    
    private var numberButtons: [UIButton] = []
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        backgroundColor = UIColor(named: "background")
        configureNumberButtons()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureNumberButtons() {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 10
        addSubview(stackView)
        
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(10)
        }
        
        for _ in 0..<6 {
            let button = UIButton()
            button.backgroundColor = .gray
            button.snp.makeConstraints { make in
                make.width.height.equalTo(40)
            }
            button.layer.cornerRadius = 20
            button.titleLabel?.font = .pretendard(size: 16, weight: .bold)
            stackView.addArrangedSubview(button)
            numberButtons.append(button)
        }
    }
    
    func configure(with numbers: [Int], highlightedNumbers: Set<Int>) {
        let sortedNumbers = numbers.sorted()
        for (index, button) in numberButtons.enumerated() {
            guard index < sortedNumbers.count else { return }
            let number = sortedNumbers[index]
            button.setTitle("\(number)", for: .normal)
            
            let color = highlightedNumbers.contains(number) ? color(for: number) : .gray
            button.backgroundColor = color
            button.setTitleColor(.white, for: .normal)
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
