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
        print("🌽 setDocuments 호출 전 documents: \(documents)")
        setDocuments(documents)
        print("🌽 setDocuments 호출 후 documents: \(documents)")
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let document = documents[indexPath.row]
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.text = "Place: \(document.placeName)\nAddress: \(document.addressName)\nPhone: \(document.phone)"
        cell.textLabel?.textColor = .black
        return cell
    }

    func setDocuments(_ documents: [Document]) {
        self.documents = documents
        tableView.reloadData()
    }
}
