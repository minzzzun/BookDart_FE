//
//  PostCell.swift
//  BookDart_FE
//
//  Created by 김민준 on 1/18/26.
//

import SwiftUI

struct PostCell: View {
    
    let post: Post
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // 제목
            Text(post.title ?? "제목 없음")
                .font(.headline)
                .foregroundColor(.primary)
                .lineLimit(1)
            
            // 내용 미리보기
            Text(post.contentPreview)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .lineLimit(2)
            
            // 날짜
            Text(post.formattedDate)
                .font(.caption)
                .foregroundColor(.gray)
        }
        .padding(.vertical, 8)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
