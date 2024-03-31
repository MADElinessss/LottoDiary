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
            // button.layer.cornerRadius = 20
            button.backgroundColor = .gray
            button.titleLabel?.font = .pretendard(size: 16, weight: .bold)
            stackView.addArrangedSubview(button)
            numberButtons.append(button)
        }
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        // Auto Layout 후에 버튼의 크기가 확정되므로 여기서 cornerRadius를 설정합니다.
        numberButtons.forEach { button in
            // 버튼의 높이를 기준으로 cornerRadius 설정하여 원형으로 만듭니다.
            button.layer.cornerRadius = button.frame.height / 2
        }
    }
    
    func configure(with numbers: [Int], highlightedNumbers: Set<Int>) {
        let sortedNumbers = numbers.sorted()
        for (index, button) in numberButtons.enumerated() {
            guard index < sortedNumbers.count else { return }
            let number = sortedNumbers[index]
            button.setTitle("\(number)", for: .normal)
            button.backgroundColor = highlightedNumbers.contains(number) ? .green : .gray
            button.setTitleColor(.white, for: .normal)
        }
    }
}
