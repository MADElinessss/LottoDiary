//
//  MyLottoResultViewController.swift
//  LottoDiary
//
//  Created by Madeline on 3/24/24.
//

import UIKit

class MyLottoResultViewController: BaseViewController {
    
    private let tableView = UITableView()
    private let memoTextField = UITextField()
    let viewModel = NumberViewModel()
    let resultButton = UIButton()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateTitlePlaceholder()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        setupView()
        updateTitlePlaceholder()
    }

    func updateTitlePlaceholder() {
        let nextTitle = viewModel.repository.findNextDefaultTitle()
        memoTextField.placeholder = nextTitle
    }
    
    private func configureTableView() {
        view.addSubview(tableView)
        view.addSubview(resultButton)
        tableView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(100)
        }
        resultButton.snp.makeConstraints { make in
            make.top.equalTo(tableView.snp.bottom)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(24)
            make.centerX.equalTo(view)
            make.height.equalTo(44)
        }
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.register(EditMyNumberTableViewCell.self, forCellReuseIdentifier: "EditMyNumberTableViewCell")
        tableView.separatorStyle = .none
        tableView.tableFooterView = UIView()
        tableView.backgroundColor = .background
        
        resultButton.backgroundColor = .point
        resultButton.layer.cornerRadius = 15
        resultButton.setTitle("결과 확인하기", for: .normal)
        resultButton.titleLabel?.font = .pretendard(size: 18, weight: .bold)
        resultButton.addTarget(self, action: #selector(resultButtonTapped), for: .touchUpInside)
    }
    
    @objc func resultButtonTapped() {
        guard let currentDrawNumber = FormatterManager.shared.findLottoDrawNumber() else {
            print("로또 회차를 계산할 수 없습니다.")
            return
        }
        
        APIManager.shared.lottoCallRequest(drwNumber: currentDrawNumber) { [weak self] result in
            switch result {
            case .success(let lotto):
                DispatchQueue.main.async {
                    // 당첨 번호와 보너스 번호 설정
                    let winningNumbers: Set<Int> = [lotto.drwtNo1, lotto.drwtNo2, lotto.drwtNo3, lotto.drwtNo4, lotto.drwtNo5, lotto.drwtNo6]
                    let bonusNumber = lotto.bnusNo
                    
                    // 사용자가 선택한 번호를 Set<Int>으로 변환
                    let userNumbersSet: Set<Int> = Set(self?.viewModel.selectedNumbers.value ?? [])
                    
                    // 로또 번호 확인 로직
                    let lottoChecker = LottoChecker(winningNumbers: winningNumbers, bonusNumber: bonusNumber)
                    let result = lottoChecker.checkNumbers(userNumbersSet)
                    
                    // 결과를 LottoResultViewController에 전달
                    self?.showLottoResultScreen(lotto: lotto, result: result, userNumbers: userNumbersSet)
                }
            case .failure(let error):
                print("로또 데이터 로드 실패: \(error.localizedDescription)")
            }
        }
    }

    func showLottoResultScreen(lotto: Lotto, result: (rank: String, matchedNumbers: Set<Int>), userNumbers: Set<Int>) {
        let resultVC = LottoResultViewController()
        resultVC.lotto = lotto
        resultVC.winningResult = result
        resultVC.userNumbers = userNumbers
        self.navigationController?.pushViewController(resultVC, animated: true)
    }

    private func setupView() {
        view.backgroundColor = .background
        
        configureNavigationBar(title: "번호 직접 입력", rightBarButton: nil)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension MyLottoResultViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UIScreen.main.bounds.width
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "EditMyNumberTableViewCell", for: indexPath) as! EditMyNumberTableViewCell
        cell.onNumbersSelected = { [weak self] selectedNumbers in
            self?.viewModel.selectedNumbers.value = selectedNumbers
        }
        
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "번호 선택"
    }
}

extension MyLottoResultViewController {
    
    private class LottoChecker {
        // 당첨 번호와 보너스 번호 설정
        let winningNumbers: Set<Int>
        let bonusNumber: Int
        
        init(winningNumbers: Set<Int>, bonusNumber: Int) {
            self.winningNumbers = winningNumbers
            self.bonusNumber = bonusNumber
        }
        
        func checkNumbers(_ numbers: Set<Int>) -> (rank: String, matchedNumbers: Set<Int>) {
            let matchedNumbers = numbers.intersection(winningNumbers)
            let matchedCount = matchedNumbers.count
            
            switch matchedCount {
            case 6:
                return ("1등! 축하합니다 🎉", matchedNumbers)
            case 5:
                if numbers.contains(bonusNumber) {
                    return ("2등! 축하합니다 🎉", matchedNumbers.union([bonusNumber]))
                } else {
                    return ("3등! 축하합니다 🎉", matchedNumbers)
                }
            case 4:
                return ("4등! 축하합니다 🎉", matchedNumbers)
            case 3:
                return ("5등! 축하합니다 🎉", matchedNumbers)
            default:
                return ("당첨되지 않았습니다.", matchedNumbers)
            }
        }
    }
}
