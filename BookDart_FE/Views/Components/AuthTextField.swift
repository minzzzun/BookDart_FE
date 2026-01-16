//
//  AuthTextField.swift
//  BookDart_FE
//
//  Created by 김민준 on 1/16/26.
//

import SwiftUI

struct AuthTextField: View {
    
    let title: String
    let placeholder: String
    @Binding var text: String
    var isSecure: Bool = false
    var textContentType: UITextContentType? = nil
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundColor(.secondary)
            
            Group {
                if isSecure {
                    SecureField(placeholder, text: $text)
                } else {
                    TextField(placeholder, text: $text)
                        .autocapitalization(.none)
                }
            }
            .textFieldStyle(.plain)
            .padding()
            .background(Color(.secondarySystemBackground))
            .cornerRadius(12)
            .textContentType(textContentType)
        }
    }
}
