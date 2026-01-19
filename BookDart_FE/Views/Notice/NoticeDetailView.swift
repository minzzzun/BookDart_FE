//
//  NoticeDetailView.swift
//  BookDart_FE
//
//  Created by 김민준 on 1/19/26.
//

import SwiftUI

struct NoticeDetailView: View {
    
    @EnvironmentObject var router: NavigationRouter
    @StateObject private var viewModel = NoticeDetailViewModel()
    
    let noticeId: Int
    
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
            .onAppear {
                viewModel.loadNotice(id: noticeId)
            }
    }
    
    private var contentView: some View {
        Group {
            if viewModel.isLoading {
                LoadingView()
            } else if let error = viewModel.errorMessage {
                ErrorView(message: error) {
                    viewModel.loadNotice(id: noticeId)
                }
            } else if let notice = viewModel.notice {
                NoticeContentView(notice: notice)
            } else {
                LoadingView()
            }
        }
    }
}
