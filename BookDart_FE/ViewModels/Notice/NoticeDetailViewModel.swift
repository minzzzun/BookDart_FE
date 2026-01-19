//
//  NoticeDetailViewModel.swift
//  BookDart_FE
//
//  Created by 김민준 on 1/19/26.
//

import Foundation
import Combine

@MainActor
final class NoticeDetailViewModel: ObservableObject {
    
    // MARK: - Published Properties
    
    @Published var notice: Notice?
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    // MARK: - Private Properties
    
    private let noticeManager = NoticeManager.shared
    
    // MARK: - Public Methods
    
    func loadNotice(id: Int) {
        isLoading = true
        errorMessage = nil
        
        noticeManager.fetchDetail(id: id) { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                self.isLoading = false
                
                switch result {
                case .success(let notice):
                    self.notice = notice
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }
}
