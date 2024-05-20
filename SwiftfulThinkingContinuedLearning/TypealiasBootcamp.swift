//
//  TypealiasBootcamp.swift
//  SwiftfulThinkingContinuedLearning
//
//  Created by Kritchanaxt_. on 26/5/2567 BE.
//

// MARK: Typealias
// เป็นการสร้างชื่อย่อ (alias) สำหรับประเภทข้อมูลหรือชนิดข้อมูลอื่น ๆ ซึ่งชื่อย่อนี้สามารถใช้แทนชนิดข้อมูลนั้นๆ ในการประกาศตัวแปรหรือฟังก์ชันได้ ทำให้โค้ดดูสั้นลง อ่านง่ายขึ้น และเปลี่ยนแปลงชนิดข้อมูลได้ง่ายขึ้นด้วย

import SwiftUI

struct MovieModel {
    let title: String
    let director: String
    let count: Int
}

typealias TVModel = MovieModel

struct TypealiasBootcamp: View {
    
    @State var item: TVModel = TVModel(title: "TV Title", director: "Emmily", count: 10)
    
    var body: some View {
        VStack {
            Text(item.title)
            Text(item.director)
            Text("\(item.count)")
        }
    }
}

#Preview {
    TypealiasBootcamp()
}
