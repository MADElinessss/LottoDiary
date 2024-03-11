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
            print("❣️2")
            guard let self = self, let content = self.diaryContent.value else { 
                print("❣️2-1")
                return }
            print("❣️2-2")
            if let image = self.selectedImage.value {
                self.saveImageToDocumentDirectory(image: image) { [weak self] imageName in
                    print("❣️2-3")
                    guard let imageName = imageName else { return }
                    print("❣️2-4")
                    let newDiary = Diary()
                    newDiary.content = content
                    newDiary.imageName = imageName
                    newDiary.date = Date()
                    print("❣️2-5")
                    self?.repository.create(diary: newDiary)
                    print("❣️2-6")
                }
            }
        }
    }
    
    func fetchDiaries() {
        print("👿fetch")
        let diaries = repository.fetchDiary()
        self.outputDiary.value = diaries
    }
    
    private func saveImageToDocumentDirectory(image: UIImage, completion: @escaping (String?) -> Void) {
        print("👿save")
        DispatchQueue.global(qos: .background).async {
            guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
                completion(nil)
                print("✏️가드에 걸림")
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
            print("Error loading image : \(error)")
            return nil
        }
    }

    private func getDocumentDirectory() -> URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }

}
