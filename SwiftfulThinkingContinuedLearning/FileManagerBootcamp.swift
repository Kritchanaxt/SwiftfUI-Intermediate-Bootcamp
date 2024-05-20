//
//  FileManagerBootcamp.swift
//  SwiftfulThinkingContinuedLearning
//
//  Created by Kritchanaxt_. on 30/5/2567 BE.
//

// MARK: LocalFileManager
// เป็นคลาสที่ใช้ในการจัดการไฟล์ภายในอุปกรณ์ที่เก็บไว้ใน local storage โดยมักจะใช้ในการจัดการกับไฟล์ที่เป็นรูปภาพหรือข้อมูลอื่น ๆ ที่ต้องการจัดเก็บไว้ในอุปกรณ์

import SwiftUI

class LocalFileManager {
    
    static let instance = LocalFileManager()
    let folderName = "MyApp_Images"
    
    init() {
        createFolderIfNeeded()
    }
    
    // ฟังก์ชันนี้ใช้สำหรับการสร้างโฟลเดอร์เก็บข้อมูล (เช่น รูปภาพ) สำหรับแอปพลิเคชัน หากยังไม่มีโฟลเดอร์นี้อยู่ โดยจะตรวจสอบก่อนว่าโฟลเดอร์มีอยู่หรือไม่ และถ้าไม่มีจะทำการสร้างขึ้นใหม่ โดยใช้ .cachesDirectory เป็นตำแหน่งเก็บของแอปพลิเคชัน
    func createFolderIfNeeded() {
        guard
            let path = FileManager
                .default
                .urls(for: .cachesDirectory, in: .userDomainMask)
                .first?
                .appendingPathComponent(folderName)
                .path else {
            return
        }
        
        if !FileManager.default.fileExists(atPath: path) {
            do {
                try FileManager.default.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
                print("Success creating folder.")
            } catch let error {
                print("Error creating folder. \(error)")
            }
        }
    }
    
    // ฟังก์ชันนี้ใช้สำหรับลบโฟลเดอร์ที่ใช้เก็บข้อมูลของแอปพลิเคชัน โดยลบโฟลเดอร์ที่อยู่ใน .cachesDirectory
    func deleteFolder() {
        guard
            let path = FileManager
                .default
                .urls(for: .cachesDirectory, in: .userDomainMask)
                .first?
                .appendingPathComponent(folderName)
                .path else {
            return
        }
        
        do {
            try FileManager.default.removeItem(atPath: path)
            print("Success deleting folder.")
        } catch let error {
            print("Error deleting folder. \(error)")
        }
    }
    
    // ฟังก์ชันนี้ใช้สำหรับบันทึกรูปภาพที่ถูกส่งเข้ามาเป็นพารามิเตอร์ และบันทึกลงในโฟลเดอร์ที่กำหนดไว้ และคืนค่าสถานะของการบันทึก
    func saveImage(image: UIImage, name: String) -> String {
        guard
            let data = image.jpegData(compressionQuality: 1.0),
            let path = getPathForImage(name: name) else {
            return "Error getting data."
        }
        
        do {
            try data.write(to: path)
            print(path)
            return "Success saving!"
        } catch let error {
            return "Error saving. \(error)"
        }
    }
    
    // ฟังก์ชันนี้ใช้สำหรับดึงรูปภาพที่มีชื่อตามที่ระบุออกมา จากนั้นแปลงเป็น UIImage และคืนค่า
    func getImage(name: String) -> UIImage? {
        guard
            let path = getPathForImage(name: name)?.path,
            FileManager.default.fileExists(atPath: path) else {
            print("Error getting path.")
            return nil
        }
        
        return UIImage(contentsOfFile: path)
    }
    
    // ฟังก์ชันนี้ใช้สำหรับลบรูปภาพที่มีชื่อตามที่ระบุ และคืนค่าสถานะของการลบ
    func deleteImage(name: String) -> String {
        guard
            let path = getPathForImage(name: name)?.path,
            FileManager.default.fileExists(atPath: path) else {
            return "Error getting path."
        }
        
        do {
            try FileManager.default.removeItem(atPath: path)
            return "Successfully deleted."
        } catch let error {
            return "Error deleting image image. \(error)"
        }
    }
    
    // ฟังก์ชันนี้ใช้สำหรับรับชื่อของรูปภาพและสร้าง URL สำหรับพาธของรูปภาพนั้นๆ ในโฟลเดอร์ที่กำหนดไว้
    func getPathForImage(name: String) -> URL? {
        guard
            let path = FileManager
                .default
                .urls(for: .cachesDirectory, in: .userDomainMask)
                .first?
                .appendingPathComponent(folderName)
                .appendingPathExtension("\(name).jpg") else {
            print("Error getting path.")
            return nil
        }
        
        return path
    }
}

class FileManagerViewModel: ObservableObject {
     
    @Published var image: UIImage? = nil
    @Published var infoMessage: String = ""
    let imageName: String = "wendys"
    let manager = LocalFileManager.instance
    
    init() {
        getImageFromAssetsFolder()
//        getImageFromFileManager()
    }
    
    // ฟังก์ชันนี้ใช้ในการโหลดรูปภาพจากโฟลเดอร์ของ assets ในแอปพลิเคชัน โดยใช้ชื่อรูปภาพที่กำหนด
    func getImageFromAssetsFolder() {
        image = UIImage(named: imageName)
    }
    
    // ฟังก์ชันนี้ใช้ในการโหลดรูปภาพจาก LocalFileManager โดยใช้ชื่อรูปภาพที่กำหนด
    func getImageFromFileManager() {
        image = manager.getImage(name: imageName)
    }
    
    // ฟังก์ชันนี้ใช้ในการบันทึกรูปภาพที่อยู่ในตัวแปร image ลงใน LocalFileManager โดยใช้ชื่อรูปภาพที่กำหนด
    func saveImage() {
        guard let image = image else { return }
        infoMessage = manager.saveImage(image: image, name: imageName)
    }
    
    //ฟังก์ชันนี้ใช้ในการลบรูปภาพที่มีชื่อตามที่กำหนด และลบโฟลเดอร์ที่ใช้เก็บข้อมูลภาพของแอปพลิเคชัน
    func deleteImage() {
        infoMessage = manager.deleteImage(name: imageName)
        manager.deleteFolder()
    }
}


struct FileManagerBootcamp: View {
    
    @StateObject var vm = FileManagerViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                
                if let image = vm.image {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 200, height: 200)
                        .clipped()
                        .cornerRadius(10)
                }
                
                HStack {
                    Button(action: {
                        vm.saveImage()
                    }, label: {
                        Text("Save to FM")
                            .foregroundColor(.white)
                            .font(.headline)
                            .padding()
                            .padding(.horizontal)
                            .background(Color.blue)
                            .cornerRadius(10)
                    })
                    Button(action: {
                        vm.deleteImage()
                    }, label: {
                        Text("Delete from FM")
                            .foregroundColor(.white)
                            .font(.headline)
                            .padding()
                            .padding(.horizontal)
                            .background(Color.red)
                            .cornerRadius(10)
                    })
                }
                
                Text(vm.infoMessage)
                    .font(.largeTitle)
                    .fontWeight(.semibold)
                    .foregroundColor(.purple)
                
                Spacer()
            }
            .navigationTitle("File Manager")
        }
    }
}

#Preview {
    FileManagerBootcamp()
}
