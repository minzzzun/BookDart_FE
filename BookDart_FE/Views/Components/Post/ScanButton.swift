//
//  ScanButton.swift
//  BookDart_FE
//
//  Created by 김민준 on 1/18/26.
//

import SwiftUI

struct ScanButton: View {
    
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Label("카메라로 텍스트 스캔", systemImage: "camera.viewfinder")
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.accentColor.opacity(0.1))
                .foregroundColor(.accentColor)
                .cornerRadius(12)
        }
    }
}
