//
//  ImageLoadingViewModel.swift
//  SwiftfulThinkingContinuedLearning
//
//  Created by Kritchanaxt_. on 1/6/2567 BE.
//

import Foundation
import SwiftUI
import Combine

class ImageLoadingViewModel: ObservableObject {
    
    @Published var image: UIImage? = nil
    @Published var isLoading: Bool = false
    
    var cancellables = Set<AnyCancellable>()
    let manager = PhotoModelFileManager.instance
    
    let urlString: String
    let imageKey: String
    
    init(url: String, key: String) {
        urlString = url
        imageKey = key
        getImage()
    }
    
    func getImage() {
        if let saveImage = manager.get(key: imageKey)  {
            image = saveImage
            print("Getting saved image!")
        } else {
            downloadImage()
        }
    }
    
    // ใช้ในการดาวน์โหลดรูปภาพจาก URL ที่กำหนด
    func downloadImage() {
        
        // กำหนดตัวแปร isLoading เป็น true เพื่อแสดงว่ากำลังโหลด
        isLoading = true
        
        //ตรวจสอบ URL ว่าถูกต้องหรือไม่ ถ้าไม่ถูกต้องก็จะกำหนด isLoading เป็น false แล้วจบฟังก์ชัน
        guard let url = URL(string: urlString) else {
            isLoading = false
            return
        }
        
        // ใช้เพื่อสร้าง Publisher สำหรับดาวน์โหลดข้อมูล
        URLSession.shared.dataTaskPublisher(for: url)
        
            // ใช้เพื่อแปลงข้อมูลที่ได้รับเป็น UIImage
            .map { UIImage(data: $0.data) }
        
            // ใช้เพื่อส่งผลลัพธ์กลับมาที่ Main Thread
            .receive(on: DispatchQueue.main)
        
            // ใช้เพื่อจัดการกับผลลัพธ์ของการดาวน์โหลด ซึ่งหยุดการโหลด (isLoading เป็น false) และเก็บรูปภาพที่ได้ลงในตัวแปร image และในแคช (manager.add)
            .sink { [weak self] (_) in
                self?.isLoading = false
            } receiveValue: {  [weak self] (returnedImage) in
                guard
                    let self = self,
                    let image = returnedImage else { return }
                
                self.image = image
                self.manager.add(key: self.imageKey, value: image)
            }
            
            // ใช้เพื่อเก็บ Subscription เพื่อให้สามารถยกเลิกการติดตามได้ทีหลังเมื่อไม่ต้องการใช้งาน Subscription ต่อไป
            .store(in: &cancellables)
    }
}
