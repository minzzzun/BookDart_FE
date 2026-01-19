//
//  NoticeContentView.swift
//  BookDart_FE
//
//  Created by 김민준 on 1/19/26.
//

import SwiftUI

struct NoticeContentView: View {
    
    let notice: Notice
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                VStack(alignment: .leading, spacing: 12) {
                    HStack(spacing: 8) {
                        if notice.pinned == true {
                            Text("고정")
                                .font(.caption)
                                .fontWeight(.medium)
                                .foregroundColor(.white)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(Color.blue)
                                .cornerRadius(4)
                        }
                        
                        Text("공지사항")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    Text(notice.title ?? "제목 없음")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    if let createdAt = notice.createdAt {
                        Text(createdAt)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    Divider()
                    
                    Text(notice.content ?? "내용 없음")
                        .font(.body)
                        .lineSpacing(6)
                }
                .padding(.horizontal, 20)
            }
            .padding(.vertical, 16)
        }
    }
}
