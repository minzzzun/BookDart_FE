//
//  AuthStateViewModel.swift
//  BookDart_FE
//
//  Created by 김민준 on 1/17/26.
//

import Foundation
import Combine
import SwiftUI


// 앱 진입 전 로그인 여부 확인
@MainActor
final class AuthStateViewModel: ObservableObject {
    @Published var isLoggedIn: Bool
    
    private let tokenManager = TokenManager.shared
    
    init(){
        self.isLoggedIn = tokenManager.isLoggedIn
    }
    
    func refreshAuthState(){
        isLoggedIn = tokenManager.isLoggedIn
    }
    
}
