//
//  MultipleSheetsBootcamp.swift
//  SwiftfulThinkingContinuedLearning
//
//  Created by Kritchanaxt_. on 22/5/2567 BE.
//

//MARK: MultipleSheets
// การจัดการหลายๆ sheet เนื่องจาก SwiftUI ไม่ได้มีการจัดการหลายๆ sheet โดยตรงในตัว แต่เราสามารถใช้วิธีการบางอย่างเพื่อจัดการการแสดงผลของหลายๆ sheet ได้อย่างมีประสิทธิภาพ หนึ่งในวิธีที่นิยมใช้คือการสร้าง enum หรือ struct เพื่อกำหนด state ของ sheet ที่ต้องการแสดงผล

import SwiftUI

struct RandomModel: Identifiable {
    let id = UUID().uuidString
    let title: String
}

// 1 - use a binding
// 2 - use multiple .sheets
// 3 - use $item

struct MultipleSheetsBootcamp: View {
    
    @State var selectedModel: RandomModel? = nil
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                ForEach(0..<50) { index in
                    Button("Button \(index)") {
                        selectedModel = RandomModel(title: "\(index)")
                    }
                }
            }
            .sheet(item: $selectedModel) { model in
                NextScreen(selectedModel: model)
            }
        }
    }
    
    struct NextScreen: View {
        
        let selectedModel: RandomModel
        
        var body: some View {
            Text(selectedModel.title)
                .font(.largeTitle)
        }
    }
}

#Preview {
    MultipleSheetsBootcamp()
}
