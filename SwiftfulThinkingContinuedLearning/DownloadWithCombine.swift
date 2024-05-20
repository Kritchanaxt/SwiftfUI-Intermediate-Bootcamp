//
//  DownloadWithCombine.swift
//  SwiftfulThinkingContinuedLearning
//
//  Created by Kritchanaxt_. on 27/5/2567 BE.
//

// MARK: DownloadWithCombine
// คือการใช้ Combine framework เพื่อดาวน์โหลดข้อมูลจาก URL และจัดการการอัปเดต UI อย่างมีประสิทธิภาพ.
// Combine ช่วยให้การทำงานแบบอะซิงโครนัสและการจัดการเธรดทำได้ง่ายและเป็นระเบียบ โดยใช้ publishers และ subscribers.

import SwiftUI
import Combine

// สร้างข้อมูลที่ใช้เก็บข้อมูลโพสต์ ซึ่งสอดคล้องกับข้อมูลที่ได้รับจาก API และสามารถถูกเข้ารหัสและถอดรหัสจาก JSON ได้
// ใช้ Identifiable เพื่อให้สามารถใช้งานกับ SwiftUI ได้ง่ายขึ้น.
struct PostModel: Identifiable, Codable {
    let userId: Int
    let id: Int
    let title: String
    let body: String
}

// คลาสนี้ทำตามโปรโตคอล ObservableObject เพื่อให้สามารถเผยแพร่ข้อมูลและทำงานร่วมกับ SwiftUI ได้.
class DownloadWithCombineViewModel: ObservableObject {
    
    // ประกาศตัวแปร posts ให้เป็น @Published เพื่อให้เมื่อมีการเปลี่ยนแปลงค่า View ที่ถูกผูกไว้จะถูกอัปเดตอัตโนมัติ.
    @Published var posts: [PostModel] = []
    
    // เก็บ AnyCancellable เพื่อใช้ยกเลิกการสมัคร (subscription) หากจำเป็น.
    var cancellables = Set<AnyCancellable>()
    
    // ฟังก์ชัน initializer จะถูกเรียกเมื่ออินสแตนซ์ของคลาสนี้ถูกสร้างขึ้น และเรียก getPosts() เพื่อดาวน์โหลดโพสต์ทันที.
    init() {
        getPosts()
    }
    
    // ฟังก์ชันนี้มีหน้าที่ดาวน์โหลดโพสต์จาก URL ที่กำหนด.
    func getPosts() {
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/posts") else { return }
        
        // MARK: Combine discussion: (ใช้ Combine framework เพื่อจัดการการดาวน์โหลดข้อมูล)
        /*
            1. sign up for monthly subscription for package to be delivered (สมัครสมาชิกรายเดือนเพื่อรับพัสดุที่ต้องการจัดส่ง)
            2. the company would make the package behind the scene (บริษัทจะจัดทำพัสดุเบื้องหลัง)
            3. recieve the package at your front door (รับพัสดุที่ประตูหน้าบ้านของคุณ)
            4. make sure the box isn't damaged (ตรวจสอบให้แน่ใจว่ากล่องไม่เสียหาย)
            5. open and make sure the item is correct (เปิดและตรวจสอบให้แน่ใจว่ารายการถูกต้อง)
            6. use the item!!!! (ใช้ไอเทม!!!!)
            7. cancellable at any time!! (ยกเลิกได้ตลอดเวลา!!)
          
            -------------------------------------------------------------
            1. create the publisher (สร้างสำนักพิมพ์)
            2. subscribe publisher on background thread (สมัครสมาชิกผู้เผยแพร่บนเธรดพื้นหลัง)
            3. recieve on main thread (รับตามกระทู้หลัก)
            4. tryMap (check that the data is good) (ตรวจสอบว่าข้อมูลดี)
            5. decode (decode data into PostModels) (ถอดรหัสข้อมูลลงใน PostModels)
            6. sink (put the item into our app) (ใส่ไอเทมลงในแอพของเรา)
            7. store (cancel subscription if needed) (ยกเลิกการสมัครสมาชิกหากจำเป็น)
         
        */
        
        // สร้าง publisher จาก URLSession.shared.dataTaskPublisher.
        URLSession.shared.dataTaskPublisher(for: url)
//            .subscribe(on: DispatchQueue.global(qos: .background))
            
            // รับข้อมูลบนเธรดหลัก.
            .receive(on: DispatchQueue.main)
        
            // ตรวจสอบข้อมูลที่ได้รับด้วย tryMap.
            .tryMap(handleOutput)
            
            // ถอดรหัสข้อมูล JSON เป็น [PostModel]
            .decode(type: [PostModel].self, decoder: JSONDecoder())
        
            // แทนค่าข้อผิดพลาดด้วยอาร์เรย์ว่าง.
            .replaceError(with: [])
        
            // ใช้ sink เพื่อรับค่าที่ได้รับและอัพเดต posts
            .sink(receiveValue: { [weak self] (returnedPosts) in
                self?.posts = returnedPosts
            })
        
            // เก็บการสมัครไว้ใน cancellables.
            .store(in: &cancellables)
    }
    
    // ฟังก์ชันนี้ตรวจสอบสถานะของ HTTP response.
    func handleOutput(output: URLSession.DataTaskPublisher.Output) throws -> Data {
        
        // ถ้าสถานะเป็น 200-299 จะส่งคืนข้อมูล ถ้าไม่จะโยนข้อผิดพลาด.
        guard
            let response = output.response as? HTTPURLResponse,
            response.statusCode >= 200 && response.statusCode < 300 else {
            throw URLError(.badServerResponse)
        }
        return output.data
    }
}

/*
 
 MARK: การใช้ Combine
 * Combine เป็นเฟรมเวิร์คที่ใช้จัดการการไหลของข้อมูลแบบเชิงปฏิกิริยา (reactive) ใน Swift.
 * URLSession.shared.dataTaskPublisher(for: url) สร้าง publisher สำหรับการดาวน์โหลดข้อมูลจาก URL.
 * receive(on: DispatchQueue.main) กำหนดให้การรับข้อมูลเกิดขึ้นบนเธรดหลัก.
 * tryMap(handleOutput) แปลงผลลัพธ์และตรวจสอบข้อมูลที่ได้รับ.
 * decode(type: [PostModel].self, decoder: JSONDecoder()) ถอดรหัสข้อมูล JSON เป็นอาร์เรย์ของ PostModel.
 * replaceError(with: []) แทนค่าข้อผิดพลาดด้วยอาร์เรย์ว่าง.
 * sink(receiveValue:) รับค่าที่ได้รับและอัพเดตตัวแปร posts.
 * store(in: &cancellables) เก็บการสมัครไว้เพื่อให้สามารถยกเลิกได้ในภายหลัง.
 
 */


struct DownloadWithCombine: View {
    
    @StateObject var vm = DownloadWithCombineViewModel()
    
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
    DownloadWithCombine()
}
