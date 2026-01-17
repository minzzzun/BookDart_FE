//
//  PostListViewModel.swift
//  BookDart_FE
//
//  Created by 김민준 on 1/18/26.
//

import Foundation
import Combine

@MainActor
final class PostListViewModel: ObservableObject {
    
    // MARK: - Published Properties
    
    @Published var posts: [Post] = []
    @Published var isLoading: Bool = false
    @Published var isLoadingMore: Bool = false
    @Published var hasMoreData: Bool = true
    @Published var errorMessage: String?
    
    // MARK: - Private Properties
    
    private let postManager = PostManager.shared
    private let perpage = 10
    
    private var cursor: Int? {
        posts.last?.id
    }
    
    // MARK: - Public Methods
    
    /// 초기 게시글 목록 로딩
    func loadInitialPosts() {
        guard !isLoading else { return }
        
        isLoading = true
        errorMessage = nil
        
        postManager.fetchScrollList(cursor: nil, perpage: perpage) { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                self.isLoading = false
                
                switch result {
                case .success(let posts):
                    self.posts = posts
                    self.hasMoreData = posts.count >= self.perpage
                    
                case .failure(let error):
                    self.errorMessage = error.errorDescription
                }
            }
        }
    }
    
    /// 추가 게시글 로딩 (무한 스크롤)
    func loadMorePosts() {
        guard !isLoadingMore, !isLoading, hasMoreData else { return }
        
        isLoadingMore = true
        
        postManager.fetchScrollList(cursor: cursor, perpage: perpage) { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                self.isLoadingMore = false
                
                switch result {
                case .success(let newPosts):
                    self.posts.append(contentsOf: newPosts)
                    self.hasMoreData = newPosts.count >= self.perpage
                    
                case .failure(let error):
                    self.errorMessage = error.errorDescription
                }
            }
        }
    }
    
    /// 새로고침
    func refresh() {
        posts = []
        hasMoreData = true
        loadInitialPosts()
    }
    
    /// 에러 메시지 초기화
    func clearError() {
        errorMessage = nil
    }
}
