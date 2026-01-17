//
//  PostTitleField.swift
//  BookDart_FE
//
//  Created by 김민준 on 1/18/26.
//

import SwiftUI

struct PostTitleField: View {
    
    @Binding var title: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("제목")
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundColor(.secondary)
            
            TextField("제목을 입력하세요", text: $title)
                .textFieldStyle(.plain)
                .padding()
                .background(Color(.secondarySystemBackground))
                .cornerRadius(12)
        }
    }
}
