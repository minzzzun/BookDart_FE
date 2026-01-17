//
//  PostListView.swift
//  BookDart_FE
//
//  Created by 김민준 on 1/18/26.
//

import SwiftUI

struct PostListView: View {
    
    @EnvironmentObject var router: NavigationRouter
    @StateObject private var viewModel = PostListViewModel()
    
    var body: some View {
        ZStack {
            contentView
            FABButton(icon: "plus") {
                router.toNamed("/post/create")
            }
        }
        .onAppear {
            if viewModel.posts.isEmpty {
                viewModel.loadInitialPosts()
            }
        }
    }
    
    @ViewBuilder
    private var contentView: some View {
        if viewModel.isLoading && viewModel.posts.isEmpty {
            LoadingView()
        } else if let error = viewModel.errorMessage, viewModel.posts.isEmpty {
            ErrorView(message: error, retryAction: viewModel.loadInitialPosts)
        } else {
            postListContent
        }
    }
    
    private var postListContent: some View {
        List {
            ForEach(viewModel.posts) { post in
                PostCell(post: post)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        router.toNamed("/post/detail", arguments: post.id)
                    }
                    .onAppear {
                        if post.id == viewModel.posts.last?.id {
                            viewModel.loadMorePosts()
                        }
                    }
            }
            
            if viewModel.isLoadingMore {
                LoadingMoreRow()
            }
        }
        .listStyle(.plain)
        .refreshable {
            viewModel.refresh()
        }
    }
}
