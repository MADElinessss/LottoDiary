//
//  Lotto.swift
//  LottoDiary
//
//  Created by Madeline on 3/7/24.
//

import Foundation

struct Lotto: Decodable {
    let totSellamnt: Int
    let returnValue, drwNoDate: String
    let firstWinamnt, firstPrzwnerCo, firstAccumamnt: Int
    let bnusNo, drwNo: Int
    let drwtNo1, drwtNo2, drwtNo3, drwtNo4, drwtNo5, drwtNo6: Int
}
