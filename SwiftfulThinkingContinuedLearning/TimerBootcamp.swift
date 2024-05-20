//
//  TimerBootcamp.swift
//  SwiftfulThinkingContinuedLearning
//
//  Created by Kritchanaxt_. on 28/5/2567 BE.
//

// MARK: Timer
// คือคลาสที่ใช้ในการสร้างตัวจับเวลา (timer) ซึ่งสามารถใช้ในการเรียกใช้งานโค้ดบางส่วนเป็นระยะเวลาตามที่กำหนด สามารถใช้ในการสร้างแจ้งเตือนหรือการเรียกใช้โค้ดที่ต้องการให้ทำงานตามระยะเวลาที่กำหนดได้โดยอัตโนมัติ

import SwiftUI

struct TimerBootcamp: View {
    
    let timer = Timer.publish(every: 1.0, on: .main, in: .common).autoconnect()
    
    // MARK: Current Time
    /*
     // ใช้เพื่อบอกว่า currentDate เป็นสถานะของ view ที่ควรจัดเก็บและสังเกตการเปลี่ยนแปลง.
    @State var currentDate: Date = Date()
     
     // บรรทัดนี้ประกาศตัวแปร dateFormatter ซึ่งเป็น computed property ที่คืนค่า DateFormatter.
    var dateFormatter: DateFormatter {
     
     //สร้างอินสแตนซ์ของ DateFormatter.
        let formatter = DateFormatter()
     
     // จะทำให้แสดงทั้งวันที่และเวลาในรูปแบบกลาง (medium style) สำหรับทั้งสอง.
//        formatter.dateStyle = .medium
     
     // กำหนดรูปแบบการแสดงผลเวลาให้เป็นสไตล์ medium (สไตล์กลาง ๆ ที่แสดงเวลาเช่น "3:45:32 PM").
        formatter.timeStyle = .medium
     
        return formatter
     
        }
     */
    
    // MARK:  Countdown
    /*
        @State var count: Int = 10
        @State var finishedText: String? = nil
     */
    
    // MARK: Countdown to date
    /*
     
     // ตัวแปรนี้จะถูกใช้งานเพื่อเก็บข้อความที่แสดงเวลาที่เหลือ.
       @State var timeRemaining: String = ""
     
     // ใช้เพื่อคำนวณวันที่และเวลาที่เพิ่มขึ้นอีก 1 ชั่วโมงจากเวลาปัจจุบัน. ถ้าการคำนวณนี้ล้มเหลว, จะใช้เวลาปัจจุบัน (Date()) แทน.
       let futureDate: Date = Calendar.current.date(byAdding: .hour, value: 1, to: Date()) ?? Date()
       
       func updateTimeRemaining() {
     
     // ใช้เพื่อคำนวณเวลาที่เหลือระหว่างเวลาปัจจุบัน (Date()) และ futureDate.
     // ผลลัพธ์จะเป็น DateComponents ที่มีข้อมูลเกี่ยวกับนาที (minute) และวินาที (second).
           let remaining = Calendar.current.dateComponents([.minute, .second], from: Date(), to: futureDate)
     
     // ดึงค่าของนาทีที่เหลือจาก remaining และถ้าไม่มีค่า (nil), จะตั้งค่าเป็น 0.
           let minute = remaining.minute ?? 0
           let second = remaining.second ?? 0
     
     // อัปเดตค่า timeRemaining ให้เป็นสตริงที่แสดงเวลาที่เหลือในรูปแบบ "X minutes, Y seconds".
           timeRemaining = "\(minute) minutes, \(second) seconds"
       }
     
     */
    
    // Animation counter
    @State var count: Int = 1
    
    var body: some View {
        ZStack {
            RadialGradient(
                gradient: Gradient(colors: [Color(#colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1)), Color(#colorLiteral(red: 0.09019608051, green: 0, blue: 0.3019607961, alpha: 1))]),
                center: .center,
                startRadius: 5,
                endRadius: 500)
                .ignoresSafeArea()
            
//            Text(currentDate.description)
//            Text(dateFormatter.string(from: currentDate))
//            Text(finishedText ?? "\(count)")
//            Text(timeRemaining)
//                .font(.system(size: 100, weight: .semibold, design: .rounded))
//                .foregroundColor(.white)
//                .lineLimit(1)
//                .minimumScaleFactor(0.1)

            
            /*
            HStack(spacing: 15) {
                Circle()
                    .offset(y: count == 1 ? -20 : 0)
                Circle()
                    .offset(y: count == 2 ? -20 : 0)
                Circle()
                    .offset(y: count == 3 ? -20 : 0)
            }
            .frame(width: 150)
            .foregroundColor(.white)
            */
            
            TabView(selection: $count,
                    content:  {
                        Rectangle()
                            .foregroundColor(.red)
                            .tag(1)
                        Rectangle()
                            .foregroundColor(.blue)
                            .tag(2)
                        Rectangle()
                            .foregroundColor(.green)
                            .tag(3)
                        Rectangle()
                            .foregroundColor(.orange)
                            .tag(4)
                        Rectangle()
                            .foregroundColor(.pink)
                            .tag(5)
                    })
                    .frame(height: 200)
                    .tabViewStyle(PageTabViewStyle())
        }
        
//        .onReceive(timer, perform: { value in
//            currentDate = value
//        })
        
//        .onReceive(timer, perform: { _ in
//            if count <= 1 {
//                finishedText = "Boom!!"
//            } else {
//                count -= 1
//            }
//        })
        
//        .onReceive(timer, perform: { _ in
//            updateTimeRemaining()
//        })
        
        .onReceive(timer, perform: { _ in
            withAnimation(.easeInOut(duration: 0.5)) {
                count = count == 3 ? 0 : count + 1
            }
        })
    }
}

#Preview {
    TimerBootcamp()
}
