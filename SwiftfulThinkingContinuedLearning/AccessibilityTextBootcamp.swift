//
//  AccessibilityTextBootcamp.swift
//  SwiftfulThinkingContinuedLearning
//
//  Created by Kritchanaxt_. on 1/6/2567 BE.
//

// MARK: Accessibility Text
// มักจะใช้ในการอธิบายเนื้อหาหรือสิ่งที่อยู่ในหน้าจอ เพื่อช่วยให้ผู้ใช้ที่มีความพิการทางสายตาหรือบางความต้องการเข้าถึงพื้นที่ที่ชัดเจนขึ้น

import SwiftUI

// Dynamic Text

struct AccessibilityTextBootcamp: View {
    
    @Environment(\.sizeCategory) var sizeCategory
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(0..<10) { _ in
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Image(systemName: "heart.fill")
//                                .font(.system(size: 20))
                            
                            Text("Welcome to my app")
                                .truncationMode(.tail)
                        }
                        .font(.title)
                        
                        Text("This is some longer text that expands to multiple lines.")
                            .font(.subheadline)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .lineLimit(3)
                            .minimumScaleFactor(sizeCategory.customMinScaleFactor)
                    }
//                    .frame(height: 100)
                    .background(Color.red)
                }
            }
            .listStyle(PlainListStyle())
            .navigationTitle("Hello, world!")
        }
    }
}

// extension สำหรับ ContentSizeCategory เพื่อเพิ่มความสามารถใหม่ในการใช้งานในชนิดข้อมูลนี้
extension ContentSizeCategory {
    
    // กำหนดการประกาศค่าคงที่ customMinScaleFactor ซึ่งเป็นค่าที่ใช้ในการกำหนดตัวปรับขนาดสำหรับแต่ละระดับของ ContentSizeCategory
    var customMinScaleFactor: CGFloat {
        
        // ใช้ self เพื่อเข้าถึงค่าของ ContentSizeCategory ที่กำลังถูกตรวจสอบ
        switch self {
        
        // กำหนดเงื่อนไขสำหรับระดับขนาดเนื้อหา
        case .extraSmall, .small, .medium:
            
            // จะคืนค่าตัวปรับขนาดเท่ากับ 1.0
            return 1.0
            
        // กำหนดเงื่อนไขสำหรับระดับขนาดเนื้อหา
        case .large, .extraLarge, .extraExtraLarge:
            
            // จะคืนค่าตัวปรับขนาดเท่ากับ 0.8
            return 0.8
        default:
            
            //  จะคืนค่าตัวปรับขนาดเท่ากับ 0.85
            return 0.85
        }
    }
}

#Preview {
    AccessibilityTextBootcamp()
}
