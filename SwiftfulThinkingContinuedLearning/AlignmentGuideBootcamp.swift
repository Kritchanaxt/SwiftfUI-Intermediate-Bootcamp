//
//  AlignmentGuideBootcamp.swift
//  SwiftfulThinkingContinuedLearning
//
//  Created by Kritchanat on 1/6/2567 BE.
//

// MARK: AlignmentChild
// เป็นตัวกำหนดตำแหน่งของ(child) ภายใน Container โดยจะกำหนดโดยใช้การจัดวางของ SwiftUI เช่น .leading, .trailing, .top, .bottom เป็นต้น ซึ่งช่วยให้สามารถควบคุมตำแหน่งได้ตามต้องการในการจัดวาง

import SwiftUI

// https://swiftui-lab.com/alignment-guides/

//struct AlignmentGuideBootcamp: View {
//    var body: some View {
//        VStack(alignment: .leading) {
//            Text("Hello!")
//                .background(Color.blue)
//                .alignmentGuide(.leading) { dimensions in
//                    return dimensions.width * 0.5
//                }
//            
//            Text("This is some other text!")
//                .background(Color.red)
//        }
//        .background(Color.orange)
//    }
//}

// MARK: Example
struct AlignmentChildView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            row(title: "Row 1", showIcon: false)
            row(title: "Row 2", showIcon: true)
            row(title: "Row 3", showIcon: false)
        }
        .padding(16)
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 10)
        .padding(40)
    }
    
    private func row(title: String, showIcon: Bool) -> some View {
        HStack(spacing: 10) {
            if showIcon {
                Image(systemName: "info.circle")
                    .frame(width: 30, height: 30)
            }
            
            Text(title)
            
            Spacer()
        }
        .alignmentGuide(.leading) { dimensions in
            return showIcon ? 40 : 0
        }
    }
}

#Preview {
//    AlignmentGuideBootcamp()
    AlignmentChildView()
}
