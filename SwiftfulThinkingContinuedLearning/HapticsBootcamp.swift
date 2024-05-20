//
//  HapticsBootcamp.swift
//  SwiftfulThinkingContinuedLearning
//
//  Created by Kritchanaxt_. on 22/5/2567 BE.
//

// MARK: Haptics
// ใช้เพื่อให้ผู้ใช้รับการตอบสนองทางกายภาพผ่านการสัมผัสในแอปของคุณได้อย่างง่ายดาย มีสองวิธีหลักในการทำ haptics
// 1. ใช้ UIFeedbackGenerator จาก UIKit
// 2. ใช้ modifier onTapGesture เพื่อเล่น haptic โดยตรง


import SwiftUI

class HapticsManager {
    
    static let instance = HapticsManager() // Singleton
    
    func notification(type: UINotificationFeedbackGenerator.FeedbackType) {
        
        // สร้าง UINotificationFeedbackGenerator จากประเภทของ haptic ที่รับมา
        let generator = UINotificationFeedbackGenerator()
        
        // เล่น haptic ตามประเภทที่รับมา
        generator.notificationOccurred(type)
    }
    
    func impact(style: UIImpactFeedbackGenerator.FeedbackStyle) {
        
        // สร้าง UIImpactFeedbackGenerator จากรูปแบบของ haptic ที่รับมา
        let generator = UIImpactFeedbackGenerator(style: style)
        
        // เล่น haptic
        generator.impactOccurred()
    }
}

struct HapticsBootcamp: View {
    var body: some View {
        VStack(spacing: 20) {
            
            Button("success") { HapticsManager.instance.notification(type: .success) }
            Button("warning") { HapticsManager.instance.notification(type: .warning) }
            Button("error") { HapticsManager.instance.notification(type: .error) }
            Divider()
            Button("soft") { HapticsManager.instance.impact(style: .soft) }
            Button("light") { HapticsManager.instance.impact(style: .light) }
            Button("medium") { HapticsManager.instance.impact(style: .medium) }
            Button("rigid") { HapticsManager.instance.impact(style: .rigid) }
            Button("heavy") { HapticsManager.instance.impact(style: .heavy) }
        }
    }
}

#Preview {
    HapticsBootcamp()
}
