//
//  PostDetailViewModel.swift
//  BookDart_FE
//
//  Created by 김민준 on 1/18/26.
//

import Foundation
import Combine

@MainActor
final class PostDetailViewModel: ObservableObject {
    
    // MARK: - Published Properties
    
    @Published var post: Post?
    @Published var isLoading: Bool = true
    @Published var errorMessage: String?
    
    // MARK: - Private Properties
    
    private let postManager = PostManager.shared
    
    // MARK: - Public Methods
    
    /// 게시글 상세 정보 로딩
    func loadPost(id: Int) {
//        guard !isLoading else { return }
        
        isLoading = true
        errorMessage = nil
        
        postManager.fetchDetail(id: id) { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                self.isLoading = false
                
                switch result {
                case .success(let post):
                    self.post = post
                    
                case .failure(let error):
                    self.errorMessage = error.errorDescription
                }
            }
        }
    }
    
    /// 에러 메시지 초기화
    func clearError() {
        errorMessage = nil
    }
}
