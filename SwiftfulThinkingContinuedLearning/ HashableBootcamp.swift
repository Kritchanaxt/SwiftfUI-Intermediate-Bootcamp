//
//   HashableBootcamp.swift
//  SwiftfulThinkingContinuedLearning
//
//  Created by Kritchanaxt_. on 23/5/2567 BE.
//

// MARK: Hashable
// ใช้เพื่อให้ประเภทสามารถเปรียบเทียบค่าและสร้างแฮชโค้ดได้ ทำให้สามารถใช้ประเภทเหล่านั้นเป็นคีย์ใน `Dictionary` และเป็นสมาชิกใน `Set` ได้อย่างมีประสิทธิภาพ.

import SwiftUI

struct MyCustomModel: Hashable {
    let title: String
    
    // ฟังก์ชัน hash(into:) ใช้สำหรับสร้างค่าแฮชสำหรับอินสแตนซ์ของชนิดที่กำหนดเอง ซึ่งเป็นส่วนหนึ่งของการทำให้ชนิดข้อมูลเป็น Hashable การสร้างค่าแฮชที่ไม่ซ้ำกันสำคัญสำหรับการใช้งานในโครงสร้างข้อมูลที่ใช้แฮช
    func hash(into hasher: inout Hasher) {
        hasher.combine(title)
    }
}

struct HashableBootcamp: View {
    
    let data: [MyCustomModel] = [
        MyCustomModel(title: "ONE"),
        MyCustomModel(title: "TWO"),
        MyCustomModel(title: "THREE"),
        MyCustomModel(title: "FOUR"),
        MyCustomModel(title: "FIVE"),
    ]
    
    var body: some View {
        ScrollView {
            VStack(spacing: 40) {
                ForEach(data, id: \.self) { item in
                    Text(item.hashValue.description)
                        .font(.headline)
                }
            }
        }
    }
}

#Preview {
    HashableBootcamp()
}
