//
//  PostImageView.swift
//  BookDart_FE
//
//  Created by 김민준 on 1/18/26.
//

import SwiftUI

struct PostImageView: View {
    
    let imageURL: String?
    var height: CGFloat = 200
    
    var body: some View {
        if let urlString = imageURL, !urlString.isEmpty {
            // 추후 AsyncImage 또는 Kingfisher로 구현
            AsyncImage(url: URL(string: urlString)) { phase in
                switch phase {
                case .empty:
                    placeholderView
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(height: height)
                        .clipped()
                case .failure:
                    placeholderView
                @unknown default:
                    placeholderView
                }
            }
            .frame(height: height)
            .cornerRadius(12)
        } else {
            placeholderView
        }
    }
    
    private var placeholderView: some View {
        Rectangle()
            .fill(Color(.secondarySystemBackground))
            .frame(height: height)
            .cornerRadius(12)
            .overlay {
                Image(systemName: "book.fill")
                    .font(.system(size: 40))
                    .foregroundColor(.gray.opacity(0.5))
            }
    }
}
