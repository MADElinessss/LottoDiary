//
//  SixRandomNumbersViewController.swift
//  LottoDiary
//
//  Created by Madeline on 3/21/24.
//

import SnapKit
import UIKit

class SixRandomNumbersViewController: BaseViewController {
    
    let numberMakerButton = UIButton()
    let descriptionLabel = UILabel()
    // let saveButton = UIButton()
    var numberButtons: [UIButton] = []
    var rightButton = UIBarButtonItem()
    let colorNames = ["lotteryYellow", "lotteryBlue", "lotteryRed", "lotteryGray", "lotteryGreen"]
    var onNumbersSelected: (([Int]) -> Void)?

    let viewModel = NumberViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        rightButton.isEnabled = false
        let leftButton = createBarButtonItem(imageName: "chevron.left", action: #selector(leftButtonTapped))
        rightButton = UIBarButtonItem(title: "저장", style: .plain, target: self, action: #selector(rightButtonTapped))
        configureNavigationBar(title: "랜덤 로또 번호 추천", leftBarButton: leftButton, rightBarButton: rightButton)
        
    }
    
    @objc func leftButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func rightButtonTapped() {
        let title = viewModel.repository.findNextDefaultTitle()
        viewModel.saveRandomNumbers(title: title)
    }
    
    override func configureHierarchy() {
        view.addSubview(numberMakerButton)
        view.addSubview(descriptionLabel)

        for _ in 0..<6 {
            let button = UIButton()
            button.backgroundColor = .systemBlue
            button.layer.cornerRadius = 25
            button.isHidden = true
            numberButtons.append(button)
            view.addSubview(button)
        }
    }
    
    override func configureLayout() {
        numberMakerButton.snp.makeConstraints { make in
            make.centerX.equalTo(view)
            make.top.equalTo(view.safeAreaLayoutGuide).inset(80)
            make.size.equalTo(44)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.centerX.equalTo(view)
            make.top.equalTo(numberMakerButton.snp.bottom).offset(44)
        }
        
        let buttonSize: CGFloat = 50
        let spacing: CGFloat = 10
        let totalWidth: CGFloat = (buttonSize * 6) + (spacing * 5)
        
        for (index, button) in numberButtons.enumerated() {
            button.snp.makeConstraints { make in
                make.top.equalTo(descriptionLabel.snp.bottom).offset(40)
                make.size.equalTo(buttonSize)
                make.leading.equalTo(view.snp.leading).offset(((view.bounds.width - totalWidth) / 2) + (CGFloat(index) * (buttonSize + spacing)))
            }
        }
    }
    
    override func configureView() {
        numberMakerButton.setTitle("🍀", for: .normal)
        
        numberMakerButton.backgroundColor = .white
        numberMakerButton.layer.cornerRadius = 15
        numberMakerButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        numberMakerButton.layer.cornerRadius = 22
        numberMakerButton.layer.masksToBounds = false
        numberMakerButton.layer.shadowOpacity = 0.5
        numberMakerButton.layer.shadowRadius = 5
        numberMakerButton.layer.shadowOffset = CGSize(width: 0, height: 4)
        numberMakerButton.layer.shadowColor = UIColor.black.cgColor
        
        descriptionLabel.text = "버튼을 눌러 로또 번호를 추천받아요.\n번호는 랜덤으로 생성됩니다."
        descriptionLabel.font = .systemFont(ofSize: 15, weight: .medium)
    }
    
    @objc func buttonTapped() {
        rightButton.isEnabled = true
        let numbers = generateRandomNumbers()
       
        viewModel.randomSelectedNumbers.value = numbers
        for (index, number) in numbers.enumerated() {
            let button = numberButtons[index]
            button.setTitle("\(number)", for: .normal)
            button.isHidden = false
            button.backgroundColor = color(for: number)
            UIView.animate(withDuration: 0.3, delay: Double(index) * 0.2, options: [], animations: {
                button.alpha = 0
                button.alpha = 1
            }, completion: nil)
        }
    }
    
    func generateRandomNumbers() -> [Int] {
        var numbers: Set<Int> = []
        while numbers.count < 6 {
            numbers.insert(Int.random(in: 1...45))
        }
        return numbers.sorted()
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
