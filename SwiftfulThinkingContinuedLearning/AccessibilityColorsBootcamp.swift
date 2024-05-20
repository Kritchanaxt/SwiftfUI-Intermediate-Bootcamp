//
//  AccessibilityColorsBootcamp.swift
//  SwiftfulThinkingContinuedLearning
//
//  Created by Kritchanaxt_. on 1/6/2567 BE.
//

// MARK: AccessibilityColorsBootcamp
// เป็นหน้าจอใช้สำหรับการทดสอบการเข้าถึง (accessibility) และการปรับแต่งสีของอินเทอร์เฟซของแอปพลิเคชัน โดยมีการใช้งาน Environment และฟีเจอร์ Accessibility ต่างๆ

import SwiftUI

struct AccessibilityColorsBootcamp: View {
    
    // เพื่อตรวจสอบว่าผู้ใช้ได้ตั้งค่าการลดความโปร่งใสสำหรับการเข้าถึงหรือไม่
    @Environment(\.accessibilityReduceTransparency) var reduceTransparency
    
    // เพื่อตรวจสอบระดับความคมชัดของสีในโหมดที่เลือก (light/dark mode)
    @Environment(\.colorSchemeContrast) var colorSchemeContrast
    
    // เพื่อตรวจสอบว่าผู้ใช้ต้องการการแยกแยะโดยไม่ใช้สีหรือไม่
    @Environment(\.accessibilityDifferentiateWithoutColor) var differentiateWithoutColor
    
    // เพื่อตรวจสอบว่าผู้ใช้ต้องการการกลับสีหรือไม่
    @Environment(\.accessibilityInvertColors) var invertColors

    var body: some View {
        NavigationStack {
            VStack {
                
                Button("Button 1") {
                    
                }
                .foregroundColor(colorSchemeContrast == .increased ? .white : .primary)
                .buttonStyle(.borderedProminent)
                
                Button("Button 2") {
                    
                }
                .foregroundColor(.primary)
                .buttonStyle(.borderedProminent)
                .tint(.orange)
                
                Button("Button 3") {
                    
                }
                .foregroundColor(.white)
                .foregroundColor(.primary)
                .buttonStyle(.borderedProminent)
                .tint(.green)
                
                Button("Button 4") {
                    
                }
                .foregroundColor(differentiateWithoutColor ? .white : .green)
                .buttonStyle(.borderedProminent)
                .tint(differentiateWithoutColor ? .black : .purple)
            }
            .font(.largeTitle)
//            .navigationTitle("Hi")
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .ignoresSafeArea()
//            .background(reduceTransparency ? Color.black : Color.black.opacity(0.5))
        }
    }
}

#Preview {
    AccessibilityColorsBootcamp()
}
