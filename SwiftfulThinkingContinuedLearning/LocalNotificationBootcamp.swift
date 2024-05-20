//
//  LocalNotificationBootcamp.swift
//  SwiftfulThinkingContinuedLearning
//
//  Created by Kritchanaxt_. on 23/5/2567 BE.
//

// MARK: LocalNotification
// การสร้างการแจ้งเตือนภายในแอป iOS สามารถทำได้โดยใช้ UNUserNotificationCenter ซึ่งเป็นคลาสที่ใช้สำหรับการจัดการกับการแจ้งเตือนภายในแอปของคุณ

import SwiftUI
import UserNotifications
import CoreLocation

class NotificationManager {
    
    static let instance = NotificationManager() // Singleton
    
    // requestAuthorization() เป็นเมธอดที่ใช้เรียกใช้ UNUserNotificationCenter เพื่อร้องขอการอนุญาตในการแสดงการแจ้งเตือน และรับผลลัพธ์ผ่าน closure  โดยการเรียกใช้เมธอดนี้สามารถเรียกได้จากทุกที่ในแอปและจะเป็นการสร้างแค่หนึ่งครั้งต่อการรันของแอป (เนื่องจากเป็น Singleton)
    func requestAuthorization() {
        let options: UNAuthorizationOptions = [.alert, .sound, .badge]
        UNUserNotificationCenter.current().requestAuthorization(options: options) { (success, error) in
            if let error = error {
                print("ERROR: \(error)")
            } else {
                print("SUCCESS")
            }
        }
    }
    
    func scheduleNotification() {
        
        
        let content = UNMutableNotificationContent()
        content.title = "This is my first notification!"
        content.subtitle = "This was sooooo easy!"
        content.sound = .default
        content.badge = 1 // แสดง badge ที่ไอคอนแอป
        // NSNumber(value: UIApplication.shared.applicationIconBadgeNumber + 1)
                
        // MARK: time
        // ตั้งเวลาแจ้งเตือนให้แสดงหลังจาก 5 วินาที
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5.0, repeats: false)

        // MARK: calendar
        // ตั้งเวลาแจ้งเตือนให้แสดงในวันจันทร์เวลา 8 โมงเช้าทุกสัปดาห์
//        var dateComponents = DateComponents()
//        dateComponents.hour = 8
//        dateComponents.minute = 0
//        dateComponents.weekday = 2
//        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        
        // MARK: location
        // ตั้งเวลาแจ้งเตือนเมื่อผู้ใช้เข้าหรือออกจากพื้นที่ที่กำหนด
//        let coordinates = CLLocationCoordinate2D(
//            latitude: 40.00,
//            longitude: 50.00)
//        let region = CLCircularRegion(
//            center: coordinates,
//            radius: 100,
//            identifier: UUID().uuidString)
//        region.notifyOnEntry = true
//        region.notifyOnExit = true
//        let trigger = UNLocationNotificationTrigger(region: region, repeats: true)
  
        // สร้าง request ของการแจ้งเตือน
        let request = UNNotificationRequest(
            identifier: UUID().uuidString,
            content: content,
            trigger: trigger)
        UNUserNotificationCenter.current().add(request)

    }
    
    func cancelNotification() {
        // ยกเลิกการแจ้งเตือนทั้งหมดที่กำลังรอเป็นอยู่
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        
        // ยกเลิกการแจ้งเตือนทั้งหมดที่ถูกส่งให้ผู้ใช้แล้ว
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
    }
    
}

struct LocalNotificationBootcamp: View {
    var body: some View {
        VStack(spacing: 40) {
            Button("Request permission") {
                NotificationManager.instance.requestAuthorization()
            }
            Button("Schedule notification") {
                NotificationManager.instance.scheduleNotification()
            }
            Button("Cancel notification") {
                NotificationManager.instance.cancelNotification()
            }
        }
        .onAppear {
            UIApplication.shared.applicationIconBadgeNumber = 0
        }
    }
}

#Preview {
    LocalNotificationBootcamp()
}


