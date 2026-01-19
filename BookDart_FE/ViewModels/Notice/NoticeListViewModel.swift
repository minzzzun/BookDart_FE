//
//  NoticeViewModel.swift
//  BookDart_FE
//
//  Created by 김민준 on 1/19/26.
//

import Foundation
import Combine

@MainActor
final class NoticeListViewModel: ObservableObject {
    
    //MARK: - Published
    @Published var notices: [Notice] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    private let noticeManager = NoticeManager.shared
    
    func loadNotices(){
        guard !isLoading else { return }
        
        isLoading = true
        errorMessage = nil
        
        noticeManager.fetchScrollList(cursor: nil, perpage: 20) { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                self.isLoading = false
                
                switch result {
                case .success(let notices):
                    self.notices = notices
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                }
                
            }
        }
        
        
    }
    
    func refresh(){
        notices = []
        loadNotices()
    }
    
    
}
