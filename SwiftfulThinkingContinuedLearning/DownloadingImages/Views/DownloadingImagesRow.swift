//
//  DownloadingImagesRow.swift
//  SwiftfulThinkingContinuedLearning
//
//  Created by Kritchanaxt_. on 1/6/2567 BE.
//

import SwiftUI

struct DownloadingImagesRow: View {
    
    let model: PhotoModel
    
    var body: some View {
        HStack {
            DownloadingImageView(url: model.url, key: "\(model.id)")
                .frame(width: 75, height: 75)
            VStack(alignment: .leading) {
                Text(model.title)
                    .font(.headline)
                Text(model.url)
                    .foregroundColor(.gray)
                    .italic()
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

#Preview {
    /*
     
     albumId: ไอดีของอัลบั้มที่รูปภาพเกี่ยวข้อง
     id: ไอดีของรูปภาพ
     title: ชื่อหัวข้อของรูปภาพ
     url: URL สำหรับดาวน์โหลดภาพใหญ่ขนาด 600x600 pixels
     thumbnailUrl: URL สำหรับดาวน์โหลดรูปย่อของภาพขนาด 600x600 pixels
     
     */
    
    DownloadingImagesRow(model: PhotoModel(albumId: 1, id: 1, title: "Title", url: "https://via.placeholder.com/600/92c952", thumbnailUrl: "https://via.placeholder.com/600/92c952"))
    
        // เพื่อเพิ่มระยะห่างรอบขอบ และกำหนด
        .padding()
    
        // ใช้เพื่อให้แสดงตัวอย่างขนาดที่เหมาะสมตามเนื้อที่ของข้อมูลในแถวที่สร้างขึ้นมาใหม่
        .previewLayout(.sizeThatFits)
}
