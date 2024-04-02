//
//  MyNumberViewController.swift
//  LottoDiary
//
//  Created by Madeline on 3/12/24.
//

import SnapKit
import UIKit
import RealmSwift

// MARK: 로또 편집 뷰로 옮겨야됨
final class EditMyNumberViewController: BaseViewController {
    
    private let tableView = UITableView()
    private let memoTextField = UITextField()
    var number: Number?
    let viewModel = NumberViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        setupView()
        if let number = number {
            memoTextField.text = number.title // 타이틀 설정
            updateSelectedNumbers([number.number1, number.number2, number.number3, number.number4, number.number5, number.number6])
        }
        if let number = number {
            let selectedNumbers = [number.number1, number.number2, number.number3, number.number4, number.number5, number.number6]
            
            if let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? EditMyNumberTableViewCell {
                cell.setSelectedNumbers(selectedNumbers)
            }
        }
    }
    
    func updateSelectedNumbers(_ numbers: [Int]) {
        if let numberCell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? EditMyNumberTableViewCell {
            numberCell.setSelectedNumbers(numbers)
        }
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
        
        let rightButton = UIBarButtonItem(title: "저장", style: .done, target: self, action: #selector(rightButtonTapped))
        configureNavigationBar(title: "나의 번호 편집", rightBarButton: rightButton)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
        
        guard let number = number else { return }
    }
    
    @objc func rightButtonTapped() {
        guard let realm = try? Realm(), let number = self.number else { return }

        if let numberCell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? EditMyNumberTableViewCell {
            let selectedNumbers = numberCell.getSelectedNumbers()

            guard selectedNumbers.count == 6 else {
                showAlert(message: "선택된 숫자가 6개가 아닙니다.")
                return
            }

            do {
                try realm.write {
                    // 사용자가 입력한 타이틀을 가져옵니다. 입력하지 않았다면 기본 타이틀을 사용합니다.
                    number.title = memoTextField.text?.isEmpty ?? true ? viewModel.repository.findNextDefaultTitle() : memoTextField.text ?? "나의 번호"
                    
                    // 선택된 숫자들로 Number 객체를 업데이트합니다.
                    number.number1 = selectedNumbers[0]
                    number.number2 = selectedNumbers[1]
                    number.number3 = selectedNumbers[2]
                    number.number4 = selectedNumbers[3]
                    number.number5 = selectedNumbers[4]
                    number.number6 = selectedNumbers[5]

                    // 이 곳에서는 이미 realm.write 블록 내부이므로,
                    // 별도의 업데이트 함수를 호출할 필요 없이 직접 속성을 변경합니다.
                }
            } catch let error as NSError {
                // 에러 처리
                print("Error updating number: \(error.localizedDescription)")
            }

            // 현재 뷰 컨트롤러를 닫습니다.
            navigationController?.popViewController(animated: true)
        }
    }


    func showAlert(message: String) {
        let alert = UIAlertController(title: "경고", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default))
        present(alert, animated: true)
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
            if let number = self.number {
                let selectedNumbers = [number.number1, number.number2, number.number3, number.number4, number.number5, number.number6]
                cell.setSelectedNumbers(selectedNumbers)
            }
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
