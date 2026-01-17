//
//  MainView.swift
//  BookDart_FE
//
//  Created by 김민준 on 1/15/26.
//

import SwiftUI

struct MainView: View {
    
    @EnvironmentObject var router: NavigationRouter
    
    var body: some View {
        PostListView()
            .navigationBarHidden(true)
    }
}
