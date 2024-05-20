//
//  PhotoModelDataService.swift
//  SwiftfulThinkingContinuedLearning
//
//  Created by Kritchanaxt_. on 31/5/2567 BE.
//

import Foundation
import Combine

class PhotoModelDataService {
    
    // เป็น Singleton Object เพื่อการจัดการข้อมูลรูปภาพและการดาวน์โหลด
    static let instance = PhotoModelDataService() // Singleton
    
    @Published var photoModels: [PhotoModel] = []
    var cancellables = Set<AnyCancellable>()
    
    private init() {
        downloadData()
    }
    
    // ฟังก์ชันใช้ในการดาวน์โหลดข้อมูลจาก URL ที่กำหนด
    func downloadData() {
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/photos") else { return }
        
        // ใช้เพื่อสร้าง Publisher สำหรับดาวน์โหลดข้อมูล
        URLSession.shared.dataTaskPublisher(for: url)
            
            // กำหนดการทำงานของ Subscription ให้เกิดขึ้นใน Dispatch Queue ของ background
            .subscribe(on: DispatchQueue.global(qos:  .background))
         
            // กำหนดให้ผลลัพธ์ที่ได้รับมาจากการดาวน์โหลดมาที่ Dispatch Queue ของ main
            .receive(on: DispatchQueue.main)
        
            // ใช้เพื่อจัดการกับผลลัพธ์ที่ได้รับมาและเรียกใช้ handleOutput เพื่อตรวจสอบสถานะของการเชื่อมต่อ
            .tryMap(handleOutput)
            
            // ใช้เพื่อแปลงข้อมูล JSON ที่ได้รับมาเป็น Array ของ PhotoModel
            .decode(type: [PhotoModel].self, decoder: JSONDecoder())
        
            // ใช้เพื่อจัดการกับผลลัพธ์ของการดาวน์โหลด โดยกำหนดการทำงานเมื่อ Subscription เสร็จสิ้นหรือเกิดข้อผิดพลาด
            .sink { (completion) in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print("Error downloading data. \(error)")
                }
                
            // เมื่อข้อมูลดาวน์โหลดสำเร็จแล้ว นำข้อมูลที่ได้รับมาเก็บลงในตัวแปร photoModels โดยใช้ค่าที่แนบกับ self ใน Closure ของ receiveValue
            } receiveValue: { [weak self] (returnedPhotoModels) in
                self?.photoModels = returnedPhotoModels
            }
        
            // ใช้เพื่อเก็บ Subscription เพื่อให้สามารถยกเลิกการติดตามได้ทีหลังเมื่อไม่ต้องการใช้งาน Subscription ต่อไป
            .store(in: &cancellables)
    }
    
    
    // ฟังก์ชันใช้ในการตรวจสอบการตอบกลับจากเซิร์ฟเวอร์หลังจากการดาวน์โหลดข้อมูล
    private func handleOutput(output: URLSession.DataTaskPublisher.Output) throws -> Data {
        
        // ตรวจสอบว่าข้อมูลที่ได้รับมามีการตอบกลับจากเซิร์ฟเวอร์หรือไม่
        guard
            let response = output.response as? HTTPURLResponse,
            
            // ตรวจสอบว่ารหัสสถานะของการตอบกลับอยู่ในช่วง 200-299 (หมายถึงการดำเนินการสำเร็จ)
            response.statusCode >= 200 && response.statusCode < 300 else {
            
            // หากไม่ผ่านการตรวจสอบ เกิดข้อผิดพลาด URLError(.badServerResponse)
            throw URLError(.badServerResponse)
        }
        
        // คืนข้อมูลที่ได้รับมาจากการตอบกลับที่ผ่านการตรวจสอบลงไปในฟังก์ชันที่เรียกใช้งาน
        return output.data
    }
    
}
