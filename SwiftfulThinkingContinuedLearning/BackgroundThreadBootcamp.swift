//
//  BackgroundThreadBootcamp.swift
//  SwiftfulThinkingContinuedLearning
//
//  Created by Kritchanaxt_. on 26/5/2567 BE.
//

// MARK: Background thread
// คือ กระบวนการทำงานที่ทำงานพร้อมกันกับ main thread ในแอปพลิเคชัน แต่มันทำงานอยู่ใน context ของ background โดยไม่มีผลต่อการทำงานหลักของแอปพลิเคชัน

// การใช้ background thread มักจะเกิดขึ้นในกรณีที่ต้องการทำงานที่ใช้เวลานานหรือทำงานที่ไม่ควรทำใน main thread เพื่อไม่ให้แอปพลิเคชันหลุดหรือค้างในขณะที่มีการทำงานอื่นๆ ถูกดำเนินการอยู่ในขณะเดียวกัน

// การใช้ background thread สามารถช่วยเพิ่มประสิทธิภาพและป้องกันปัญหาที่เกิดขึ้นจากการบล็อกหรือการเลื่อนข้อมูลในแอปพลิเคชันได้

import SwiftUI

// คลาสนี้ปฏิบัติตามโปรโตคอล ObservableObject เพื่อทำให้สามารถเผยแพร่การเปลี่ยนแปลงของคุณสมบัติไปยัง SwiftUI views ที่ติดตามอยู่
class BackgroundThreadViewModel: ObservableObject {
    
    // คุณสมบัติ dataArray ถูกทำเครื่องหมายด้วย @Published ซึ่งหมายความว่าการเปลี่ยนแปลงของคุณสมบัตินี้จะเรียกใช้การอัพเดตที่ SwiftUI views ที่ติดตามอยู่
    @Published var dataArray: [String] = []
    
    // MARK: fetchData
    //เมธอดนี้รับผิดชอบในการดึงข้อมูล เป็นการเรียกข้อมูลจากเธรดพื้นหลังเพื่อหลีกเลี่ยงการบล็อกเธรดหลักซึ่งเป็นสิ่งสำคัญสำหรับการรักษาอินเทอร์เฟซผู้ใช้ที่ตอบสนองได้
    func fetchData() {
        
        // ใช้เพื่อส่งงานดึงข้อมูลไปยังเธรดพื้นหลังด้วยคุณภาพบริการต่ำ (QoS) นี้จะทำให้ UI ยังคงตอบสนองได้หากการดึงข้อมูลใช้เวลา
        DispatchQueue.global(qos: .background).async {
            let newData = self.downloadData()
            
            // เพื่อตรวจสอบสถานะเธรดปัจจุบัน (Thread.isMainThread และ Thread.current) ก่อนและหลังการอัพเดต UI เพื่อยืนยันว่าการอัพเดต UI มีการดำเนินการบนเธรดหลัก
            print("CHECK 1: \(Thread.isMainThread)")
            print("CHECK 1: \(Thread.current)")
            
            // MARK: Updating UI on the Main Thread:
            // เมื่อข้อมูลดึงมาแล้ว fetchData() ส่งความปิดเป็นกิจกรรมไปยังเธรดหลักด้วย DispatchQueue.main.async ในคลอสนี้
            // เมื่ออยู่ภายในความปิดเป็นกิจกรรมนี้คุณสมบัติ dataArray จะถูกอัพเดตด้วยข้อมูลใหม่ นี่จะทำให้การอัพเดต UI เกิดขึ้นบนเธรดหลักตามที่ต้องการโดย SwiftUI
            DispatchQueue.main.async {
                self.dataArray = newData
                
                // เพื่อตรวจสอบสถานะเธรดปัจจุบัน (Thread.isMainThread และ Thread.current) ก่อนและหลังการอัพเดต UI เพื่อยืนยันว่าการอัพเดต UI มีการดำเนินการบนเธรดหลัก
                print("CHECK 2: \(Thread.isMainThread)")
                print("CHECK 2: \(Thread.current)")
            }
        }
    }
    
    // เมธอดที่เป็นส่วนตัวนี้จำลองกระบวนการดึงข้อมูล มันสร้างอาร์เรย์ของสตริงที่แสดงข้อมูลที่ดาวน์โหลดมา เช่นในตัวอย่างนี้มันสร้างอาร์เรย์ของสตริงตั้งแต่ 0 ถึง 99
    private func downloadData() -> [String] {
        var data: [String] = []
        for x in 0..<100 {
            data.append("\(x)")
            print(data)
        }
        return data
    }
}

struct BackgroundThreadBootcamp: View {
    
    @StateObject var vm = BackgroundThreadViewModel()
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 10) {
                Text("LOAD DATA")
                    .font(.largeTitle)
                    .fontWeight(.semibold)
                    .onTapGesture {
                        vm.fetchData()
                    }
                
                ForEach(vm.dataArray, id: \.self) { item in
                    Text(item)
                        .font(.headline)
                        .foregroundColor(.red)
                }
            }
        }
    }
}

#Preview {
    BackgroundThreadBootcamp()
}
