//
//  CoreDataRelationshipsBootcamp.swift
//  SwiftfulThinkingContinuedLearning
//
//  Created by Kritchanaxt_. on 25/5/2567 BE.
//

//  MARK: CoreDataRelationship
// คือความสัมพันธ์ระหว่างเอนทิตีต่าง ๆ ใน Core Data ที่ช่วยให้สามารถจัดการและเชื่อมโยงข้อมูลระหว่างตาราง (entities) ต่าง ๆ ได้ เช่น ความสัมพันธ์แบบ one-to-many, many-to-many, หรือ one-to-one.


import SwiftUI
import CoreData

// 3 entities
// BusinessEntity
// DepartmentEntity
// EmployeeEntity

class CoreDataManager {
    
    // สร้าง instance เดียวของ CoreDataManager เพื่อให้ใช้ทั่วทั้งแอปพลิเคชัน.
    static let instance = CoreDataManager() // Singleton
    
    let container: NSPersistentContainer
    
    // Managed Object Context: จัดการกับบริบท (context) ในการบันทึกข้อมูล.
    let context: NSManagedObjectContext
    
    init() {
        
        // สร้าง NSPersistentContainer ชื่อ "CoreDataContainer" เพื่อจัดการกับโมเดลข้อมูล.
        container = NSPersistentContainer(name: "CoreDataContainer")
        container.loadPersistentStores { (description, error) in
            if let error = error {
                print("Error loading Core Data. \(error)")
            }
        }
        context = container.viewContext
    }
    
    // ฟังก์ชัน save สำหรับบันทึกการเปลี่ยนแปลงใน context ลงใน Core Data.
    func save() {
        do {
            try context.save()
            print("Saved successfully!")
        } catch let error {
            print("Error saving Core Data. \(error.localizedDescription)")
        }
    }
    
}

// สร้างคลาส CoreDataRelationshipViewModel ซึ่งเป็น ObservableObject สำหรับจัดการความสัมพันธ์ระหว่าง Entity ต่าง ๆ
// ใน Core Data ได้แก่ BusinessEntity, DepartmentEntity และ EmployeeEntity
class CoreDataRelationshipViewModel: ObservableObject {
    let manager = CoreDataManager.instance
    @Published var businesses: [BusinessEntity] = []
    @Published var departments: [DepartmentEntity] = []
    @Published var employees: [EmployeeEntity] = []
    
    // ใน init จะทำการเรียกฟังก์ชัน getBusinesses, getDepartments, และ getEmployees เพื่อดึงข้อมูลทั้งหมดตั้งแต่เริ่มต้น.
    init() {
        addInitialData() // เพิ่มข้อมูลเริ่มต้น
        getBusinesses()
        getDepartments()
        getEmployees()
    }
    
    // ฟังก์ชันที่ใช้สำหรับเพิ่มข้อมูลเริ่มต้นเข้าไปในฐานข้อมูล Core Data.
    // ฟังก์ชันนี้จะสร้าง entities ใหม่สำหรับธุรกิจแล้วเชื่อมโยงพวกมันเข้าด้วยกัน.
    func addInitialData() {
        
            // สร้างธุรกิจใหม่ (BusinessEntity)
            let newBusiness = BusinessEntity(context: manager.context)
            newBusiness.name = "Apple"
            
            // สร้างแผนกใหม่ (DepartmentEntity):
            let newDepartment = DepartmentEntity(context: manager.context)
            newDepartment.name = "HR"
            
            // สร้างพนักงานใหม่ (EmployeeEntity)
            let newEmployee = EmployeeEntity(context: manager.context)
            newEmployee.name = "John Doe"
            newEmployee.age = 30
            newEmployee.dateJoined = Date()
            
            // เชื่อมโยง entities เข้าด้วยกัน
            newBusiness.addToDepartments(newDepartment)
            newDepartment.addToEmployees(newEmployee)
            newEmployee.business = newBusiness
            newEmployee.department = newDepartment
            
            // เรียกฟังก์ชัน save เพื่อบันทึกข้อมูลที่เพิ่งเพิ่มเข้าไปใน context ลงใน Core Data
            save()
        }
    
    // ฟังก์ชันนี้ใช้ NSFetchRequest เพื่อดึงข้อมูลจาก Core Data และจัดเก็บในอาเรย์ที่เผยแพร่.
    func getBusinesses() {
        let request = NSFetchRequest<BusinessEntity>(entityName: "BusinessEntity")
        
        let sort = NSSortDescriptor(keyPath: \BusinessEntity.name, ascending: true)
        request.sortDescriptors = [sort]
    
        //let filter = NSPredicate(format: "name == %@", "Apple")
        //request.predicate = filter
        
        do {
            businesses = try manager.context.fetch(request)
            print("Fetched Businesses: \(businesses)")
        } catch let error {
            print("Error fetching. \(error.localizedDescription)")
        }
    }
    
    // ฟังก์ชันนี้ใช้ NSFetchRequest เพื่อดึงข้อมูลจาก Core Data และจัดเก็บในอาเรย์ที่เผยแพร่.
    func getDepartments() {
        let request = NSFetchRequest<DepartmentEntity>(entityName: "DepartmentEntity")
        
        do {
            departments = try manager.context.fetch(request)
            print("Fetched Departments: \(departments)")
        } catch let error {
            print("Error fetching. \(error.localizedDescription)")
        }
    }
    
    // ฟังก์ชันนี้ใช้ NSFetchRequest เพื่อดึงข้อมูลจาก Core Data และจัดเก็บในอาเรย์ที่เผยแพร่.
    func getEmployees() {
        let request = NSFetchRequest<EmployeeEntity>(entityName: "EmployeeEntity")
        
        do {
            employees = try manager.context.fetch(request)
            print("Fetched Employees: \(employees)")
        } catch let error {
            print("Error fetching. \(error.localizedDescription)")
        }
    }
    
    //  ฟังก์ชันนี้ดึงเฉพาะพนักงานที่อยู่ในธุรกิจที่ระบุ.
    func getEmployees(forBusiness business: BusinessEntity) {
        let request = NSFetchRequest<EmployeeEntity>(entityName: "EmployeeEntity")
        
        let filter = NSPredicate(format: "business == %@", business)
        request.predicate = filter
        
        do {
            employees = try manager.context.fetch(request)
        } catch let error {
            print("Error fetching. \(error.localizedDescription)")
        }
    }
    
    // อัปเดตธุรกิจที่มีอยู่โดยการเพิ่มแผนก.
    func updateBusiness() {
        
        let existingBusiness = businesses[2]
        existingBusiness.addToDepartments(departments[1])
        save()
        
    }
    
    // ฟังก์ชันนี้ใช้ในการสร้างและเพิ่ม Entity ใหม่ใน Core Data.
    func addBusiness() {
        let newBusiness = BusinessEntity(context: manager.context)
        newBusiness.name = "Facebook"
        
        // add existing departments to the new business
        //newBusiness.departments = [departments[0], departments[1]]
        
        newBusiness.departments = [departments[0]]
        
        // add existing employees to the new business
        //newBusiness.employees = [employees[1]]
        
        // add new business to existing department
        //newBusiness.addToDepartments(<#T##value: DepartmentEntity##DepartmentEntity#>)
        
        // add new business to existing employee
        //newBusiness.addToEmployees(<#T##value: EmployeeEntity##EmployeeEntity#>)
                
        save()
    }
    
    // ฟังก์ชันนี้ใช้ในการสร้างและเพิ่ม Entity ใหม่ใน Core Data.
    func addDepartment() {
        let newDepartment = DepartmentEntity(context: manager.context)
        newDepartment.name = "Finance"
        newDepartment.businesses = [businesses[0], businesses[1], businesses[2]]
        newDepartment.addToEmployees(employees[1])
        
        //newDepartment.employees = [employees[1]]
        //newDepartment.addToEmployees(employees[1])
        
        save()
    }
    
    // ฟังก์ชันนี้ใช้ในการสร้างและเพิ่ม Entity ใหม่ใน Core Data.
    func addEmployee() {
        let newEmployee = EmployeeEntity(context: manager.context)
        newEmployee.age = 21
        newEmployee.dateJoined = Date()
        newEmployee.name = "John"
        
        newEmployee.business = businesses[2]
        newEmployee.department = departments[1]
        save()
    }
    
    // ลบแผนกจาก Core Data.
    func deleteDepartment() {
        let department = departments[1]
        manager.context.delete(department)
        save()
    }

    // ฟังก์ชันนี้บันทึกการเปลี่ยนแปลงใน context และทำการ fetch ข้อมูลใหม่หลังจากบันทึกเสร็จ.
    func save() {
        businesses.removeAll()
        departments.removeAll()
        employees.removeAll()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.manager.save()
            self.getBusinesses()
            self.getDepartments()
            self.getEmployees()
        }
    }
    
}

struct CoreDataRelationshipsBootcamp: View {
    
    @StateObject var vm = CoreDataRelationshipViewModel()
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    Button(action: {
                        vm.deleteDepartment()
                    }, label: {
                        Text("Perform Action")
                            .foregroundColor(.white)
                            .frame(height: 55)
                            .frame(maxWidth: .infinity)
                            .background(Color.blue.cornerRadius(10))
                    })
                    
                    ScrollView(.horizontal, showsIndicators: true, content: {
                        HStack(alignment: .top) {
                            ForEach(vm.businesses) { business in
                                BusinessView(entity: business)
                            }
                        }
                    })
                    
                    ScrollView(.horizontal, showsIndicators: true, content: {
                        HStack(alignment: .top) {
                            ForEach(vm.departments) { department in
                                DepartmentView(entity: department)
                            }
                        }
                    })
                    
                    ScrollView(.horizontal, showsIndicators: true, content: {
                        HStack(alignment: .top) {
                            ForEach(vm.employees) { employee in
                                EmployeeView(entity: employee)
                            }
                        }
                    })
                }
                .padding()
            }
            .navigationTitle("Relationships")
        }
    }
}

struct CoreDataRelationshipsBootcamp_Previews: PreviewProvider {
    static var previews: some View {
        CoreDataRelationshipsBootcamp()
    }
}

struct BusinessView: View {
    
    let entity: BusinessEntity
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20, content: {
            Text("Name: \(entity.name ?? "")")
                .bold()
            
            if let departments = entity.departments?.allObjects as? [DepartmentEntity] {
                Text("Departments:")
                    .bold()
                ForEach(departments) { department in
                    Text(department.name ?? "")
                }
            }
            if let employees = entity.employees?.allObjects as? [EmployeeEntity] {
                Text("Employees:")
                    .bold()
                ForEach(employees) { employee in
                    Text(employee.name ?? "")
                }
            }
        })
        .padding()
        .frame(maxWidth: 300, alignment: .leading)
        .background(Color.gray.opacity(0.5))
        .cornerRadius(10)
        .shadow(radius: 10)
    }
}

struct DepartmentView: View {
    
    let entity: DepartmentEntity
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20, content: {
            Text("Name: \(entity.name ?? "")")
                .bold()
            
            if let businesses = entity.businesses?.allObjects as? [BusinessEntity] {
                Text("Businesses:")
                    .bold()
                ForEach(businesses) { business in
                    Text(business.name ?? "")
                }
            }
            if let employees = entity.employees?.allObjects as? [EmployeeEntity] {
                Text("Employees:")
                    .bold()
                ForEach(employees) { employee in
                    Text(employee.name ?? "")
                }
            }
        })
        .padding()
        .frame(maxWidth: 300, alignment: .leading)
        .background(Color.green.opacity(0.5))
        .cornerRadius(10)
        .shadow(radius: 10)
    }
}

struct EmployeeView: View {
    
    let entity: EmployeeEntity
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20, content: {
            Text("Name: \(entity.name ?? "")")
                .bold()
            
            Text("Age: \(entity.age)")
            Text("Date joined: \(entity.dateJoined ?? Date())")
            
            Text("Business:")
                .bold()
            
            Text(entity.business?.name ?? "")
            
            Text("Department:")
                .bold()
            
            Text(entity.department?.name ?? "")
        })
        .padding()
        .frame(maxWidth: 300, alignment: .leading)
        .background(Color.blue.opacity(0.5))
        .cornerRadius(10)
        .shadow(radius: 10)
    }
}
