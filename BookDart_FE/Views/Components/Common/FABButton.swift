//
//  FABButton.swift
//  BookDart_FE
//
//  Created by 김민준 on 1/19/26.
//

import SwiftUI

struct FABButton: View {
    
    let icon: String
    let action: () -> Void
    
    var body: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                Button(action: action) {
                    Image(systemName: icon)
                        .font(.system(size: 24, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(width: 56, height: 56)
                        .background(Color.accentColor)
                        .clipShape(Circle())
                        .shadow(color: .black.opacity(0.2), radius: 4, x: 0, y: 2)
                }
                .padding(.trailing, 20)
                .padding(.bottom, 20)
            }
        }
    }
}

#Preview {
    ZStack {
        Color.gray.opacity(0.1)
        FABButton(icon: "plus") {
            print("FAB tapped")
        }
    }
}
