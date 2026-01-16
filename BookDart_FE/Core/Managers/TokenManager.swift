//
//  TokenManager.swift
//  BookDart_FE
//
//  Created by 김민준 on 1/16/26.
//

import Foundation

final class TokenManager {
    
    // MARK: - Singleton
    static let shared = TokenManager()
    private init() {}
    
    // MARK: - Keys
    private enum Keys {
        static let refreshToken = "BookDart_RefreshToken"
        static let accessToken = "BookDart_AccessToken"
    }
    
    // MARK: - Token Prefix
    private let tokenPrefix = "Bearer "
    
    // MARK: - Properties
    var refreshToken: String? {
        get { UserDefaults.standard.string(forKey: Keys.refreshToken) }
        set { UserDefaults.standard.set(newValue, forKey: Keys.refreshToken) }
    }
    
    var accessToken: String? {
        get { UserDefaults.standard.string(forKey: Keys.accessToken) }
        set { UserDefaults.standard.set(newValue, forKey: Keys.accessToken) }
    }
    
    // MARK: - Computed Properties
    var isLoggedIn: Bool {
        return refreshToken != nil
    }
    
    var bearerAccessToken: String? {
        guard let token = accessToken else { return nil }
//        return tokenPrefix + token
        return  token
    }
    
    var bearerRefreshToken: String? {
        guard let token = refreshToken else { return nil }
//        return tokenPrefix + token
        return  token
    }
    
    // MARK: - Methods
    
    /// Refresh Token 저장 (Bearer prefix 제거 후 저장)
    func saveRefreshToken(_ token: String) {
//        let cleanToken = removePrefix(from: token)
//        refreshToken = cleanToken
        refreshToken = token
    }
    
    /// Access Token 저장 (Bearer prefix 제거 후 저장)
    func saveAccessToken(_ token: String) {
//        let cleanToken = removePrefix(from: token)
//        accessToken = cleanToken
        accessToken = token
    }
    
    /// 모든 토큰 삭제 (로그아웃)
    func clearTokens() {
        refreshToken = nil
        accessToken = nil
    }
    
    // MARK: - Private Methods
    
//    /// "Bearer " prefix 제거
//    private func removePrefix(from token: String) -> String {
//        if token.hasPrefix(tokenPrefix) {
//            return String(token.dropFirst(tokenPrefix.count))
//        }
//        return token
//    }
}
