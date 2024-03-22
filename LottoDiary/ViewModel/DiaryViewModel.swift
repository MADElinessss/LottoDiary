//
//  DiaryViewModel.swift
//  LottoDiary
//
//  Created by Madeline on 3/11/24.
//

import Foundation
import UIKit
import RealmSwift

class DiaryViewModel {
    
    let repository = RealmRepository()
    
    var diaryContent: Observable<String?> = Observable(nil)
    var selectedImage: Observable<UIImage?> = Observable(nil)
    
    var inputViewWillAppearTrigger: Observable<Void?> = Observable(nil)
    var inputTagSavedTapped: Observable<Void?> = Observable(nil)
    var saveButtonTapped: Observable<Void?> = Observable(nil)
    
    var outputDiary: Observable<[Diary]> = Observable([])
    
    init() {
        inputViewWillAppearTrigger.bind { [weak self] _ in
            self?.fetchDiaries()
        }
        
        saveButtonTapped.bind { [weak self] _ in
            guard let self = self, let content = self.diaryContent.value else { return }
            if let image = self.selectedImage.value {
                self.saveImageToDocumentDirectory(image: image) { [weak self] imageName in
                    guard let imageName = imageName else { return }
                    let newDiary = Diary()
                    newDiary.content = content
                    newDiary.imageName = imageName
                    newDiary.date = Date()
                    self?.repository.create(diary: newDiary)
                }
            }
        }
    }

    func fetchDiaries() {
        let diariesResults = repository.fetchDiary()
        self.outputDiary.value = diariesResults
    }

    private func saveImageToDocumentDirectory(image: UIImage, completion: @escaping (String?) -> Void) {
        DispatchQueue.global(qos: .background).async {
            guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
                completion(nil)
                return
            }
            
            let fileName = UUID().uuidString + ".jpg"
            let fileURL = documentDirectory.appendingPathComponent(fileName)
            
            guard let imageData = image.jpegData(compressionQuality: 1.0) else {
                completion(nil)
                return
            }
            
            do {
                try imageData.write(to: fileURL)
                DispatchQueue.main.async {
                    completion(fileName)
                }
            } catch {
                print("Error saving image: \(error)")
                DispatchQueue.main.async {
                    completion(nil)
                }
            }
        }
    }
    
    func loadImageFromDocumentDirectory(fileName: String) -> UIImage? {
        let fileURL = self.getDocumentDirectory().appendingPathComponent(fileName)
        do {
            let imageData = try Data(contentsOf: fileURL)
            return UIImage(data: imageData)
        } catch {
            return nil
        }
    }
    
    private func getDocumentDirectory() -> URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
    
    func saveDiaryEntry(_ diaryEntry: Diary) {
        repository.create(diary: diaryEntry)
    }
    
    func updateDiary(diary: Diary) {
        repository.updateItem(value: diary)
    }
}
