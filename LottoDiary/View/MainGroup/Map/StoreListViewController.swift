//
//  StoreListViewController.swift
//  LottoDiary
//
//  Created by Madeline on 3/19/24.
//

import SnapKit
import UIKit

class StoreListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var documents: [Document] = []
    let tableView = UITableView()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DispatchQueue.main.async {
            self.setDocuments(self.documents)
        }
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        tableView.register(StoreListTableViewCell.self, forCellReuseIdentifier: "StoreListTableViewCell")
        tableView.dataSource = self
        tableView.delegate = self
        self.view.addSubview(tableView)
        
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return documents.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StoreListTableViewCell", for: indexPath) as! StoreListTableViewCell
        let document = documents[indexPath.row]
        //cell.textLabel?.numberOfLines = 0
        //cell.textLabel?.text = "Place: \(document.placeName)\nAddress: \(document.addressName)\nPhone: \(document.phone)"
        cell.indexLabel.text = "\(indexPath.row)"
        cell.indexLabel.textColor = .black
        cell.indexLabel.font = .systemFont(ofSize: 20, weight: .bold)
        
        cell.titleLabel.text = document.placeName
        cell.titleLabel.textColor = .black
        cell.titleLabel.font = .systemFont(ofSize: 16, weight: .medium)
        
        cell.addressLabel.text = document.addressName
        cell.addressLabel.textColor = .black
        cell.addressLabel.font = .systemFont(ofSize: 14, weight: .regular)
        
        cell.phoneLabel.text = document.phone
        cell.phoneLabel.textColor = .darkGray
        cell.phoneLabel.font = .systemFont(ofSize: 14, weight: .light)
        
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UIScreen.main.bounds.height * 0.1
    }

    func setDocuments(_ documents: [Document]) {
        self.documents = documents
        tableView.reloadData()
    }
}
