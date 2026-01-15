//
//  User.swift
//  SpringTest
//
//  Created by 김민준 on 1/15/26.
//

import Foundation


struct User: Codable {
    var userName: String
    var userPassword: String
    
    enum CodingKeys: CodingKey {
        case userName 
        case userPassword
    }
}
