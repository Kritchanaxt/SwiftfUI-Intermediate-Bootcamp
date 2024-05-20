//
//  CodableBootcamp.swift
//  SwiftfulThinkingContinuedLearning
//
//  Created by Kritchanaxt_. on 27/5/2567 BE.
//

// MARK: Codable
/*
 - เป็น protocol ที่ใช้สำหรับการเข้ารหัส (encode) และถอดรหัส (decode) ข้อมูลระหว่างแบบแรกของ Swift กับรูปแบบข้อมูลอื่น ๆ เช่น JSON, Property List,

 - หรือเมื่อต้องการเก็บข้อมูลในรูปแบบที่สามารถจัดเก็บและส่งผ่านได้ เช่นการบันทึกข้อมูลลงในแฟ้มข้อมูล (file) หรือการส่งข้อมูลผ่านเครือข่าย (network communication)

 - ใน Codable มีสอง protocol ย่อยคือ Encodable (สำหรับเข้ารหัส) และ Decodable (สำหรับถอดรหัส)

 - ซึ่งเมื่อคลาสหรือโครงสร้างข้อมูลใดๆ นำมาประกาศด้วย Codable จะสามารถทำการเข้ารหัสและถอดรหัสข้อมูลได้โดยอัตโนมัติโดยไม่ต้องระบุโค้ดเพิ่มเติมในกรณีที่ข้อมูลเป็นรูปแบบ JSON หรือ Property List
*/

import SwiftUI

// Codable = Decodable + Encodable

struct CustomerModel: Identifiable, Codable {
    let id: String
    let name: String
    let points: Int
    let isPremium: Bool
    
//    enum CodingKeys: String, CodingKey {
//        case id
//        case name
//        case points
//        case isPremium
//    }
//
//    init(id: String, name: String, points: Int, isPremium: Bool) {
//        self.id = id
//        self.name = name
//        self.points = points
//        self.isPremium = isPremium
//    }
//
//    init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        self.id = try container.decode(String.self, forKey: .id)
//        self.name = try container.decode(String.self, forKey: .name)
//        self.points = try container.decode(Int.self, forKey: .points)
//        self.isPremium = try container.decode(Bool.self, forKey: .isPremium)
//    }
//
//    func encode(to encoder: Encoder) throws {
//        var container = encoder.container(keyedBy: CodingKeys.self)
//        try container.encode(id, forKey: .id)
//        try container.encode(name, forKey: .name)
//        try container.encode(points, forKey: .points)
//        try container.encode(isPremium, forKey: .isPremium)
//    }
    
}

class CodableViewModel: ObservableObject {
    
    @Published var customer: CustomerModel? = nil
    
    init() {
        getData()
    }
    
    func getData() {
        // ใช้ guard let เพื่อตรวจสอบว่ามีข้อมูล JSON ที่ได้จาก getJSONData() หรือไม่ ถ้าไม่มีก็จะออกจากฟังก์ชันไปโดยไม่ทำอะไรต่อ.
        guard let data = getJSONData() else { return }
        
        // ใช้ JSONDecoder() เพื่อถอดรหัสข้อมูล JSON เป็น instance ของ CustomerModel และกำหนดให้ self.customer มีค่าเป็นผลลัพธ์ หากมีข้อผิดพลาดในการถอดรหัสจะถูกจับและจะไม่มีการตั้งค่า customer.
        self.customer = try? JSONDecoder().decode(CustomerModel.self, from: data)

        
        // MARK: สามารถใช้ในกรณีที่การถอดรหัสด้วย Codable ไม่สามารถทำงานได้ตามที่ต้องการ หรือในกรณีที่ต้องการจัดการกับข้อมูล JSON โดยตรงโดยใช้ JSONSerialization.
        /*
        do {
            self.customer = try JSONDecoder().decode(CustomerModel.self, from: data)
        } catch let error {
            print("Error decoding. \(error)")
        }
        
        if
            let localData = try? JSONSerialization.jsonObject(with: data, options: []),
            let dictionary = localData as? [String:Any],
            let id = dictionary["id"] as? String,
            let name = dictionary["name"] as? String,
            let points = dictionary["points"] as? Int,
            let isPremium = dictionary["isPremium"] as? Bool {

            let newCustomer = CustomerModel(id: id, name: name, points: points, isPremium: isPremium)
            customer = newCustomer
        }
        */
        
        
    }
    
    func getJSONData() -> Data? {
        
        // โดยกำหนดค่าแบบ Hardcoded สำหรับ id, name, points, และ isPremium
        let customer = CustomerModel(id: "111", name: "Emily", points: 100, isPremium: false)
        
        // ใช้ JSONEncoder() เพื่อเข้ารหัสข้อมูลที่สร้างขึ้นเป็น JSON โดยแปลงข้อมูลจาก CustomerModel เป็น Data และเก็บไว้ในตัวแปร jsonData.
        let jsonData = try? JSONEncoder().encode(customer)
        
        // MARK: สามารถใช้ในกรณีที่การถอดรหัสด้วย Codable ไม่สามารถทำงานได้ตามที่ต้องการ หรือในกรณีที่ต้องการจัดการกับข้อมูล JSON โดยตรงโดยใช้ JSONSerialization.
        /*
            let dictionary: [String:Any] = [
                "id" : "12345",
                "name" : "Joe",
                "points" : 5,
                "isPremium" : true
            ]
            let jsonData = try? JSONSerialization.data(withJSONObject: dictionary, options: [])
        */
        
        
        // คืนค่า jsonData กลับเป็นผลลัพธ์ของฟังก์ชัน เพื่อให้ใช้ในการถอดรหัส JSON ในฟังก์ชัน getData() ของ ViewModel ต่อไป.
        return jsonData
    }
        
}

struct CodableBootcamp: View {
    
    @StateObject var vm = CodableViewModel()
    
    var body: some View {
        VStack(spacing: 20) {
            if let customer = vm.customer {
                Text(customer.id)
                Text(customer.name)
                Text("\(customer.points)")
                Text(customer.isPremium.description)
            }
        }
    }
}

#Preview {
    CodableBootcamp()
}
