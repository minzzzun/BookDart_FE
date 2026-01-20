//
//  MyPageViewModel.swift
//  BookDart_FE
//
//  Created by 김민준 on 1/20/26.
//

import Foundation
import Combine

enum MyPageAlertType {
    case logout
    case deleteAccount
}

@MainActor
final class MyPageViewModel: ObservableObject {
    
    private let tokenManager = TokenManager.shared
    private let authManager = AuthManager.shared
    
    @Published var showAlert = false
    @Published var alertType: MyPageAlertType = .logout
    
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    var alertTitle: String {
        switch alertType {
        case .logout:
            return "로그아웃"
        case .deleteAccount:
            return "회원 탈퇴"
        }
    }
    
    var alertMessage: String {
        switch alertType {
        case .logout:
            return "로그아웃 하시겠습니까?"
        case .deleteAccount:
            return "탈퇴하시겠습니까?"
        }
    }
    
    func showLogoutAlert(){
        alertType = .logout
        showAlert = true
    }
    
    func showDeleteAccountAlert(){
        alertType = .deleteAccount
        showAlert = true
    }
    
    
    func logout(){
        tokenManager.clearTokens()
//        authManager.logout()
    }
    
    func deleteAccount() async {
        isLoading = true
        errorMessage = nil
        //TODO: 나중에 주석 삭제
        //        do {
        //            try await authManager.deleteAccount()
        //        } catch {
        //            errorMessage = "회원탈퇴에 실패했습니다."
        //        }
        //
        //        isLoading = false
        tokenManager.clearTokens()
        isLoading = false 
    }
    
    
}
