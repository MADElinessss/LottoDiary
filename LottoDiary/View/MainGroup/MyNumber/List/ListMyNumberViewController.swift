//
//  ListMyNumberViewController.swift
//  LottoDiary
//
//  Created by Madeline on 3/20/24.
//

import UIKit

// MARK: 나의 번호 목록
class ListMyNumberViewController: BaseViewController {

    let tableView = UITableView()
    var numbers: [Number] = []
    let repository = NumberRealmRepository()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchNumbers()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    func fetchNumbers() {
        numbers = repository.fetchNumber()
        tableView.reloadData()
    }
    
    override func configureHierarchy() {
        view.addSubview(tableView)
    }
    
    override func configureLayout() {
        tableView.snp.makeConstraints { make in
            make.verticalEdges.equalTo(view.safeAreaLayoutGuide)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(16)
        }
    }
    
    override func configureView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .background
        
        tableView.separatorStyle = .none
        tableView.register(ListMyNumberTableViewCell.self, forCellReuseIdentifier: "ListMyNumberTableViewCell")
        
        let leftButton = createBarButtonItem(imageName: "chevron.left", action: #selector(leftButtonTapped))
        let rightButton = createBarButtonItem(imageName: "plus", action: #selector(rightButtonTapped))
        configureNavigationBar(title: "나의 번호 목록", leftBarButton: leftButton, rightBarButton: rightButton)
    }
    
    @objc func leftButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func rightButtonTapped() {
        let vc = AddMyNumberViewController()
        let navController = UINavigationController(rootViewController: vc)
        navController.modalPresentationStyle = .automatic
        present(navController, animated: true, completion: nil)
    }
}

extension ListMyNumberViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 120
    }
    
    // TODO: Realm 번호 목록
    func numberOfSections(in tableView: UITableView) -> Int {
        return numbers.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListMyNumberTableViewCell", for: indexPath) as! ListMyNumberTableViewCell
        let number = numbers[indexPath.section]
        cell.configure(with: number)
        cell.selectionStyle = .none
        cell.layer.cornerRadius = 15
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = EditMyNumberViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        return headerView
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
}
