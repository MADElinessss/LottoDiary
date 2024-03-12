//
//  MyLottoTableViewCell.swift
//  LottoDiary
//
//  Created by Madeline on 3/7/24.
//

import SnapKit
import UIKit

final class MyLottoTableViewCell: UITableViewCell {
    
    let titleLabel = UILabel()
    let dateLabel = UILabel()
    let stackView = UIStackView()
    let prizeLabel = UILabel()
    
    let viewModel = MainViewModel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super .init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = .white
        
        configureLayout()
        viewModel.outputLotto.bind { [weak self] lotto in
            self?.configureView(with: lotto)
        }
        viewModel.apiRequest()
        
    }
    
    private func configureLayout() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(dateLabel)
        contentView.addSubview(stackView)
        contentView.addSubview(prizeLabel)
    }
    
    private func configureView(with lotto: Lotto?) {
        guard let draw = lotto else { return }
        
        let drawNumber: Int = draw.drwNo
        titleLabel.text = "\(drawNumber)회 당첨 결과"
        titleLabel.textColor = .black
        titleLabel.font = .systemFont(ofSize: 16, weight: .bold)
        
        let drawDate = FormatterManager.shared.drawDateFormat(date: draw.drwNoDate)
        dateLabel.text = "(\(drawDate))"
        dateLabel.textColor = .gray
        dateLabel.font = .systemFont(ofSize: 14, weight: .semibold)
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(contentView.safeAreaLayoutGuide).inset(16)
            make.centerX.equalTo(contentView)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.centerX.equalTo(contentView)
        }
        
        prizeLabel.snp.makeConstraints { make in
            make.top.equalTo(stackView.snp.bottom).offset(16)
            make.centerX.equalTo(contentView)
        }
        
        
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 10
        
        let drawNumbers = [draw.drwtNo1, draw.drwtNo2, draw.drwtNo3, draw.drwtNo4, draw.drwtNo5, draw.drwtNo6]
        for i in drawNumbers {
            let buttonColor = color(for: i)
            let button = NumberButton(backgroundColor: buttonColor, number: i)
            stackView.addArrangedSubview(button)
        }
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.snp.makeConstraints { make in
            make.top.equalTo(dateLabel.snp.bottom).offset(16)
            make.centerX.equalTo(contentView)
            make.height.equalTo(30)
            make.width.equalTo((30 * drawNumbers.count) + (10 * (drawNumbers.count - 1)))
        }

        let winAmount = FormatterManager.shared.formatWinAmount(draw.firstWinamnt)
        prizeLabel.text = "1등 당첨금: \(winAmount)"
        prizeLabel.textColor = .black
        prizeLabel.font = .systemFont(ofSize: 14, weight: .semibold)
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
            return .black // 기본값으로 검정색 사용
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
