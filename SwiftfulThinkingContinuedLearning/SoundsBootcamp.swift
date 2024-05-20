//
//  SoundsBootcamp.swift
//  SwiftfulThinkingContinuedLearning
//
//  Created by Kritchanaxt_. on 22/5/2567 BE.
//

//MARK: การเล่นวิดีโอใน SwiftUI ด้วย AVKit
// นี่คือขั้นตอนพื้นฐาน
// ขั้นตอนที่ 1: เริ่มต้นด้วยการนำเข้าเฟรมเวิร์ค AVKit ในไฟล์ Swift ของคุณ
// ขั้นตอนที่ 2: สร้างอินสแตนซ์ของ AVPlayer ซึ่งจะใช้ในการเล่นวิดีโอ

// MARK: AVKit เป็นเฟรมเวิร์คของ Apple ที่ให้เครื่องมือและส่วนประกอบสำหรับการทำงานกับสื่อ (media) ทั้งวิดีโอและเสียง มันทำงานร่วมกับ AVFoundation ซึ่งเป็นเฟรมเวิร์คพื้นฐานที่มีความสามารถสูงในการจัดการสื่อ


import SwiftUI
import AVKit

class SoundManager {
    
    static let instance = SoundManager() // Signleton
    
    var player: AVAudioPlayer?
    
    enum SoundOption: String {
        case MILLION
        case Ben10
    }
    
    func playSound(sound: SoundOption) {
        
        guard let url = Bundle.main.url(forResource: sound.rawValue, withExtension: ".mp3") else { return }
        
        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.play()
        } catch let error {
            print("Error playing sound. \(error.localizedDescription)")
        }
    }
}

struct SoundsBootcamp: View {
    var body: some View {
        VStack(spacing: 40) {
            Button("Play sound 1") {
                SoundManager.instance.playSound(sound: .MILLION)
            }
            
            Button("Play sound 2") {
                SoundManager.instance.playSound(sound: .Ben10)
            }
        }
    }
}

#Preview {
    SoundsBootcamp()
}
