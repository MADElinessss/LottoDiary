//
//  Number.swift
//  LottoDiary
//
//  Created by Madeline on 3/23/24.
//

import Foundation
import RealmSwift

class Number: Object {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var title: String = ""
    @Persisted var number1: Int
    @Persisted var number2: Int
    @Persisted var number3: Int
    @Persisted var number4: Int
    @Persisted var number5: Int
    @Persisted var number6: Int
}
