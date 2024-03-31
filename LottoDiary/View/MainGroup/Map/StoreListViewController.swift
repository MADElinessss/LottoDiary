//
//  StoreListViewController.swift
//  LottoDiary
//
//  Created by Madeline on 3/19/24.
//

import SnapKit
import UIKit

class StoreListViewController: UIViewController {
    
    var documents: [Document] = []
    let tableView = UITableView()
    let viewModel = MapViewModel()
    
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
}

extension StoreListViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return documents.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StoreListTableViewCell", for: indexPath) as! StoreListTableViewCell
        let document = documents[indexPath.row]
        //cell.textLabel?.numberOfLines = 0
        //cell.textLabel?.text = "Place: \(document.placeName)\nAddress: \(document.addressName)\nPhone: \(document.phone)"
        cell.indexLabel.text = "\(indexPath.row + 1)"
        cell.indexLabel.textColor = .black
        cell.indexLabel.font = .systemFont(ofSize: 20, weight: .bold)
        
        cell.titleLabel.text = document.placeName
        cell.titleLabel.textColor = .black
        cell.titleLabel.font = .systemFont(ofSize: 13, weight: .medium)
        
        cell.addressLabel.text = document.addressName
        cell.addressLabel.textColor = .black
        cell.addressLabel.font = .systemFont(ofSize: 12, weight: .regular)
        
        cell.phoneLabel.text = document.phone
        cell.phoneLabel.textColor = .darkGray
        cell.phoneLabel.font = .systemFont(ofSize: 12, weight: .light)
        
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

//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let document = documents[indexPath.row]
//        
//        if let latitude = Double(document.x), let longitude = Double(document.y) {
//            print("📌 Selected Location: \(latitude), \(longitude)") // 로그 추가
//            viewModel.selectedLocation.value = (latitude: latitude, longitude: longitude)
//            
//            // 뷰모델을 이미 가지고 있는 MapViewController로 이동
//            let mapViewController = StoreMapViewController()
//            mapViewController.viewModel = self.viewModel
//            navigationController?.pushViewController(mapViewController, animated: true)
//        }
//    }
    
    // StoreListViewController.swift
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let document = documents[indexPath.row]
        
        if let latitude = Double(document.y), let longitude = Double(document.x) {
            viewModel.selectedLocation.value = (latitude: latitude, longitude: longitude)
            
            // 현재 뷰모델을 사용하여 StoreMapViewController 생성
            if let mapViewController = navigationController?.viewControllers.first(where: { $0 is StoreMapViewController }) as? StoreMapViewController {
                mapViewController.viewModel = viewModel // 이미 있는 ViewModel 사용
                navigationController?.popToViewController(mapViewController, animated: true)
            } else {
                let mapViewController = StoreMapViewController()
                mapViewController.viewModel = viewModel
                navigationController?.pushViewController(mapViewController, animated: true)
            }
        }
    }

}



