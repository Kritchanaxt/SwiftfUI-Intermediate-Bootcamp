//
//  SubscriberBootcamp.swift
//  SwiftfulThinkingContinuedLearning
//
//  Created by Kritchanaxt_. on 30/5/2567 BE.
//

/*
 
 MARK: Subscriber
 - เป็นส่วนหนึ่งของการทำงานกับ Publisher-Subscriber pattern ซึ่ง Subscriber
 - ใช้ในการสมัครสมาชิกและรับค่าจาก Publisher
 - โดยมีหน้าที่รับข้อมูลที่ส่งมาจาก Publisher และประมวลผลตามต้องการ แต่ละ Subscriber
 สามารถรับและจัดการข้อมูลได้ตามต้องการของแต่ละซับสแคริเบอร์

 MARK: แบ่งออกเป็นขั้นตอนหลัก ๆ ดังนี้:
 1. สมัครสมาชิกกับ Publisher: ใช้เมธอด sink เพื่อสมัครสมาชิกกับ Publisher โดยระบุว่าจะประมวลผลข้อมูลอย่างไร เช่น การรับค่า, การจัดการข้อผิดพลาด เป็นต้น

 2. รับข้อมูล: Subscriber จะได้รับข้อมูลจาก Publisher ผ่านทางการเรียกเมธอด receiveValue หรือผ่านการประมวลผลข้อผิดพลาด หากมีการจัดการข้อผิดพลาด
 
 */

import SwiftUI
import Combine

class SubscriberViewModel: ObservableObject {
    
    @Published var count: Int = 0
    
    // เป็นชุดของ AnyCancellable ที่ใช้เก็บการสมัครสมาชิกเพื่อสามารถยกเลิกได้เมื่อไม่จำเป็นต้องใช้งานแล้ว.
    var cancellables = Set<AnyCancellable>()
    
    @Published var textFieldText: String = ""
    @Published var textIsVaild: Bool = false
    
    @Published var showButton: Bool = false
    
    // สร้าง (initializer) เรียกใช้ฟังก์ชันสามตัวเพื่อเริ่มต้นการสมัครสมาชิก.
    init() {
        addTextFieldSubscriber()
        setUpTimer()
        addButtonSubscriber()
    }
    
    // ฟังก์ชันที่สมัครสมาชิกการเปลี่ยนแปลงของ textFieldText.
    func addTextFieldSubscriber() {
        $textFieldText
        
            // ใช้ debounce เพื่อรอ 0.5 วินาทีหลังจากการเปลี่ยนแปลงล่าสุดของข้อความก่อนที่จะดำเนินการต่อ.
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .map { (text) -> Bool in
                
                // แปลงข้อความเป็นบูลีน (Bool) ที่บ่งชี้ว่าข้อความมีความยาวเกิน 6 ตัวอักษรหรือไม่.
                if text.count > 6 {
                    return true
                }
                return false
            }
//            .assign(to: \.textIsVaild, on: self)
            .sink(receiveValue: { [weak self] (isVaild) in
                
                // อัปเดต textIsVaild ตามค่าที่ได้รับ.
                self?.textIsVaild = isVaild
            })
            .store(in: &cancellables)
    }
    
    // ฟังก์ชันที่สร้างตัวจับเวลา (timer) ที่เพิ่ม count ทุกๆ วินาที.
    func setUpTimer() {
        Timer
            .publish(every: 1, on: .main, in: .common)
        
            // ใช้ autoconnect เพื่อเริ่มตัวจับเวลาโดยอัตโนมัติ.
            .autoconnect()
            .sink { [weak self] _ in
                guard let self = self else { return }
                self.count += 1
            }
            .store(in: &cancellables)
    }
    
    // ฟังก์ชันที่สมัครสมาชิกการเปลี่ยนแปลงของ textIsVaild และ count.
    func addButtonSubscriber() {
        $textIsVaild
        
            // ใช้ combineLatest เพื่อรวมค่าล่าสุดจาก textIsVaild และ count.
            .combineLatest($count)
        
            // อัปเดต showButton เป็น true ถ้า textIsVaild เป็น true และ count มากกว่าหรือเท่ากับ 10, มิฉะนั้นตั้งค่าเป็น false.
            .sink { [weak self] (isVaild, count) in
                guard let self = self else { return }
                if isVaild && count >= 10 {
                    self.showButton = true
                } else {
                    self.showButton = false
                }
            }
            .store(in: &cancellables)
    }
}

struct SubscriberBootcamp: View {
    
    @StateObject var vm = SubscriberViewModel()
    
    var body: some View {
        VStack {
            Text("\(vm.count)")
                .font(.largeTitle)
            
            TextField("Type something here...", text: $vm.textFieldText)
                .padding(.leading)
                .frame(height: 55)
                .font(.headline)
                .background(Color(#colorLiteral(red: 0.921431005, green: 0.9214526415, blue: 0.9214410186, alpha: 1)))
                .cornerRadius(10)
                .overlay(
                    ZStack {
                        Image(systemName: "xmark")
                            .foregroundColor(.red)
                            .opacity(
                                vm.textFieldText.count < 1 ? 0.0 :
                                vm.textIsVaild ? 0.0 : 1.0)
                        
                        Image(systemName: "checkmark")
                            .foregroundColor(.green)
                            .opacity(vm.textIsVaild ? 1.0 : 0.0)
                    }
                    .font(.title)
                    .padding(.trailing)
                    
                    , alignment: .trailing
                )
            
            Button(action: {}, label: {
                Text("Submit".uppercased())
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(height: 55)
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .cornerRadius(10)
                    .opacity(vm.showButton ? 1.0 : 0.5)
            })
            .disabled(!vm.showButton)
        }
        .padding()
        .padding()
    }
}

#Preview {
    SubscriberBootcamp()
}
