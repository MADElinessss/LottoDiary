//
//  LocalNotificationManager.swift
//  LottoDiary
//
//  Created by Madeline on 3/24/24.
//

import Foundation
import UserNotifications

class LocalNotificationManager {
    static let shared = LocalNotificationManager()
    
    func requestAuthorization() {
        let options: UNAuthorizationOptions = [.alert, .sound, .badge]
        UNUserNotificationCenter.current().requestAuthorization(options: options) { granted, error in
            if let error = error {
                print("Request Authorization Failed (\(error), \(error.localizedDescription))")
            } else {
                self.removeAllPendingNotifications {
                    self.scheduleWeeklySaturdayNotification()
                    self.scheduleWeeklyMondayNotification()
                }
            }
        }
    }
    
    // 기존 알림들을 모두 제거하는 메서드 추가
    private func removeAllPendingNotifications(completion: @escaping () -> Void) {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        // 제거가 완료된 후 새로운 알림을 스케줄링하기 위해 약간의 지연을 줌
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            completion()
        }
    }
    
    func scheduleWeeklySaturdayNotification() {
        let content = UNMutableNotificationContent()
        content.title = "🎊 로또 결과 발표 🎊"
        content.body = "이번 주 로또결과를 확인하세요!"
        content.sound = .default

        var dateComponents = DateComponents()
        dateComponents.weekday = 7
        dateComponents.hour = 21
        dateComponents.minute = 0
        dateComponents.timeZone = TimeZone(identifier: "Asia/Seoul")
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        
        let request = UNNotificationRequest(identifier: "weeklyLotteryResult", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error adding notification: \(error)")
            }
        }
    }
    
    func scheduleWeeklyMondayNotification() {
        let content = UNMutableNotificationContent()
        content.title = "🍀 당신의 일주일을 로또일기가 응원합니다 🍀"
        content.body = "오늘도 월요팅!하세요:)"
        content.sound = .default

        var dateComponents = DateComponents()
        dateComponents.weekday = 2
        dateComponents.hour = 9
        dateComponents.minute = 0
        dateComponents.timeZone = TimeZone(identifier: "Asia/Seoul")

        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)

        let request = UNNotificationRequest(identifier: "weeklyMondayReminder", content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error adding notification: \(error)")
            }
        }
    }
}
