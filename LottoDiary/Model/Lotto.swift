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

/*
 totSellamnt: 누적금액
 returnValue: 실행결과
 drwNoDate: 추첨 일자
 firstWinamnt: 1등 당첨금
 firstPrzwnerCo: 1등 당첨 인원
 bnusNo:보너스 번호
 drwNo: 회차
 drwtNo1~6: 당첨번호 숫자
 */
