//
//  ScrollViewPagingBootcamp.swift
//  SwiftfulThinkingContinuedLearning
//
//  Created by Kritchanat on 2/6/2567 BE.
//

// MARK: ScrollViewPaging
// การทำให้การเลื่อน ScrollView เป็นแบบหน้าเล่ม ๆ หรือ "paging" โดยอัตโนมัติ
// โดยมันจะช่วยให้ ScrollView สามารถเลื่อนไปทีละหน้าเล่มหรือ "pages" ได้ตามขนาดของ ScrollView นั้น ๆ และแสดงเนื้อหาของแต่ละหน้าเล่มอย่างเต็มที่ในแหล่งข้อมูลของ ScrollView นั้น ๆ โดยไม่ต้องมีการตั้งค่าเพิ่มเติมสำหรับ paging

import SwiftUI

struct ScrollViewPagingBootcamp: View {
    
    @State private var scrollPosition: Int? = nil
    
    var body: some View {
        VStack {
            Button("SCROLL TO") {
                scrollPosition = (0..<20).randomElement()!
            }
            
            ScrollView(.horizontal) {
                HStack(spacing: 0) {
                    ForEach(0..<20) { index in
                        Rectangle()
                            .frame(width: 300, height: 300)
                            .cornerRadius(10)
                            .overlay(
                                Text("\(index)").foregroundColor(.white)
                            )
                            .frame(maxWidth: .infinity)
                            .padding(10)
                            .id(index)
                            .scrollTransition(.interactive.threshold(.visible(0.9))) { content, phase in
                                content
                                    .opacity(phase.isIdentity ? 1 : 0)
                                    .offset(y: phase.isIdentity ? 0 : -100)
                            }
//                            .containerRelativeFrame(.horizontal, alignment: .center)
                    }
                }
                .padding(.vertical)
            }
            .ignoresSafeArea()
            .scrollTargetLayout()
            .scrollTargetBehavior(.viewAligned)
            .scrollBounceBehavior(.basedOnSize)
            .scrollPosition(id: $scrollPosition, anchor: .center)
            .animation(.smooth, value: scrollPosition)
        }
        
//                ScrollView {
//                    VStack(spacing: 0) {
//                        ForEach(0..<20) { index in
//                            Rectangle()
//        //                        .frame(width: 300, height: 300)
//                                .overlay(
//                                    Text("\(index)").foregroundColor(.white)
//                                )
//                                .frame(maxWidth: .infinity)
//        //                        .padding(.vertical, 10)
//                                .containerRelativeFrame(.vertical, alignment: .center)
//                        }
//                    }
//                }
//                .ignoresSafeArea()
//                .scrollTargetLayout()
//                .scrollTargetBehavior(.paging)
//                .scrollBounceBehavior(.basedOnSize)
        
    }
}

#Preview {
    ScrollViewPagingBootcamp()
}
