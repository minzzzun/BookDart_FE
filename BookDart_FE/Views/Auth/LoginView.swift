//
//  LoginView.swift
//  BookDart_FE
//
//  Created by 김민준 on 1/15/26.
//

import SwiftUI

struct LoginView: View {
    
    @EnvironmentObject var router: NavigationRouter
    @StateObject private var viewModel = LoginViewModel()
    
    var body: some View {
        VStack(spacing: 0) {
            Spacer()
            
            headerSection
            
            Spacer().frame(height: 48)
            
            inputSection
            
            Spacer().frame(height: 24)
            
            if let error = viewModel.errorMessage {
                AuthErrorView(message: error)
            }
            
            Spacer().frame(height: 24)
            
            AuthButton(
                title: "로그인",
                isEnabled: viewModel.isLoginButtonEnabled,
                isLoading: viewModel.isLoading,
                action: viewModel.login
            )
            
            Spacer().frame(height: 16)
            
            AuthLinkButton(
                text: "계정이 없으신가요?",
                linkText: "회원가입",
                action: { router.toNamed("/signup") }
            )
            
            Spacer()
            
            AppleSignInButton {
                // TODO: Apple Login 구현
            }
            
            Spacer().frame(height: 32)
        }
        .padding(.horizontal, 24)
        .background(Color(.systemBackground))
        .onChange(of: viewModel.isLoginSuccess) { _, success in
            if success {
                router.offAll("/")
            }
        }
    }
    
    // MARK: - Header
    
    private var headerSection: some View {
        VStack(spacing: 12) {
            Image(systemName: "book.fill")
                .font(.system(size: 60))
                .foregroundColor(.accentColor)
            
            Text("BookDart")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Text("독서의 순간을 기록하세요")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
    }
    
    // MARK: - Input
    
    private var inputSection: some View {
        VStack(spacing: 16) {
            AuthTextField(
                title: "아이디",
                placeholder: "아이디를 입력하세요",
                text: $viewModel.username,
                textContentType: .username
            )
            
            AuthTextField(
                title: "비밀번호",
                placeholder: "비밀번호를 입력하세요",
                text: $viewModel.password,
                isSecure: true,
                textContentType: .password
            )
        }
    }
}
