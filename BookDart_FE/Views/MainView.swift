//
//  MainView.swift
//  BookDart_FE
//
//  Created by 김민준 on 1/15/26.
//

import SwiftUI

struct MainView: View {
    
    @EnvironmentObject var router: NavigationRouter
    @EnvironmentObject var appState: AppStates
    
    //    var body: some View {
    //        PostListView()
    //            .navigationBarHidden(true)
    //    }
    
    var body: some View {
        VStack(spacing: 0) {
            Group {
                switch appState.selectedTab {
                case .home:
                    PostListView()
                case .notice:
                    NoticeListView()
                case .myPage:
                    MyPageView()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            CustomTabBar(selectedTab: $appState.selectedTab)
        }
        .navigationBarHidden(true)
    }
}
