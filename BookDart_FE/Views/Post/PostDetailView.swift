//
//  PostDetailView.swift
//  BookDart_FE
//
//  Created by 김민준 on 1/18/26.
//

import SwiftUI

@MainActor
struct PostDetailView: View {
    
    @EnvironmentObject var router: NavigationRouter
    @StateObject private var viewModel = PostDetailViewModel()
    
    let postId: Int
    
    var body: some View {
        contentView
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: { router.back() }) {
                        Image(systemName: "chevron.left")
                    }
                }
            }
//            .onAppear { viewModel.loadPost(id: postId) }
            .task {
                viewModel.loadPost(id: postId)
            }
    }
    
    @ViewBuilder
    private var contentView: some View {
        if viewModel.isLoading {
            LoadingView()
        } else if let error = viewModel.errorMessage {
            ErrorView(message: error) {
                viewModel.loadPost(id: postId)
            }
        } else if let post = viewModel.post {
            PostContentView(post: post)
        } else {
            LoadingView()
        }
    }
}
