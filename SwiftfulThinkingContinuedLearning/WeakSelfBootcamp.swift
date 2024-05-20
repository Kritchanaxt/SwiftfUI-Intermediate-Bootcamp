//
//  WeakSelfBootcamp.swift
//  SwiftfulThinkingContinuedLearning
//
//  Created by Kritchanaxt_. on 26/5/2567 BE.
//

// MARK: weak self
// คือการป้องกัน strong reference cycle หรือ retain cycle ที่อาจเกิดขึ้นเมื่อมีการ capture self ใน closure ซึ่งอาจทำให้เกิดการถือค่า strong reference ที่ไม่ต้องการ และทำให้ไม่สามารถ deallocate memory ของ object นั้นได้ โดยทำให้เกิดการหลุดหน่วยความจำ (memory leak) ได้

// เมื่อใช้ [weak self] ใน closure จะทำให้ self ถูก capture ในรูปแบบ weak reference ซึ่งไม่ทำให้ object ถือค่า strong reference กัน และ object จะถูก deallocate ได้เมื่อไม่มี strong reference ที่ถืออยู่แล้ว


import SwiftUI

struct WeakSelfBootcamp: View {
    
    @AppStorage("count") var count: Int?
    
    init() {
        count = 0
    }
    
    var body: some View {
        NavigationView {
            NavigationLink("Navigate", destination: WeakSelfSecondScreen())
                .navigationTitle("Screen 1")
        }
        .overlay(
            Text("\(count ?? 0)")
                .font(.largeTitle)
                .padding()
                .background(Color.green.cornerRadius(10))
            , alignment: .topTrailing
        )
    }
}

struct WeakSelfSecondScreen: View {
    
    @StateObject var vm = WeakSelfSecondScreenViewModel()
    
    init() {
        UINavigationBar.appearance().largeTitleTextAttributes = [.font: UIFont(name: "Arial", size: 32)!]
    }
    
    var body: some View {
        VStack {
            Text("Second View")
                .font(.largeTitle)
                .foregroundColor(.red)
            
            if let data = vm.data {
                Text(data)
            }
        }
    }
}

class WeakSelfSecondScreenViewModel: ObservableObject {
    
    //  สร้าง property data ของ ViewModel โดยกำหนดให้มีค่าเริ่มต้นเป็น nil และใช้ @Published เพื่อทำให้ SwiftUI สามารถติดตามการเปลี่ยนแปลงของค่านี้และอัปเดต UI ได้
    @Published var data: String? = nil
    
    // การสร้าง initializer ซึ่งทำงานเมื่อ instance ถูกสร้างขึ้นมา โดยในที่นี้มีการประมวลผลเพิ่มค่า count ใน UserDefaults ด้วยคำสั่ง UserDefaults.standard.set(currentCount + 1, forKey: "count")
    init() {
        print("INITIALIZE NOW")
        let currentCount = UserDefaults.standard.integer(forKey: "count")
        UserDefaults.standard.set(currentCount + 1, forKey: "count")
        getData()
    }
    
    // การสร้าง deinitializer ซึ่งทำงานเมื่อ instance ถูก deallocated หรือถูกทำลาย ในที่นี้มีการลดค่า count ใน UserDefaults ด้วยคำสั่ง UserDefaults.standard.set(currentCount - 1, forKey: "count")
    deinit {
        print("DEINITIALIZE NOW")
        let currentCount = UserDefaults.standard.integer(forKey: "count")
        UserDefaults.standard.set(currentCount - 1, forKey: "count")
    }
    
    // ฟังก์ชันที่ใช้ในการดึงข้อมูล โดยจะทำการอัปเดตค่า data ของ ViewModel หลังจากผ่านไปเวลา 500 วินาที ซึ่งมีการใช้ [weak self] เพื่อป้องกัน strong reference cycle (ไม่ให้นับซ้ำ)
    func getData() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 500) { [weak self] in
            self?.data = "NEW DATA!!!!"
        }
        
    }
    
}

struct WeakSelfBootcamp_Previews: PreviewProvider {
    static var previews: some View {
        WeakSelfBootcamp()
    }
}

#Preview {
    WeakSelfBootcamp()
}
