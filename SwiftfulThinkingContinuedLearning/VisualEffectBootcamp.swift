//
//  VisualEffectBootcamp.swift
//  SwiftfulThinkingContinuedLearning
//
//  Created by Kritchanat on 2/6/2567 BE.
//

// MARK: VisualEffect
// เป็น modifier ที่ใช้สำหรับเพิ่มเอฟเฟกต์ทางการมองเห็น (visual effect) ลงไปบนวิว (view) ซึ่งมักจะใช้เพื่อสร้างเอฟเฟกต์ที่สวยงามหรือเพิ่มความเข้ากันได้กับพื้นหลังหรือเนื้อหาอื่น ๆ ในแอปพลิเคชันของคุณ

import SwiftUI

// attribute ที่ใช้ใน Swift สำหรับการกำหนดว่าบริบทนั้น ๆ โค้ดที่ตามหลัง attribute นั้นจะทำงานเฉพาะในรุ่น iOS ที่ระบุไว้หรือเวอร์ชันที่ใหม่กว่าที่กำหนดในแอนโนเทชันนี้
@available(iOS 17, *)
struct VisualEffectBootcamp: View {
    
//     @State private var showSpacer: Bool = false
    
    var body: some View {
        
        ScrollView {
            VStack(spacing: 30) {
                ForEach(0..<100) { index in
                    Rectangle()
                        .frame(width: 300, height: 200)
                        .frame(maxWidth: .infinity)
                        .background(Color.orange)
                    
                        //ให้เอฟเฟกต์ของการเคลื่อนไหวของเนื้อหา จะเกิดขึ้นเมื่อผู้ใช้เลื่อนหน้าจอขึ้นหรือลง ให้ลักษณะที่ดูน้อยลงในตัวองค์ประกอบนั้นๆ ทำให้เนื้อหาเคลื่อนไหวด้วยความนุ่มนวล
                        .visualEffect { content, geometry in
                            content
                                .offset(x: geometry.frame(in: .global).minY * 0.5)
                        }
                }
            }
        }
        
//        VStack {
//            Text("Hello world asdjf ;lkasjdf l;aksdjf l;askdfj asl;dkfj a;sldf !")
//                .padding()
//                .background(Color.red)
//                .visualEffect { content, geometry in
//                    content
//                        .grayscale(geometry.frame(in: .global).minY < 300 ? 1 : 0)
//                        .grayscale(geometry.size.width >= 200 ? 1 : 0)
//                }
//            
//            if showSpacer {
//                Spacer()
//            }
//        }
//        .animation(.easeIn, value: showSpacer)
//        .onTapGesture {
//            showSpacer.toggle()
//        }
        
    }
}

#Preview {
    VisualEffectBootcamp()
}
