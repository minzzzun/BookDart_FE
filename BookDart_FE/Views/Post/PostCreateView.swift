//
//  PostCreateView.swift
//  BookDart_FE
//
//  Created by 김민준 on 1/18/26.
//

import SwiftUI

struct PostCreateView: View {
    
    @EnvironmentObject var router: NavigationRouter
    @StateObject private var viewModel = PostCreateViewModel()
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                ScanPreviewView(
                    image: viewModel.capturedImage,
                    isRecognizing: viewModel.isRecognizing,
                    onRescan: viewModel.startScanning
                )
                
                if viewModel.capturedImage == nil {
                    ScanButton(action: viewModel.startScanning)
                }
                
                PostTitleField(title: $viewModel.title)
                
                PostContentField(content: $viewModel.content)
                
                if let error = viewModel.errorMessage {
                    Text(error)
                        .font(.caption)
                        .foregroundColor(.red)
                }
                
                SubmitButton(
                    title: "등록하기",
                    isEnabled: viewModel.isSubmitButtonEnabled,
                    isLoading: viewModel.isSubmitting,
                    action: viewModel.submitPost
                )
            }
            .padding()
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("새 게시글")
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: { router.back() }) {
                    Image(systemName: "chevron.left")
                }
            }
        }
        .fullScreenCover(isPresented: $viewModel.isScanning) {
            ScannerSheet(
                onCapture: viewModel.handleScannedImage,
                onCancel: viewModel.cancelScanning
            )
        }
        .onChange(of: viewModel.isCreateSuccess) { _, success in
            if success { router.back() }
        }
    }
}
