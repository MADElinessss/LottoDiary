//
//  AddDiaryViewController.swift
//  LottoDiary
//
//  Created by Madeline on 3/11/24.
//

import PhotosUI
import SnapKit
import RealmSwift
import UIKit

final class AddDiaryViewController: BaseViewController {
    
    let tableView = UITableView()
    let viewModel = DiaryViewModel()
    var rightButton = UIBarButtonItem()
    
    var selectedTag: String?
    var selectedColorName: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.selectedImage.bind { [weak self] _ in
            self?.tableView.reloadData()
        }
        
        viewModel.fetchDiaries()
        
        print("## realm file dir -> \(Realm.Configuration.defaultConfiguration.fileURL!)")
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
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
        tableView.register(AddContentTableViewCell.self, forCellReuseIdentifier: "AddContentTableViewCell")
        tableView.register(AddImageTableViewCell.self, forCellReuseIdentifier: "AddImageTableViewCell")
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "AddLottoTableViewCell")
        
        let leftButton = createBarButtonItem(imageName: "chevron.left", action: #selector(leftButtonTapped))
        rightButton = UIBarButtonItem(title: "저장", style: .plain, target: self, action: #selector(rightButtonTapped))
        // rightButton.tintColor = .pointSymbol
        rightButton.tintColor = .lightGray
        rightButton.isEnabled = false
        
        configureNavigationBar(title: "일기 작성", leftBarButton: leftButton, rightBarButton: rightButton)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    func presentPhotoPicker() {
        var configuration = PHPickerConfiguration()
        configuration.selectionLimit = 1
        configuration.filter = .images
        
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        present(picker, animated: true)
    }
    
    @objc func leftButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: 저장 버튼 액션
    @objc func rightButtonTapped() {
        guard let content = viewModel.diaryContent.value else {
            print("필수 항목이 누락되었습니다.")
            return
        }
        
        let newDiaryEntry = Diary()
        newDiaryEntry.content = content
        
        // MARK: 이미지 있을 때
        if let imageName = viewModel.selectedImage.value {
            let image = saveImageToDocumentDirectory(image: imageName) ?? ""
            newDiaryEntry.imageName = image
        }

        newDiaryEntry.date = Date()
        
        if let tag = selectedTag {
            newDiaryEntry.tag = tag
        }
        if let colorName = selectedColorName {
            newDiaryEntry.colorString = colorName
        }
        
        viewModel.saveDiaryEntry(newDiaryEntry)
        
        navigationController?.popViewController(animated: true)
    }

    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    private func saveImageToDocumentDirectory(image: UIImage) -> String? {
        let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        let fileName = UUID().uuidString + ".jpg"
        let fileURL = documentDirectory?.appendingPathComponent(fileName)
        
        if let imageData = image.jpegData(compressionQuality: 1.0), let url = fileURL {
            do {
                try imageData.write(to: url)
                return fileName // 저장된 이미지의 파일 이름 반환
            } catch {
                print("Error saving image: \(error)")
                return nil
            }
        }
        return nil
    }

}

extension AddDiaryViewController: PHPickerViewControllerDelegate {
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        dismiss(animated: true)
        guard let result = results.first else { return }
        
        result.itemProvider.loadObject(ofClass: UIImage.self) { [weak self] (image, error) in
            DispatchQueue.main.async {
                if let image = image as? UIImage {
                    // self?.selectedImage = image
                    self?.viewModel.selectedImage.value = image
                }
            }
        }
    }
    
}
extension AddDiaryViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AddContentTableViewCell", for: indexPath) as! AddContentTableViewCell
            cell.onTextChanged = { [weak self] text in
                self?.viewModel.diaryContent.value = text
                self?.rightButton.tintColor = .point
                self?.rightButton.isEnabled = true
            }
            cell.clipsToBounds = true
            cell.layer.cornerRadius = 15
            cell.selectionStyle = .none
            return cell
        } else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AddImageTableViewCell", for: indexPath) as! AddImageTableViewCell

            if let selectedImage = viewModel.selectedImage.value {
                cell.configure(with: selectedImage, title: "")
            } else {
                cell.configure(with: nil, title: "이미지 첨부")
            }
            
            cell.clipsToBounds = true
            cell.layer.cornerRadius = 15
            cell.selectionStyle = .none
            return cell
        } else if indexPath.section == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AddLottoTableViewCell", for: indexPath)
            cell.textLabel?.text = "로또 번호 입력"
            cell.textLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
            cell.clipsToBounds = true
            cell.layer.cornerRadius = 15
            cell.selectionStyle = .none
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AddLottoTableViewCell", for: indexPath)
            
            if let tag = selectedTag, let colorName = selectedColorName {
                cell.textLabel?.text = "#\(tag)"
                cell.textLabel?.textColor = UIColor(named: colorName) ?? .black
            } else {
                cell.textLabel?.text = "소원 태그"
                cell.textLabel?.textColor = .black
            }
            
            cell.textLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
            cell.clipsToBounds = true
            cell.layer.cornerRadius = 15
            cell.selectionStyle = .none
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 380
        } else if indexPath.section == 1 {
            return viewModel.selectedImage.value == nil ? 60 : 270
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
        } else if indexPath.section == 2 {
            // TODO: 로또 번호 입력 화면으로 전환
        } else if indexPath.section == 3 {
            // TODO: 소원 태그 입력 화면
            let vc = AddWishTagViewController()
            vc.onTagAndColorSelected = { [weak self] tag, colorName in
                self?.selectedTag = tag
                self?.selectedColorName = colorName
                self?.tableView.reloadData()
            }
            let navController = UINavigationController(rootViewController: vc)
            navController.modalPresentationStyle = .automatic
            present(navController, animated: true, completion: nil)
        }
    }

}
