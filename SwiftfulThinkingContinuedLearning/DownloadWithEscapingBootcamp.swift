//
//  DownloadWithEscapingBootcamp.swift
//  SwiftfulThinkingContinuedLearning
//
//  Created by Kritchanaxt_. on 27/5/2567 BE.
//

// MARK: DownloadWithEscaping 
// เป็นการใช้การ callback เพื่อดาวน์โหลดข้อมูลจาก URL และจัดการกับการอัปเดต UI โดยใช้ closures ที่มีการ escaping. การ escaping closure จะช่วยให้สามารถจัดการกับการทำงานแบบอะซิงโครนัสได้อย่างมีประสิทธิภาพ.


import SwiftUI

//struct PostModel: Identifiable, Codable {
//    let userId: Int
//    let id: Int
//    let title: String
//    let body: String
//}


// คลาสนี้เป็น ViewModel ซึ่งทำตาม ObservableObject โปรโตคอลใน  ซึ่งทำให้สามารถเผยแพร่และผูกข้อมูลกับ View ได้.
class DownloadWithEscapingViewModel: ObservableObject {
    
    // ตัวแปร posts ถูกประกาศให้เป็น @Published เพื่อให้เมื่อมีการเปลี่ยนแปลงค่าของตัวแปรนี้ View ที่ถูกผูกไว้กับมันจะถูกอัปเดตโดยอัตโนมัติ.
    @Published var posts: [PostModel] = []
    
    // ฟังก์ชัน initializer จะถูกเรียกเมื่ออินสแตนซ์ของคลาสนี้ถูกสร้างขึ้น ซึ่งในที่นี้จะเรียก getPosts() เพื่อดาวน์โหลดโพสต์ทันทีที่ ViewModel นี้ถูกสร้าง.
    init() {
        getPosts()
    }
    
    // ฟังก์ชันนี้มีหน้าที่ดาวน์โหลดโพสต์จาก URL ที่กำหนด.
    func getPosts() {
           
           // ตรวจสอบ URL ว่าถูกต้องหรือไม่. ถ้าไม่ถูกต้องจะหยุดการทำงาน.
           guard let url = URL(string: "https://jsonplaceholder.typicode.com/posts") else { return }
           
           // เรียก downloadData(fromURL:completionHandler:) เพื่อเริ่มกระบวนการดาวน์โหลดข้อมูล.
           downloadData(fromURL: url) { (returnedData) in
               if let data = returnedData {
                   guard let newPosts = try? JSONDecoder().decode([PostModel].self, from: data) else { return }
                   DispatchQueue.main.async { [weak self] in
                       self?.posts = newPosts
                   }
               } else {
                   print("No data returned.")
               }
           }
       }
    
    // ฟังก์ชันนี้จะดาวน์โหลดข้อมูลจาก URL ที่กำหนดและใช้ escaping closure เพื่อจัดการข้อมูลเมื่อการดาวน์โหลดเสร็จสิ้น.
    func downloadData(fromURL url: URL, completionHandler: @escaping (_ data: Data?) -> ()) {
            
            // ใช้ URLSession.shared.dataTask เพื่อเริ่มงานดาวน์โหลดข้อมูล.
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                guard
                    let data = data,
                    error == nil,
                    let response = response as? HTTPURLResponse,
                    response.statusCode >= 200 && response.statusCode < 300 else {
                    print("Error downloading data.")
                    
                    // ตรวจสอบว่ามีข้อมูลที่ได้รับกลับมาและไม่มีข้อผิดพลาด ถ้ามีข้อผิดพลาดจะเรียก
                    completionHandler(nil)
                    return
                }
                
                // ถ้าการดาวน์โหลดสำเร็จจะเรียก completionHandler(data) เพื่อส่งข้อมูลกลับไป.
                completionHandler(data)
                
            }.resume()
        }
}

struct DownloadWithEscapingBootcamp: View {
    
    @StateObject var vm = DownloadWithEscapingViewModel()
    
    var body: some View {
        List {
            ForEach(vm.posts) { post in
                VStack(alignment: .leading) {
                    Text(post.title)
                        .font(.headline)
                    Text(post.body)
                        .foregroundColor(.gray)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
    }
}

#Preview {
    DownloadWithEscapingBootcamp()
}
