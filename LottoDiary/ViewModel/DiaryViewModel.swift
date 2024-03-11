//
//  DiaryViewModel.swift
//  LottoDiary
//
//  Created by Madeline on 3/11/24.
//

import Foundation
import UIKit

class DiaryViewModel {
    
    let repository = RealmRepository()
    
    var diaryContent: Observable<String?> = Observable(nil)
    var selectedImage: Observable<UIImage?> = Observable(nil)
    
    var inputViewWillAppearTrigger: Observable<Void?> = Observable(nil)
    var saveButtonTapped: Observable<Void?> = Observable(nil)
    
    var outputDiary: Observable<[Diary]> = Observable([])
    
    init() {
        inputViewWillAppearTrigger.bind { [weak self] _ in
            self?.fetchDiaries()
        }
        
        saveButtonTapped.bind { [weak self] _ in
            guard let self = self, let image = self.selectedImage.value, let content = self.diaryContent.value else { return }
            
            if let imageName = self.saveImageToDocumentDirectory(image: image) {
                let newDiary = Diary()
                newDiary.content = content
                newDiary.imageName = imageName
                newDiary.date = Date()
                self.repository.create(diary: newDiary)
            }
        }

    }
    
    func fetchDiaries() {
        let diaries = repository.fetchDiary()
        self.outputDiary.value = diaries
    }
    
    func saveDiary(image: UIImage?, content: String) {
        if let image = image, let imageName = saveImageToDocumentDirectory(image: image) {
            let newDiary = Diary()
            newDiary.content = content
            newDiary.imageName = imageName
            newDiary.date = Date()
            repository.create(diary: newDiary)
        }
    }
    
    private func saveImageToDocumentDirectory(image: UIImage) -> String? {
        guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil }
        
        let fileName = UUID().uuidString + ".jpg"
        let fileURL = documentDirectory.appendingPathComponent(fileName)
        
        guard let imageData = image.jpegData(compressionQuality: 1.0) else { return nil }
        
        do {
            try imageData.write(to: fileURL)
            return fileName
        } catch {
            print("Error saving image: \(error)")
            return nil
        }
    }
    
}
