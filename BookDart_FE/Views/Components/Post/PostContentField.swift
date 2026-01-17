//
//  PostContentField.swift
//  BookDart_FE
//
//  Created by 김민준 on 1/18/26.
//

import SwiftUI

struct PostContentField: View {
    
    @Binding var content: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("내용")
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundColor(.secondary)
            
            TextEditor(text: $content)
                .frame(minHeight: 150)
                .padding(8)
                .background(Color(.secondarySystemBackground))
                .cornerRadius(12)
        }
    }
}
