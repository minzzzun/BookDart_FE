//
//  ScanPreviewView.swift
//  BookDart_FE
//
//  Created by 김민준 on 1/18/26.
//

import SwiftUI

struct ScanPreviewView: View {
    
    let image: UIImage?
    let isRecognizing: Bool
    let onRescan: () -> Void
    
    var body: some View {
        VStack(spacing: 12) {
            if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxHeight: 200)
                    .cornerRadius(12)
                    .overlay {
                        if isRecognizing {
                            recognizingOverlay
                        }
                    }
                
                Button(action: onRescan) {
                    Label("다시 스캔", systemImage: "camera.viewfinder")
                        .font(.subheadline)
                }
                .disabled(isRecognizing)
            } else {
                emptyStateView
            }
        }
    }
    
    private var recognizingOverlay: some View {
        ZStack {
            Color.black.opacity(0.5)
                .cornerRadius(12)
            
            VStack(spacing: 8) {
                ProgressView()
                    .tint(.white)
                Text("텍스트 인식 중...")
                    .font(.caption)
                    .foregroundColor(.white)
            }
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 8) {
            Image(systemName: "doc.text.viewfinder")
                .font(.system(size: 40))
                .foregroundColor(.gray)
            
            Text("스캔된 이미지가 없습니다")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .frame(height: 150)
    }
}
