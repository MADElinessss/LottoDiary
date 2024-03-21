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
    private var notificationToken: NotificationToken? // 변화를 관찰하기 위한 NotificationToken을 저장합니다.
    
    init() {
        
        let results = repository.fetchDiary() // fetchDiaryResults()는 Results<Diary>를 반환해야 합니다.
        
        notificationToken = results.observe { [weak self] (changes: RealmCollectionChange) in
            switch changes {
            case .initial, .update:
                self?.fetchDiaries() // 변화가 감지될 때마다 fetchDiaries()를 호출하여 outputDiary를 업데이트합니다.
            case .error(let error):
                print("Realm Error: \(error)")
            }
        }
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
    
    deinit {
        notificationToken?.invalidate() // 더 이상 필요하지 않을 때 NotificationToken을 해제합니다.
    }
    
//    func fetchDiaries() {
//        let diaries = repository.fetchDiary() // fetchDiary()는 [Diary]를 반환합니다.
//        self.outputDiary.value = diaries
//    }
    func fetchDiaries() {
        let diariesResults = repository.fetchDiary() // Results<Diary> 타입을 반환
        let diariesArray = Array(diariesResults) // Results<Diary>를 [Diary]로 변환
        self.outputDiary.value = diariesArray // 변환된 배열을 outputDiary에 할당
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
    
}
