//
//  LoginViewModel.swift
//  BookDart_FE
//
//  Created by 김민준 on 1/16/26.
//

import Foundation
import Combine


@MainActor
final class LoginViewModel: ObservableObject {
    
    // MARK: - Published Properties
    
    @Published var username: String = ""
    @Published var password: String = ""
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var isLoginSuccess: Bool = false
    
    // MARK: - Dependencies
    
    private let authManager = AuthManager.shared
    
    // MARK: - Computed Properties
    
    /// 로그인 버튼 활성화 여부
    var isLoginButtonEnabled: Bool {
        !username.isEmpty && !password.isEmpty && !isLoading
    }
    
    // MARK: - Methods
    
    /// 로그인 실행
    func login() {
        guard isLoginButtonEnabled else { return }
        
        isLoading = true
        errorMessage = nil
        
        Task {
            defer { isLoading = false }
            
            do {
                try await authManager.login(username: username, password: password)
                isLoginSuccess = true
            } catch let error as AuthError {
                errorMessage = error.errorDescription
            } catch {
                errorMessage = "알 수 없는 오류가 발생했습니다."
            }
        }
    }
    
    /// 에러 메시지 초기화
    func clearError() {
        errorMessage = nil
    }
    
    /// 입력 필드 초기화
    func clearFields() {
        username = ""
        password = ""
        errorMessage = nil
    }
}
