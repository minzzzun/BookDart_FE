//
//  PostContentView.swift
//  BookDart_FE
//
//  Created by 김민준 on 1/19/26.
//

import SwiftUI

struct PostContentView: View {
    
    let post: Post
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                // 이미지
                if let imageUrl = post.img, !imageUrl.isEmpty {
                    AsyncImage(url: URL(string: imageUrl)) { phase in
                        switch phase {
                        case .empty:
                            ProgressView()
                                .frame(maxWidth: .infinity)
                                .frame(height: 250)
                        case .success(let image):
                            image
                                .resizable()
                                .scaledToFit()
                                .frame(maxWidth: .infinity)
                        case .failure:
                            Image(systemName: "photo")
                                .font(.system(size: 50))
                                .foregroundColor(.gray)
                                .frame(maxWidth: .infinity)
                                .frame(height: 250)
                        @unknown default:
                            EmptyView()
                        }
                    }
                }
                
                VStack(alignment: .leading, spacing: 12) {
                    // 제목
                    Text(post.title ?? "제목 없음")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    // 날짜
                    Text(post.formattedDate)
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Divider()
                    
                    // 내용
                    Text(post.content ?? "내용 없음")
                        .font(.body)
                        .lineSpacing(6)
                }
                .padding(.horizontal, 20)
            }
            .padding(.vertical, 16)
        }
    }
}
