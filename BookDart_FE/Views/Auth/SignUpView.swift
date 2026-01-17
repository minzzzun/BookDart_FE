//
//  SignUpView.swift
//  BookDart_FE
//
//  Created by 김민준 on 1/15/26.
//

import SwiftUI

struct SignUpView: View {
    
    @EnvironmentObject var router: NavigationRouter
    @StateObject private var viewModel = SignUpViewModel()
    
    var body: some View {
        VStack(spacing: 0) {
            Spacer()
            
            headerSection
            
            Spacer().frame(height: 40)
            
            inputSection
            
            Spacer().frame(height: 24)
            
            if let error = viewModel.errorMessage {
                AuthErrorView(message: error)
            }
            
            Spacer().frame(height: 24)
            
            AuthButton(
                title: "회원가입",
                isEnabled: viewModel.isSignUpButtonEnabled,
                isLoading: viewModel.isLoading,
                action: viewModel.signUp
            )
            
            Spacer().frame(height: 16)
            
            AuthLinkButton(
                text: "이미 계정이 있으신가요?",
                linkText: "로그인",
                action: { router.back() }
            )
            
            Spacer()
        }
        .padding(.horizontal, 24)
        .background(Color(.systemBackground))
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: { router.back() }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.primary)
                }
            }
        }
        .navigationBarHidden(true)
        .onChange(of: viewModel.isSignUpSuccess) { _, success in
            if success {
                router.back()
            }
        }
    }
    
    // MARK: - Header
    
    private var headerSection: some View {
        VStack(spacing: 12) {
            Image(systemName: "person.badge.plus")
                .font(.system(size: 50))
                .foregroundColor(.accentColor)
            
            Text("회원가입")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Text("BookDart와 함께 독서를 기록하세요")
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
                textContentType: .newPassword
            )
            
            // 비밀번호 확인
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text("비밀번호 확인")
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(.secondary)
                    
                    Spacer()
                    
                    if !viewModel.confirmPassword.isEmpty {
                        passwordMatchIndicator
                    }
                }
                
                SecureField("비밀번호를 다시 입력하세요", text: $viewModel.confirmPassword)
                    .textFieldStyle(.plain)
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(12)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(
                                viewModel.showPasswordMismatch ? Color.red.opacity(0.5) : Color.clear,
                                lineWidth: 1
                            )
                    )
                    .textContentType(.newPassword)
            }
        }
    }
    
    private var passwordMatchIndicator: some View {
        HStack(spacing: 4) {
            Image(systemName: viewModel.isPasswordMatching ? "checkmark.circle.fill" : "xmark.circle.fill")
            Text(viewModel.isPasswordMatching ? "일치" : "불일치")
        }
        .font(.caption)
        .foregroundColor(viewModel.isPasswordMatching ? .green : .red)
    }
}
