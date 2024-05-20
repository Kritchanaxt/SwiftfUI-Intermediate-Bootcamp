//
//  EscapingBootcamp.swift
//  SwiftfulThinkingContinuedLearning
//
//  Created by Kritchanaxt_. on 26/5/2567 BE.
//

// MARK: Escaping
// เพื่อระบุว่าฟังก์ชันที่ถูกส่งเป็นอาร์กิวเมนต์ให้กับฟังก์ชันอื่น ๆ ฟังก์ชันที่เรียกใช้งานมันได้เสร็จสิ้น หรือมีการเก็บไว้ในตัวแปร นั่นหมายความว่าฟังก์ชันหรือ closure นั้นสามารถ "escape" ออกจากขอบเขตการเรียกใช้งานต้นทางของมันเองไปยังที่อื่น ๆ และมีการเรียกใช้งานในภายหลังได้.

import SwiftUI

class EscapingViewModel: ObservableObject {
    
    @Published var text: String = "Hello"
    
    // MARK: ฟังก์ชันที่ใช้เรียกใช้งาน downloadData5() เพื่อดึงข้อมูล
    // โดยมีการใช้ [weak self] เพื่อป้องกันการถือค่า strong reference และป้องกันการที่ self จะไม่ถูก deallocated ในกรณีที่อาจเกิด strong reference cycle.
    func getData() {
        downloadData5 { [weak self] (returnedResult) in
            self?.text = returnedResult.data
        }
    }
    
    // MARK: ฟังก์ชันที่สร้างข้อมูลใหม่และคืนค่าข้อมูลนั้นกลับ.
    func downloadData() -> String {
        return "New data!"
    }
    
    // MARK: ฟังก์ชันที่รับ closure เป็น parameter และเรียกใช้งาน closure นั้นโดยส่งค่าข้อมูลใหม่เข้าไป.
    func downloadData2(completionHandler: (_ data: String) -> ()) {
        completionHandler("New data!")
    }
    
    // MARK: ฟังก์ชันที่รับ closure ในรูปแบบ "escaping" ซึ่งจะถูกเรียกใช้งานในภายหลัง และทำการคืนค่าข้อมูลใหม่ผ่าน closure นั้นหลังจากเวลาผ่านไป 2 วินาที.
    func downloadData3(completionHandler: @escaping (_ data: String) -> ()) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            completionHandler("New data!")
        }
    }
    
    // MARK: ฟังก์ชันที่รับ closure ในรูปแบบ "escaping" ซึ่งจะถูกเรียกใช้งานในภายหลัง และทำการคืนค่าข้อมูลใหม่ผ่าน closure นั้นหลังจากเวลาผ่านไป 2 วินาที.
    func downloadData4(completionHandler: @escaping (DownloadResult) ->()) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            let result = DownloadResult(data: "New data!")
            completionHandler(result)
        }
    }
    
    // MARK: ฟังก์ชันที่รับ closure ในรูปแบบ "escaping" ซึ่งจะถูกเรียกใช้งานในภายหลัง และทำการคืนค่าข้อมูลใหม่ผ่าน closure นั้นหลังจากเวลาผ่านไป 2 วินาที.
    func downloadData5(completionHandler: @escaping DownloadCompletion) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            let result = DownloadResult(data: "New data!")
            completionHandler(result)
        }
    }
}

struct DownloadResult {
    let data: String
}

typealias DownloadCompletion = (DownloadResult) -> ()

struct EscapingBootcamp: View {
    
    @StateObject var vm = EscapingViewModel()

    var body: some View {
        Text(vm.text)
            .font(.largeTitle)
            .fontWeight(.semibold)
            .foregroundColor(.blue)
            .onTapGesture {
                vm.getData()
            }
    }
}

#Preview {
    EscapingBootcamp()
}
