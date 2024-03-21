//
//  Diary.swift
//  LottoDiary
//
//  Created by Madeline on 3/11/24.
//

import Foundation
import RealmSwift

class Diary: Object {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var content: String
    @Persisted var tag: String?
    @Persisted var imageName: String?
    @Persisted var colorString: String?
    @Persisted var date: Date
}
