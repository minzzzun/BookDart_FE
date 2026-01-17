//
//  PostContentView.swift
//  BookDart_FE
//
//  Created by 김민준 on 1/18/26.
//

import SwiftUI

struct PostContentView: View {
    
    let post: Post
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                PostImageView(imageURL: post.img, height: 250)
                
                Text(post.title ?? "제목 없음")
                    .font(.title2)
                    .fontWeight(.bold)
                
                Text(post.formattedDate)
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Divider()
                
                Text(post.content ?? "")
                    .font(.body)
                    .lineSpacing(6)
            }
            .padding()
        }
    }
}
