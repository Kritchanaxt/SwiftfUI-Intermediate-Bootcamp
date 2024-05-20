//
//  CoreDataBootcamp.swift
//  SwiftfulThinkingContinuedLearning
//
//  Created by Kritchanaxt_. on 24/5/2567 BE.
//

import SwiftUI
import CoreData

// View - UI
// Model - data point
// ViewModel = manages the data for a view

class CoreDataViewModel: ObservableObject {
    
    let container: NSPersistentContainer
    @Published var savedEntities: [FruitEntity] = []
    
    // เมทอดนี้เป็นเมทอดคอนสตรักเตอร์ที่ใช้ในการสร้างอินสแตนซ์ของคลาส ซึ่งจะโหลดข้อมูลจาก Persistent Store ของ Core Data และดึงข้อมูลทั้งหมดจาก Entity ที่ชื่อ "FruitEntity" ผ่านเมทอด fetchFruits() เพื่อเตรียมข้อมูลสำหรับการแสดงผล
    init() {
        container = NSPersistentContainer(name: "FruitsContainer")
        container.loadPersistentStores{ (description, error) in
            if let error = error {
                print("ERROR LOADING CORE DATA. \(error)")
            }
        }
        fetchFruits()
    }
    
    //  เมทอดนี้ใช้สำหรับดึงข้อมูลทั้งหมดจาก Entity "FruitEntity" โดยใช้ NSFetchRequest และเก็บข้อมูลในตัวแปร savedEntities
    func fetchFruits() {
        let request = NSFetchRequest<FruitEntity>(entityName: "FruitEntity")
        
        do {
            savedEntities = try container.viewContext.fetch(request)
        } catch let error {
            print("Error fetching. \(error)")
        }
    }
    
    // เมทอดนี้ใช้ในการเพิ่มผลไม้ใหม่ลงใน Core Data โดยสร้างอ็อบเจกต์ใหม่ของ "FruitEntity" และกำหนดค่าของฟิลด์ "name" ก่อนที่จะเรียกเมทอด saveData() เพื่อบันทึกข้อมูล
    func addFruit(text: String) {
        let newFruit = FruitEntity(context: container.viewContext)
        newFruit.name = text
        
        saveData()
    }
    
    // เมทอดนี้ใช้ในการอัปเดตข้อมูลของผลไม้โดยเพิ่มเครื่องหมาย "!" ท้ายชื่อของผลไม้และเรียกเมทอด saveData() เพื่อบันทึกข้อมูลที่อัปเดต
    func updateFruit(entity: FruitEntity) {
        let currentName = entity.name ?? ""
        let newName = currentName + "!"
        entity.name = newName
        
        saveData()
    }
    
    //เมทอดนี้ใช้ในการลบผลไม้ออกจาก Core Data โดยรับอินเด็กซ์ของผลไม้ที่ต้องการลบ และจากนั้นลบอ็อบเจกต์นั้นออกจาก context ก่อนที่จะเรียกเมทอด saveData() เพื่อบันทึกการเปลี่ยนแปลง
    func deleteFruit(indexSet: IndexSet) {
        guard let index = indexSet.first else { return }
        let entity = savedEntities[index]
        container.viewContext.delete(entity)
        
        saveData()
    }
    
    // เมทอดนี้ใช้ในการบันทึกข้อมูลที่มีการเปลี่ยนแปลงลงใน Persistent Store ของ Core Data โดยใช้เมทอด save() ของ context และเรียกเมทอด fetchFruits() เพื่อดึงข้อมูลล่าสุดหลังจากการบันทึกข้อมูลเสร็จสิ้น
    func saveData() {
        do {
            try container.viewContext.save()
            fetchFruits()
        } catch let error {
            print("Error saving. \(error)")
        }
    }
}

struct CoreDataBootcamp: View {
    
    @StateObject var vm = CoreDataViewModel()
    @State var textFieldText: String = ""
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                TextField("Add fruit here...", text: $textFieldText)
                    .font(.headline)
                    .padding(.leading)
                    .frame(height: 55)
                    .background(Color(#colorLiteral(red: 0.921431005, green: 0.9214526415, blue: 0.9214410186, alpha: 1)))
                    .cornerRadius(10)
                    .padding(.horizontal)
                
                Button(action: {
                    guard !textFieldText.isEmpty else { return }
                    vm.addFruit(text: textFieldText)
                    textFieldText = ""
                }, label: {
                    Text("Save")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(height: 55)
                        .frame(maxWidth: .infinity)
                        .background(Color(#colorLiteral(red: 1, green: 0.1857388616, blue: 0.5733950138, alpha: 1)))
                        .cornerRadius(10)
                })
                .padding(.horizontal)
                
                List {
                    ForEach(vm.savedEntities) { entity in
                        Text(entity.name ?? "No NAME")
                            .onTapGesture {
                                vm.updateFruit(entity: entity)
                            }
                    }
                    .onDelete(perform: vm.deleteFruit)
                }
                .listStyle(PlainListStyle())
            }
            .navigationTitle("Fruits")
        }
    }
}

#Preview {
    CoreDataBootcamp()
}
