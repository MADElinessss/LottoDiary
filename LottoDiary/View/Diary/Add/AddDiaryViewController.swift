//
//  AddDiaryViewController.swift
//  LottoDiary
//
//  Created by Madeline on 3/11/24.
//

import PhotosUI
import SnapKit
import UIKit

class AddDiaryViewController: BaseViewController, PHPickerViewControllerDelegate {
    
    
    let tableView = UITableView()
    
    var selectedImage: UIImage? {
            didSet {
                tableView.reloadData()
            }
        }

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func configureHierarchy() {
        view.addSubview(tableView)
    }
    
    override func configureLayout() {
        tableView.snp.makeConstraints { make in
            make.verticalEdges.equalTo(view)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(8)
        }
    }
    
    
    override func configureView() {
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .background
        tableView.separatorStyle = .none
        tableView.register(AddContentTableViewCell.self, forCellReuseIdentifier: "AddContentTableViewCell")
        tableView.register(AddImageTableViewCell.self, forCellReuseIdentifier: "AddImageTableViewCell")
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "AddLottoTableViewCell")
        
        let leftButton = createBarButtonItem(imageName: "chevron.left", action: #selector(leftButtonTapped))
        let rightButton = UIBarButtonItem(title: "저장", style: .plain, target: self, action: #selector(rightButtonTapped))
        rightButton.tintColor = .pointSymbol
        
        configureNavigationBar(title: "일기 작성", leftBarButton: leftButton, rightBarButton: rightButton)
    }
    
    func presentPhotoPicker() {
        var configuration = PHPickerConfiguration()
        configuration.selectionLimit = 1  // 사진은 1개만 선택 가능
        configuration.filter = .images    // 이미지만 선택 가능
        
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        present(picker, animated: true)
    }
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        dismiss(animated: true)
        guard let result = results.first else { return }
        
        result.itemProvider.loadObject(ofClass: UIImage.self) { [weak self] (image, error) in
            DispatchQueue.main.async {
                if let image = image as? UIImage {
                    self?.selectedImage = image
                    // 선택된 이미지를 저장하고 셀의 높이를 조정하는 로직
                }
            }
        }
    }
    
    @objc func leftButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func rightButtonTapped() {
        // TODO: Realm Create
        print("🐢")
    }

}

extension AddDiaryViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AddContentTableViewCell", for: indexPath) as! AddContentTableViewCell
            cell.clipsToBounds = true
            cell.layer.cornerRadius = 15
            return cell
        } else if indexPath.section == 1 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "AddImageTableViewCell", for: indexPath) as? AddImageTableViewCell else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "AddImageTableViewCell", for: indexPath)
                cell.textLabel?.text = "이미지 첨부"
                cell.textLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
                cell.clipsToBounds = true
                cell.layer.cornerRadius = 15
                return cell
            }
            cell.clipsToBounds = true
            cell.layer.cornerRadius = 15
            cell.configure(with: selectedImage, title: "이미지 첨부")
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AddLottoTableViewCell", for: indexPath)
            cell.textLabel?.text = "로또 번호 입력"
            cell.textLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
            cell.clipsToBounds = true
            cell.layer.cornerRadius = 15
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 380
        } else if indexPath.section == 1 {
            return selectedImage == nil ? 60 : 270
        } else {
            return 60
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if section == 1 {
            let headerLabel = UILabel()
            return headerLabel
        } else {
            return nil
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 1 {
            return 4
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            presentPhotoPicker()
        }
    }

}
