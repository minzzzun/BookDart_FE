//
//  AuthLinkButton.swift
//  BookDart_FE
//
//  Created by 김민준 on 1/16/26.
//

import SwiftUI

struct AuthLinkButton: View {
    
    let text: String
    let linkText: String
    let action: () -> Void
    
    var body: some View {
        HStack(spacing: 4) {
            Text(text)
                .foregroundColor(.secondary)
            
            Button(linkText, action: action)
                .foregroundColor(.accentColor)
                .fontWeight(.medium)
        }
        .font(.subheadline)
    }
}
