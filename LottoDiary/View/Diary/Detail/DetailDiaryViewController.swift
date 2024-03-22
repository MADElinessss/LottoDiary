//
//  DetailDiaryViewController.swift
//  LottoDiary
//
//  Created by Madeline on 3/18/24.
//

import PhotosUI
import SnapKit
import RealmSwift
import UIKit

final class DetailDiaryViewController: BaseViewController {
    
    let tableView = UITableView()
    let viewModel = DiaryViewModel()
    
    var diary: Diary? {
        didSet {
            tableView.reloadData()
        }
    }
    
    var selectedTag: String? {
        didSet {
            tableView.reloadData()
        }
    }
    
    var selectedColorName: String?
    
    var imageName: String? {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.selectedImage.bind { [weak self] _ in
            self?.tableView.reloadData()
        }
        
        viewModel.fetchDiaries()
        
        tableView.reloadData()
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
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "DeleteLottoTableViewCell")
        
        let leftButton = createBarButtonItem(imageName: "chevron.left", action: #selector(leftButtonTapped))
        let rightButton = UIBarButtonItem(title: "저장", style: .plain, target: self, action: #selector(rightButtonTapped))
        rightButton.tintColor = .pointSymbol
        
        configureNavigationBar(title: "로또 일기 편집", leftBarButton: leftButton, rightBarButton: rightButton)
        
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
    
    // MARK: Update
    @objc func rightButtonTapped() {
        guard let content = diary?.content else {
            return
        }
        
        let newDiaryEntry = Diary()
        newDiaryEntry.content = content
        
        // MARK: 이미지 있을 때
        if let imageName = viewModel.selectedImage.value {
            let image = saveImageToDocumentDirectory(image: imageName) ?? ""
            print("🐲 이미지 들어옴")
            newDiaryEntry.imageName = image
        }

        newDiaryEntry.date = diary?.date ?? Date()
        
        if let tag = selectedTag {
            print("🐲tag", tag)
            newDiaryEntry.tag = tag
        }
        if let colorName = selectedColorName {
            print("🐲color", colorName)
            newDiaryEntry.colorString = colorName
        }
        
        viewModel.updateDiary(diary: newDiaryEntry)
        self.viewModel.repository.delete(diaryId: diary?.id ?? ObjectId())
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
                return fileName
            } catch {
                print("Error saving image: \(error)")
                return nil
            }
        }
        return nil
    }
}

extension DetailDiaryViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        dismiss(animated: true)
        guard let result = results.first else { return }
        
        result.itemProvider.loadObject(ofClass: UIImage.self) { [weak self] (image, error) in
            DispatchQueue.main.async {
                if let image = image as? UIImage {
                    self?.viewModel.selectedImage.value = image
                    self?.imageName = self?.saveImageToDocumentDirectory(image: image)
                }
            }
        }
    }
}

extension DetailDiaryViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "AddContentTableViewCell", for: indexPath) as! AddContentTableViewCell
            
            cell.textView.text = diary?.content ?? ""
            
            if let content = diary?.content {
                cell.textView.textColor = .black
                let count = cell.textView.text.count
                cell.remainCountLabel.text = "\(count)/500"
            } else {
                cell.textView.textColor = .lightGray
            }

            cell.onTextChanged = { [weak self] text in
                self?.viewModel.diaryContent.value = text
            }
            cell.clipsToBounds = true
            cell.layer.cornerRadius = 15
            cell.selectionStyle = .none
            return cell
        } else if indexPath.section == 1 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "AddImageTableViewCell", for: indexPath) as? AddImageTableViewCell else {
                fatalError("Unable to dequeue AddImageTableViewCell")
            }
            
            let title = "이미지"
            if let image = viewModel.selectedImage.value {
                cell.configure(with: image, title: title)
            } else if let imageName = diary?.imageName, !imageName.isEmpty {
                if let image = viewModel.loadImageFromDocumentDirectory(fileName: imageName) {
                    cell.configure(with: image, title: title)
                }
            } else {
                cell.configure(with: nil, title: "이미지 첨부")
            }
            
            cell.clipsToBounds = true
            cell.layer.cornerRadius = 15
            cell.selectionStyle = .none
            return cell
        } else if indexPath.section == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AddLottoTableViewCell", for: indexPath)
            // TODO: 로또 번호가 없다면
            cell.textLabel?.text = "로또 번호 입력"
            cell.textLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
            cell.textLabel?.textColor = .lightGray
            // TODO: 로또 번호가 있다면
            cell.textLabel?.text = "구매한 로또 번호"
            cell.textLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
            cell.textLabel?.textColor = .lightGray
            
            cell.clipsToBounds = true
            cell.layer.cornerRadius = 15
            cell.selectionStyle = .none
            return cell
        } else if indexPath.section == 3 {
            
            let cell = UITableViewCell(style: .value1, reuseIdentifier: "TagCell")
            
            cell.textLabel?.text = "소원 태그"
            cell.textLabel?.textColor = .black
            cell.textLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
            
            if let tag = diary?.tag, let colorName = diary?.colorString, let color = UIColor(named: colorName) {
                cell.detailTextLabel?.text = "#\(tag)"
                cell.detailTextLabel?.textColor = color
                cell.detailTextLabel?.font = .systemFont(ofSize: 16, weight: .bold)
            } else if let tag = selectedTag, let colorName = selectedColorName, let color = UIColor(named: colorName) {
                cell.detailTextLabel?.text = "#\(tag)"
                cell.detailTextLabel?.textColor = color
                cell.detailTextLabel?.font = .systemFont(ofSize: 16, weight: .bold)
            } else {
                cell.detailTextLabel?.text = "태그 없음"
                cell.detailTextLabel?.textColor = .black
            }
            
            cell.clipsToBounds = true
            cell.layer.cornerRadius = 15
            cell.selectionStyle = .none
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DeleteLottoTableViewCell", for: indexPath)
            
            cell.textLabel?.text = "일기 삭제"
            cell.textLabel?.textColor = .red
            cell.textLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
            cell.clipsToBounds = true
            cell.layer.cornerRadius = 15
            cell.selectionStyle = .none
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 150
        } else if indexPath.section == 1 {
            if let imageName = diary?.imageName, !imageName.isEmpty, viewModel.loadImageFromDocumentDirectory(fileName: imageName) != nil {
                return 270
            } 
            if let image = viewModel.selectedImage.value {
                return 270
            }
            else {
                return 60
            }
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
                print("🐲 didSelectRowAt", tag, colorName)
                self?.tableView.reloadData()
            }
            let navController = UINavigationController(rootViewController: vc)
            navController.modalPresentationStyle = .automatic
            present(navController, animated: true, completion: nil)
        } else if indexPath.section == 4 {
            let alert = UIAlertController(title: "일기 삭제", message: "이 일기를 삭제하시겠습니까?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "삭제", style: .destructive, handler: { [weak self] _ in
                
                if let diaryId = self?.diary?.id {
                        self?.viewModel.repository.delete(diaryId: diaryId)
                        self?.navigationController?.popViewController(animated: true)
                    } else {
                        print("Error: Diary ID is unavailable.")
                    }

            }))
            alert.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
            present(alert, animated: true)
        }
    }
    
}
