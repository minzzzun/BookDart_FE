//
//  LoginRequest.swift
//  BookDart_FE
//
//  Created by 김민준 on 1/16/26.
//

import Foundation

//MARK: - 로그인 요청
struct LoginRequest: Codable, Sendable {
    let username: String
    let password: String
}

//MARK: - 회원가입 요청
struct SignUpRequest: Codable, Sendable {
    let username: String
    let password: String
}
