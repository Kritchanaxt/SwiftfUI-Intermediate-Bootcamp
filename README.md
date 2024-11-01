# SwiftfUI Intermediate Level 

Learning SwiftUI Intermediate Level for iOS app development is an excellent choice for aspiring iOS developers.


## Note SwiftUI

#### @ObservedResults
- ใช้ร่วมกับ Realm เพื่อสังเกตการเปลี่ยนแปลงในข้อมูล

#### @Persisted
- ทำเครื่องหมายคุณสมบัติที่ควรถูกเก็บใน Realm

#### RealmSwift.List<Item>()
- กำหนดรายการของวัตถุใน Realm

#### ForEach
- ทำซ้ำวิวสำหรับแต่ละรายการในคอลเล็กชัน ทำให้โค้ดสะอาดขึ้นเมื่อเปรียบเทียบกับลูปแบบดั้งเดิม

#### if let / guard
- **if let:** ปลดล็อก Optionals อย่างปลอดภัยภายในบล็อกเดียว
- **guard:** ปลดล็อก Optionals และออกจากฟังก์ชันก่อนถ้าเป็น nil

#### ProgressView
- แสดงแถบความก้าวหน้า มักจะแสดงเป็นวงกลมหมุนในระหว่างการดำเนินการ

#### ObservableObject
- แจ้ง SwiftUI ให้ปรับปรุง UI เมื่อข้อมูลเปลี่ยนแปลง

---

### อื่นๆ

#### @MainActor
- ระบุว่าโค้ดควรทำงานบน main actor เพื่อป้องกันปัญหาการแข่งขันข้อมูลในการพัฒนา UI

#### @discardableResult
- แจ้งคอมไพเลอร์ว่าผลลัพธ์ที่คืนจากฟังก์ชันสามารถถูกละเลยได้

---

### แนวคิดเพิ่มเติมใน SwiftUI

#### some
- ระบุว่าประเภทไม่ถูกกำหนดอย่างชัดเจน มักใช้สำหรับการประกาศวิวที่ยืดหยุ่น

#### @Environment
- Property wrapper สำหรับอ่านค่าจากสภาพแวดล้อมของแอปพลิเคชัน (เช่น ขนาดของอุปกรณ์หรือธีม)

#### final
- ป้องกันการสืบทอดหรือการเขียนทับโดยการทำเครื่องหมายคลาสหรือวิธีการเป็น final

#### try?
- จัดการกับข้อผิดพลาดที่อาจเกิดขึ้นโดยไม่ทำให้โปรแกรมล้มเหลว คืนค่า nil หากเกิดข้อผิดพลาด

#### await
- รอการดำเนินการแบบอะซิงโครนัสให้เสร็จสิ้นก่อนที่จะดำเนินการต่อ ใช้ร่วมกับ "async" เพื่อระบุว่าบล็อกของโค้ดเป็นอะซิงโครนัส

#### @Published
- ประกาศคุณสมบัติใน `ObservableObject` ที่สามารถอัปเดต UI อัตโนมัติเมื่อค่าของมันเปลี่ยนแปลง

#### @Binding
- เชื่อมโยงค่าระหว่างวิวสองตัว ทำให้มีการอัปเดตอัตโนมัติและทำให้การจัดการสถานะง่ายขึ้น

#### @available
- ระบุเวอร์ชันของ OS หรือภาษา Swift ที่รองรับโค้ดของคุณ

#### @escaping
- ระบุว่าคลอเซอร์อาจถูกเรียกหลังจากฟังก์ชันที่รับมันได้ส่งคืน ซึ่งมักใช้ในงานที่ต้องการอะซิงโครนัส

---

### รูปแบบการออกแบบ

#### Singleton
- รับรองว่าคลาสมีเพียงหนึ่งอินสแตนซ์และให้จุดเข้าถึงทั่วโลกไปยังมัน

```swift
class MySingleton {
    static let shared = MySingleton()
    private init() {}
    func doSomething() {
        print("Singleton is working")
    }
}

// การใช้งาน
MySingleton.shared.doSomething()
```

#### Factory
- ใช้เพื่อสร้างวัตถุโดยไม่ต้องระบุคลาสที่แน่นอน ทำให้มีความยืดหยุ่นมากขึ้น

```swift
protocol Animal {
    func makeSound() -> String
}

class Dog: Animal {
    func makeSound() -> String {
        return "Woof!"
    }
}

class Cat: Animal {
    func makeSound() -> String {
        return "Meow!"
    }
}

class AnimalFactory {
    enum AnimalType {
        case dog
        case cat
    }
    
    static func createAnimal(type: AnimalType) -> Animal {
        switch type {
        case .dog:
            return Dog()
        case .cat:
            return Cat()
        }
    }
}

// การใช้งาน
let dog = AnimalFactory.createAnimal(type: .dog)
print(dog.makeSound())  // ผลลัพธ์: Woof!
```

---

### View Modifiers ใน SwiftUI

#### .transition(.offset)
- กำหนดเอฟเฟกต์การเคลื่อนไหวของวิวเมื่อปรากฏหรือหายไป

#### EdgeInsets
- ใช้เพื่อกำหนดการจัด padding ระหว่างขอบของวิวและเนื้อหาของมัน

