//
//  AppStates.swift
//  BookDart_FE
//
//  Created by 김민준 on 1/19/26.
//

import SwiftUI
import Combine

enum Tab {
    case home
    case notice
    case myPage
}

@MainActor
class AppStates: ObservableObject {
    @Published var selectedTab: Tab = .home
}
