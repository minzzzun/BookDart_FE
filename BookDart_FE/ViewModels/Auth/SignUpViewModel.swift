//
//  SignUpViewModel.swift
//  BookDart_FE
//
//  Created by 김민준 on 1/16/26.
//

import Foundation
import SwiftUI
import Combine

@MainActor
final class SignUpViewModel: ObservableObject {
    
    // MARK: - Published Properties
    
    @Published var username: String = ""
    @Published var password: String = ""
    @Published var confirmPassword: String = ""
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var isSignUpSuccess: Bool = false
    
    // MARK: - Dependencies
    
    private let authManager = AuthManager.shared
    
    // MARK: - Computed Properties
    
    /// 비밀번호 일치 여부
    var isPasswordMatching: Bool {
        !password.isEmpty && password == confirmPassword
    }
    
    /// 비밀번호 불일치 메시지 표시 여부
    var showPasswordMismatch: Bool {
        !confirmPassword.isEmpty && !isPasswordMatching
    }
    
    /// 회원가입 버튼 활성화 여부
    var isSignUpButtonEnabled: Bool {
        !username.isEmpty && 
        !password.isEmpty && 
        isPasswordMatching && 
        !isLoading
    }
    
    // MARK: - Methods
    
    /// 회원가입 실행
    func signUp() {
        guard isSignUpButtonEnabled else { return }
        
        isLoading = true
        errorMessage = nil
        
        Task {
            defer { isLoading = false }
            
            do {
                _ = try await authManager.signUp(username: username, password: password)
                isSignUpSuccess = true
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
        confirmPassword = ""
        errorMessage = nil
    }
}
