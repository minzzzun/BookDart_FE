//
//  NoticeListView.swift
//  BookDart_FE
//
//  Created by 김민준 on 1/19/26.
//

import SwiftUI

struct NoticeListView: View {
    
    @EnvironmentObject var router: NavigationRouter
    @StateObject private var viewModel = NoticeListViewModel()
    
    var body: some View {
        contentView
            .navigationTitle("공지사항")
            .onAppear {
                if viewModel.notices.isEmpty {
                    viewModel.loadNotices()
                }
            }
    }
    
    private var contentView: some View {
        Group {
            if viewModel.isLoading && viewModel.notices.isEmpty {
                LoadingView()
            } else if let error = viewModel.errorMessage, viewModel.notices.isEmpty {
                ErrorView(message: error, retryAction: viewModel.loadNotices)
            } else {
                noticeListContent
            }
        }
    }
    
    private var noticeListContent: some View {
        List {
            ForEach(viewModel.notices) { notice in
                NoticeCell(notice: notice)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        router.toNamed("/notice/detail", arguments: notice.id)
                    }
            }
        }
        .listStyle(.plain)
        .refreshable {
            viewModel.refresh()
        }
    }
}
