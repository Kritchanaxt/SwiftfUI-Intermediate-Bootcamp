//
//  ArraysBootcamp.swift
//  SwiftfulThinkingContinuedLearning
//
//  Created by Kritchanaxt_. on 23/5/2567 BE.
//

import SwiftUI

struct UserModel: Identifiable {
    let id = UUID().uuidString
    let name: String?
    let points: Int
    let isVerified: Bool
}

class ArraysModificationViewModel: ObservableObject {
    
    // การใช้อาเรย์ใน @Published ใช้สำหรับเก็บข้อมูลที่อาจมีจำนวนตัวแปรที่เปลี่ยนแปลงได้ตลอดเวลา หรืออาจมีการเพิ่มหรือลบข้อมูลได้ตามความต้องการ
    @Published var dataArray: [UserModel] = []
    @Published var filteredArray: [UserModel] = []
    @Published var mappedArray: [String] = []
    
    init() {
        getUsers()
        updateFilteredArray()
    }
    
    func updateFilteredArray() {
        // MARK: Sort (เรียงลำดับโดยให้เงื่อนไข)
//        filteredArray = dataArray.sorted { (user1, user2) -> Bool in
//            return user1.points > user2.points
//        }
//        
//        filteredArray = dataArray.sorted(by: { $0.points < $1.points })
     
        // MARK: Filter (กรองข้อมูลโดยให้เงื่อนไข)
//        filteredArray = dataArray.filter({ (user) -> Bool in
//            return user.isVerified
//        })
//        
//        filteredArray = dataArray.filter({ $0.isVerified })
//        
        // MARK: Map (แปลงค่าข้อมูลใช้เงื่อนไข)

        // Exam: 1
//        mappedArray = dataArray.map({ (user) -> String in
//            return user.name ?? "ERROR"
//        })
//        mappedArray = dataArray.map({ $0.name ?? "ERROR" })
        
        // Exam: 2
//        mappedArray = dataArray.compactMap({ (user) -> String? in
//            return user.name
//        })
//        
//        mappedArray = dataArray.compactMap({ $0.name })
        
        // Exam: 3
          mappedArray = dataArray
                           .sorted(by: { $0.points > $1.points }) // หา user เลขคี่
                           .filter({ $0.isVerified }) // กรองและแสดงเฉพาะผู้ใช้ที่ผ่านการตรวจสอบ isVerified
                           .compactMap({ $0.name }) // แปลงค่าในอาร์เรย์ โดยจะคืนค่าเฉพาะชื่อที่ไม่เป็น nil เท่านั้น

    }
    
    func getUsers() {
        let user1 = UserModel(name: "Nick", points: 5, isVerified: true)
        let user2 = UserModel(name: "Chris", points: 0, isVerified: false)
        let user3 = UserModel(name: nil, points: 20, isVerified: true)
        let user4 = UserModel(name: "Emily", points: 50, isVerified: false)
        let user5 = UserModel(name: "Samantha", points: 45, isVerified: true)
        let user6 = UserModel(name: "Jason", points: 23, isVerified: false)
        let user7 = UserModel(name: "Sarah", points: 76, isVerified: true)
        let user8 = UserModel(name: nil, points: 45, isVerified: false)
        let user9 = UserModel(name: "Steve", points: 1, isVerified: true)
        let user10 = UserModel(name: "Amanda", points: 100, isVerified: false)
        self.dataArray.append(contentsOf: [
            user1,
            user2,
            user3,
            user4,
            user5,
            user6,
            user7,
            user8,
            user9,
            user10,
        ])
    }
}

struct ArraysBootcamp: View {
    
    @StateObject var vm = ArraysModificationViewModel()
    
    var body: some View {
        ScrollView {
            VStack(spacing: 10) {
                ForEach(vm.mappedArray, id: \.self) { name in
                    Text(name)
                        .font(.title)
                }
                
                ForEach(vm.filteredArray) { user in
                    VStack(alignment: .leading) {
                        Text(user.name ?? "Unknown User")
                            .font(.headline)
                        HStack {
                            Text("Pionts: \(user.points)")
                            Spacer()
                            if user.isVerified {
                                Image(systemName: "flame.fill")
                            }
                        }
                    }
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue.cornerRadius(10))
                    .padding(.horizontal)
                }
            }
        }
    }
}

#Preview {
    ArraysBootcamp()
}
