//
//  AddWishTagViewController.swift
//  LottoDiary
//
//  Created by Madeline on 3/12/24.
//

import UIKit

final class AddWishTagViewController: BaseViewController {
    
    let headerLabel = UILabel()
    let stackView = UIStackView()
    let headerLabel2 = UILabel()
    let textField = UITextField()
    var selectedColorName: String?
    
    let colorNames = ["lotteryYellow", "lotteryBlue", "lotteryRed", "lotteryGray", "lotteryGreen"]
    
    var onTagAndColorSelected: ((String, String) -> Void)?
    
    let viewModel = DiaryViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func configureHierarchy() {
        view.addSubview(headerLabel)
        view.addSubview(stackView)
        view.addSubview(headerLabel2)
        view.addSubview(textField)
    }
    
    override func configureLayout() {
        headerLabel.snp.makeConstraints { make in
            make.leading.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.top.equalTo(view.safeAreaLayoutGuide).inset(16)
        }
        
        stackView.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(24)
            make.top.equalTo(headerLabel.snp.bottom).offset(16)
            make.height.equalTo(44)
            make.width.equalTo(300)
        }
        
        headerLabel2.snp.makeConstraints { make in
            make.leading.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.top.equalTo(stackView.snp.bottom).offset(16)
        }
        
        textField.snp.makeConstraints { make in
            make.top.equalTo(headerLabel2.snp.bottom).offset(16)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.height.equalTo(44)
        }
    }
    
    override func configureView() {

        let rightBarButton = UIBarButtonItem(title: "저장", style: .done, target: self, action: #selector(rightBarButtonTapped))
        
        configureNavigationBar(title: "소원 태그", rightBarButton: rightBarButton)
        
        headerLabel.text = "색 선택"
        headerLabel.font = .pretendard(size: 16, weight: .regular)
        headerLabel.textColor = .black
        
        stackView.backgroundColor = .background
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 12
        
        for i in 0...4 {
            let buttonColor = color(for: i)
            let button = NumberButton(backgroundColor: buttonColor, number: nil)
            button.tag = i 
            button.snp.makeConstraints { make in
                make.size.equalTo(30)
            }
            button.clipsToBounds = true
            button.layer.cornerRadius = 20
            button.addTarget(self, action: #selector(colorButtonTapped(_:)), for: .touchUpInside)
            stackView.addArrangedSubview(button)
            stackView.addArrangedSubview(button)
        }
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        headerLabel2.text = "소원 태그명"
        headerLabel2.font = .pretendard(size: 16, weight: .regular)
        headerLabel2.textColor = .black
        
        textField.placeholder = "  로또에 당첨된다면? ex) 아파트, 저축"
        textField.borderStyle = .none
        textField.backgroundColor = .white
        textField.layer.cornerRadius = 15
        textField.clipsToBounds = true
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func colorButtonTapped(_ sender: UIButton) {
        selectedColorName = colorNames[sender.tag]
        stackView.arrangedSubviews.forEach { view in
            if let button = view as? UIButton {
                button.layer.borderWidth = (button.tag == sender.tag) ? 2 : 0
                button.layer.borderColor = (button.tag == sender.tag) ? UIColor.point.cgColor : nil
            }
        }
    }
    
    @objc func rightBarButtonTapped() {
        guard let content = textField.text, !content.isEmpty, let selectedColorName = self.selectedColorName else { return }
        onTagAndColorSelected?(content, selectedColorName)
        dismiss(animated: true)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    private func color(for drawNumber: Int) -> UIColor {
        switch drawNumber {
        case 0:
            return UIColor(named: "lotteryYellow") ?? .yellow
        case 1:
            return UIColor(named: "lotteryBlue") ?? .blue
        case 2:
            return UIColor(named: "lotteryRed") ?? .red
        case 3:
            return UIColor(named: "lotteryGray") ?? .gray
        case 4:
            return UIColor(named: "lotteryGreen") ?? .green
        default:
            return .gray // 기본값으로 검정색 사용
        }
    }
}
