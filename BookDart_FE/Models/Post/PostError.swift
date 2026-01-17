//
//  PostError.swift
//  BookDart_FE
//
//  Created by 김민준 on 1/18/26.
//

import Foundation

// MARK: - Post Error

enum PostError: LocalizedError, Sendable {
    case networkError(String)
    case unauthorized
    case notFound
    case createFailed
    case decodingError
    case unknownError
    
    var errorDescription: String? {
        switch self {
        case .networkError(let message):
            return "네트워크 오류: \(message)"
        case .unauthorized:
            return "인증이 필요합니다. 다시 로그인해주세요."
        case .notFound:
            return "게시글을 찾을 수 없습니다."
        case .createFailed:
            return "게시글 작성에 실패했습니다."
        case .decodingError:
            return "데이터 처리 중 오류가 발생했습니다."
        case .unknownError:
            return "알 수 없는 오류가 발생했습니다."
        }
    }
}
