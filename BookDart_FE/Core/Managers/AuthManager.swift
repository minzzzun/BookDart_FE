//
//  AuthManager.swift
//  BookDart_FE
//
//  Created by 김민준 on 1/16/26.
//

import Foundation
import Alamofire

final class AuthManager {
    
    static let shared = AuthManager()
    private init() {}
    
    private let tokenManager = TokenManager.shared
    
    // MARK: - Endpoints
    
    private enum Endpoint {
        static let login = NetworkConfig.baseURL + "/api/login"
        static let signUp = NetworkConfig.baseURL + "/api/user/signup"
        static let refreshToken = NetworkConfig.baseURL + "/api/auth"
    }
    
    private enum HeaderKey {
        static let refresh = "RefreshToken"
        static let access = "Authorization"
    }
    
    // MARK: - Login
    
    /// 로그인 API 호출
    /// - Parameters:
    ///   - username: 사용자 아이디
    ///   - password: 비밀번호
    /// - Throws: AuthError
    func login(username: String, password: String) async throws {
        let param: [String: String] = [
            "username": username,
            "password": password
        ]
        
        let response = await AF.request(
            Endpoint.login,
            method: .post,
            parameters: param,
            encoding: JSONEncoding.default
        )
            .serializingString(emptyResponseCodes: [200, 201, 204])
            .response
        
        let statusCode = response.response?.statusCode ?? -1
        
        if statusCode == 401 {
            throw AuthError.invalidCredentials
        }
        
        if statusCode < 200 || statusCode >= 300 {
            throw AuthError.networkError("HTTP 에러: \(statusCode)")
        }
        
        guard let headers = response.response?.headers,
              let refreshToken = headers.value(for: HeaderKey.refresh) else {
            throw AuthError.tokenNotFound
        }
        
        tokenManager.saveRefreshToken(refreshToken)
        try await fetchAccessToken()
    }
    
    // MARK: - Sign Up
    
    /// 회원가입 API 호출
    /// - Parameters:
    ///   - username: 사용자 아이디
    ///   - password: 비밀번호
    func signUp(username: String, password: String) async throws -> Int {
        let parameters: [String: String] = [
            "username": username,
            "password": password
        ]
        
        let response = await AF.request(
            Endpoint.signUp,
            method: .post,
            parameters: parameters,
            encoding: JSONEncoding.default
        )
            .validate(statusCode: 200..<300)
            .serializingData()
            .response
        
        if let error = response.error {
            throw AuthError.networkError(error.localizedDescription)
        }
        
        guard let data = response.data,
              let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
              let id = json["id"] as? Int else {
            throw AuthError.signUpFailed
        }
        
        return id
    }
    
    // MARK: - Refresh Access Token
    
    /// Access Token 갱신
    func fetchAccessToken() async throws {
        guard let bearerRefreshToken = tokenManager.bearerRefreshToken else {
            throw AuthError.tokenNotFound
        }
        
        let headers: HTTPHeaders = [
            HeaderKey.refresh: bearerRefreshToken
        ]
        
        let response = await AF.request(
            Endpoint.refreshToken,
            method: .post,
            headers: headers
        )
            .serializingString(emptyResponseCodes: [200, 201, 204])
            .response
        
        let statusCode = response.response?.statusCode ?? -1
        
        if statusCode < 200 || statusCode >= 300 {
            throw AuthError.networkError("HTTP 에러: \(statusCode)")
        }
        
        guard let responseHeaders = response.response?.headers,
              let accessToken = responseHeaders.value(for: HeaderKey.access) else {
            throw AuthError.tokenNotFound
        }
        
        tokenManager.saveAccessToken(accessToken)
    }
    
    // MARK: - Logout
    
    /// 로그아웃 (토큰 삭제)
    func logout() {
        tokenManager.clearTokens()
    }
}
