//
//  AppleSignInButton.swift
//  BookDart_FE
//
//  Created by 김민준 on 1/16/26.
//

import SwiftUI

struct AppleSignInButton: View {
    
    let action: () -> Void
    
    var body: some View {
        VStack(spacing: 16) {
            // Divider
            HStack {
                Rectangle()
                    .frame(height: 1)
                    .foregroundColor(.secondary.opacity(0.3))
                
                Text("또는")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Rectangle()
                    .frame(height: 1)
                    .foregroundColor(.secondary.opacity(0.3))
            }
            
            // Apple Login Button
            Button(action: action) {
                HStack {
                    Image(systemName: "apple.logo")
                    Text("Apple로 로그인")
                        .fontWeight(.medium)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(Color(.label))
                .foregroundColor(Color(.systemBackground))
                .cornerRadius(12)
            }
        }
    }
}
