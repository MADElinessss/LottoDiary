//
//  ListMyNumberViewController.swift
//  LottoDiary
//
//  Created by Madeline on 3/20/24.
//

import UIKit
import RealmSwift

// MARK: 나의 번호 목록
class ListMyNumberViewController: BaseViewController {
    
    let tableView = UITableView()
    // var numbers: [Number] = []
    let viewModel = NumberViewModel()

    // MARK: Notification Token
    let realm = try! Realm()
    let results = try! Realm().objects(Number.self)
    var token: NotificationToken?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchNumbers()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.token = results.observe { change in
            switch change {
            case .initial(_):
                self.tableView.reloadData()
            case .update(_, _, let insertions, _):
                // Query results have changed, so apply them to the TableView
                self.tableView.beginUpdates()
                
                self.tableView.insertSections(IndexSet(insertions), with: .automatic)
                self.tableView.endUpdates()
           
            case .error(_):
                print("👀error")
            }
        }
    }
    
    func fetchNumbers() {
        viewModel.outputReloadList.bind { _ in
            self.tableView.reloadData()
        }
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
   
        let rightButton = createBarButtonItem(imageName: "plus", action: #selector(rightButtonTapped))
        configureNavigationBar(title: "나의 번호 목록", rightBarButton: rightButton)
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
        return results.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListMyNumberTableViewCell", for: indexPath) as! ListMyNumberTableViewCell
        let object = results[indexPath.section]
        cell.configure(with: object)
        cell.selectionStyle = .none
        cell.layer.cornerRadius = 15
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = EditMyNumberViewController()
        let object = results[indexPath.section]
        vc.number = object
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

extension ListMyNumberViewController {
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let object = results[indexPath.section]
            
            viewModel.repository.deleteNumber(numberId: object.id)
            
            // numbers.remove(at: indexPath.section)
            tableView.deleteSections(IndexSet(integer: indexPath.section), with: .automatic)
        }
    }
}
