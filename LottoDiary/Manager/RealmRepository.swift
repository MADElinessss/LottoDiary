//
//  RealmRepository.swift
//  LottoDiary
//
//  Created by Madeline on 3/11/24.
//

import Foundation
import RealmSwift

class RealmRepository {
    private let realm = try! Realm()
    
    // MARK: READ
    func fetchDiary() -> [Diary] {
        let result = realm.objects(Diary.self)
        return Array(result)
    }

    // MARK: CREATE
    func create(diary: Diary) {
        do {
            try realm.write {
                realm.add(diary)
                print("Diary added to Realm 🥟")
            }
        } catch {
            print("🥟Error", error)
        }
    }
    
    // MARK: DELETE
    func delete(diaryId: ObjectId) {
        guard let diaryToDelete = realm.objects(Diary.self).filter("id == %@", diaryId).first else {
            return
        }

        do {
            try realm.write {
                realm.delete(diaryToDelete)
                print("🗑️ 삭제")
            }
        } catch {
            print("🗑️ 삭제에러: \(error)")
        }
    }
}
