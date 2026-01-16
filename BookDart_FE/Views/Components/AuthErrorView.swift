//
//  AuthErrorView.swift
//  BookDart_FE
//
//  Created by 김민준 on 1/16/26.
//

import SwiftUI

struct AuthErrorView: View {
    
    let message: String
    
    var body: some View {
        HStack {
            Image(systemName: "exclamationmark.circle.fill")
            Text(message)
        }
        .font(.subheadline)
        .foregroundColor(.red)
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(Color.red.opacity(0.1))
        .cornerRadius(8)
    }
}
