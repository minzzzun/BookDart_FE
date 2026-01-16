//
//  AuthResponse.swift
//  BookDart_FE
//
//  Created by 김민준 on 1/16/26.
//

import Foundation


// MARK: - 회원가입 응답
struct SignUpResponse: Codable, Sendable {
    let id: Int
}

// MARK: - 인증 에러 타입
enum AuthError: LocalizedError, Sendable {
    case invalidCredentials
    case networkError(String)
    case tokenNotFound
    case signUpFailed
    case unknownError
    
    var errorDescription: String? {
        switch self {
        case .invalidCredentials:
            return "아이디 또는 비밀번호가 올바르지 않습니다."
        case .networkError(let message):
            return "네트워크 오류: \(message)"
        case .tokenNotFound:
            return "토큰을 찾을 수 없습니다."
        case .signUpFailed:
            return "회원가입에 실패했습니다."
        case .unknownError:
            return "알 수 없는 오류가 발생했습니다."
        }
    }
}
