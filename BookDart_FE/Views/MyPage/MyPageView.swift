import SwiftUI

@MainActor
struct MyPageView: View {
    
    @StateObject private var viewModel = MyPageViewModel()
    @EnvironmentObject var authState: AuthStateViewModel
    @EnvironmentObject var router: NavigationRouter
    
    // 에러 Alert용 별도 상태
    @State private var showErrorAlert = false
    
    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            
            // 로그아웃 버튼
            Button(action: {
                viewModel.showLogoutAlert()
            }) {
                Text("로그아웃")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding(.horizontal, 20)
            
            // 회원 탈퇴 버튼
            Button(action: {
                viewModel.showDeleteAccountAlert()
            }) {
                Text("회원 탈퇴")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .foregroundColor(.red)
            }
            .padding(.horizontal, 20)
            
            Spacer()
        }
        .overlay {
            if viewModel.isLoading {
                ProgressView()
                    .scaleEffect(1.5)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.black.opacity(0.3))
            }
        }
        // 로그아웃/회원탈퇴 확인 Alert
        .alert(viewModel.alertTitle, isPresented: $viewModel.showAlert) {
            Button("취소", role: .cancel) { }
            
            Button(viewModel.alertType == .logout ? "로그아웃" : "탈퇴", role: .destructive) {
                handleAlertConfirm()
            }
        } message: {
            Text(viewModel.alertMessage)
        }
        // 에러 Alert - 수정된 바인딩
        .alert("오류", isPresented: $showErrorAlert) {
            Button("확인") {
                viewModel.errorMessage = nil
            }
        } message: {
            Text(viewModel.errorMessage ?? "")
        }
        // errorMessage 변경 감지
        .onChange(of: viewModel.errorMessage) { _, newValue in
            showErrorAlert = newValue != nil
        }
    }
    
    // MARK: - Private Methods
    private func handleAlertConfirm() {
        switch viewModel.alertType {
        case .logout:
            // DispatchQueue.main.async로 명시적 메인 스레드 실행
            DispatchQueue.main.async {
                viewModel.logout()
                router.path.removeAll()
                authState.refreshAuthState()
            }
            
        case .deleteAccount:
            Task { @MainActor in
                await viewModel.deleteAccount()
                if viewModel.errorMessage == nil {
                    router.path.removeAll()
                    authState.refreshAuthState()
                }
            }
        }
    }
}
