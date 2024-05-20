//
//  CacheBootcamp.swift
//  SwiftfulThinkingContinuedLearning
//
//  Created by Kritchanaxt_. on 30/5/2567 BE.
//

/*
 
 MARK: CacheManager
 - ใช้ในการเก็บข้อมูลที่ถูกเข้าถึงบ่อยครั้งเพื่อลดการเรียกข้อมูลจากที่ที่ต้องใช้งานข้อมูลจริง ๆ ที่อยู่ไกลแค่ทำให้การเข้าถึงข้อมูลเป็นไปอย่างมีประสิทธิภาพขึ้น โดยเฉพาะเมื่อมีการเรียกข้อมูลอยู่บ่อยครั้ง

 MARK: หลักของ CacheManager ประกอบด้วย
 1. การเพิ่มและลบข้อมูล: มีเมธอด add(image:name:) เพื่อเพิ่มรูปภาพเข้าสู่แคช, remove(name:) 
 เพื่อลบรูปภาพออกจากแคช, และ get(name:) เพื่อรับรูปภาพจากแคช

 2. การจัดเก็บข้อมูล: ใช้ NSCache เพื่อจัดเก็บข้อมูลภายในแคช 
 โดยในตัวอย่างนี้จะจำกัดจำนวนข้อมูลที่จะเก็บไว้ไม่เกิน 100 รายการ และจำนวนข้อมูลรวมไม่เกิน 100MB
 
 */

import SwiftUI

class CacheManager {
    
    static let instance = CacheManager() // Singleton
    private init() { }
    
    var imageCache: NSCache<NSString, UIImage> = {
        //สร้างตัวแปร cache ของ NSCache โดยกำหนด key เป็น NSString และ value เป็น UIImage
        let cache = NSCache<NSString, UIImage>()
        
        // กำหนดจำนวนสูงสุดของรายการที่จะเก็บในแคช เมื่อเกินจำนวนนี้แคชจะลบรายการเก่าออกเพื่อให้ทำงานได้ต่อ
        cache.countLimit = 100
        
        // กำหนดขนาดของแคชโดยรวม หรือขนาดสูงสุดของข้อมูลทั้งหมดในแคช เมื่อขนาดทั้งหมดเกินขนาดนี้แคชจะลบรายการเก่าออกเพื่อให้ทำงานได้ต่อ
        cache.totalCostLimit = 1024 * 1024 * 100 // 100mb
        return cache
    }()
    
    // ฟังก์ชันนี้ใช้ในการเพิ่มรูปภาพลงในแคช โดยรับรูปภาพและชื่อเป็นพารามิเตอร์ และจะนำรูปภาพนี้มาเก็บใน NSCache โดยใช้ชื่อเป็น key
    func add(image: UIImage, name: String) -> String {
        imageCache.setObject(image, forKey: name as NSString)
        return "Added to cache!"
    }
    
    // ฟังก์ชันนี้ใช้ในการลบรูปภาพออกจากแคช โดยรับชื่อของรูปภาพเป็นพารามิเตอร์ และจะลบรูปภาพที่มีชื่อตามที่กำหนดออกจาก NSCache
    func remove(name: String) -> String {
        imageCache.removeObject(forKey: name as NSString)
        return "Removed from cache!"
    }
    
    // ฟังก์ชันนี้ใช้ในการรับรูปภาพจากแคช โดยรับชื่อของรูปภาพเป็นพารามิเตอร์ และจะคืนค่ารูปภาพที่ตรงกับชื่อที่ระบุจาก NSCache ถ้าไม่มีรูปภาพจะคืนค่าเป็น nil
    func get(name: String) -> UIImage? {
        return imageCache.object(forKey: name as NSString)
    }
    
}

class CacheViewModel: ObservableObject {
    
    @Published var startingImage: UIImage? = nil
    @Published var cachedImage: UIImage? = nil
    @Published var infoMessage: String = ""
    let imageName: String = "wendys"
    let manager = CacheManager.instance
    
    init() {
        getImageFromAssetsFolder()
    }
    
    // ฟังก์ชันนี้ใช้ในการโหลดรูปภาพจากโฟลเดอร์ของแอปพลิเคชันและกำหนดให้ startingImage เป็นรูปภาพที่โหลดเริ่มต้น
    func getImageFromAssetsFolder() {
        startingImage = UIImage(named: imageName)
    }
    
    // ฟังก์ชันนี้ใช้ในการบันทึกรูปภาพลงในแคช โดยใช้ชื่อและรูปภาพจาก startingImage และเรียกใช้งานเมธอด add(image:name:) ของ CacheManager เพื่อเพิ่มรูปภาพลงในแคช
    func saveToCache() {
        guard let image = startingImage else { return }
        infoMessage = manager.add(image: image, name: imageName)
    }
    
    // ฟังก์ชันนี้ใช้ในการลบรูปภาพออกจากแคช โดยใช้ชื่อรูปภาพจาก imageName และเรียกใช้งานเมธอด remove(name:) ของ CacheManager เพื่อลบรูปภาพออกจากแคช
    func removeFromCache() {
        infoMessage = manager.remove(name: imageName)
    }
    
    // ฟังก์ชันนี้ใช้ในการรับรูปภาพจากแคช โดยใช้ชื่อรูปภาพจาก imageName และเรียกใช้งานเมธอด get(name:) ของ CacheManager เพื่อรับรูปภาพจากแคช
    func getFromCache() {
        
        // หากพบรูปภาพจะกำหนดให้ cachedImage เป็นรูปภาพที่พบ และกำหนดข้อความสถานะเป็น "Got image from Cache" หากไม่พบรูปภาพจะกำหนดข้อความสถานะเป็น "Image not found in Cache"
        if let returnedImage = manager.get(name: imageName) {
            cachedImage = returnedImage
            infoMessage = "Got image from Cache"
        } else {
            infoMessage = "Image not found in Cache"
        }
    }
    
}

struct CacheBootcamp: View {
    
    @StateObject var vm = CacheViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                if let image = vm.startingImage {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 200, height: 200)
                        .clipped()
                        .cornerRadius(10)
                }
                
                Text(vm.infoMessage)
                    .font(.headline)
                    .foregroundColor(.purple)
                
                HStack {
                    Button(action: {
                        vm.saveToCache()
                    }, label: {
                        Text("Save to Cache")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(10)
                    })
                    Button(action: {
                        vm.removeFromCache()
                    }, label: {
                        Text("Delete from Cache")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.red)
                            .cornerRadius(10)
                    })
                }
                
                Button(action: {
                    vm.getFromCache()
                }, label: {
                    Text("Get from Cache")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.green)
                        .cornerRadius(10)
                })
                
                if let image = vm.cachedImage {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 200, height: 200)
                        .clipped()
                        .cornerRadius(10)
                }
                
                Spacer()
            }
            .navigationTitle("Cache Bootcamp")
        }
    }
}

#Preview {
    CacheBootcamp()
}
