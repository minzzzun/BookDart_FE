//
//  PostModel.swift
//  BookDart_FE
//
//  Created by 김민준 on 1/18/26.
//

import Foundation

// MARK: - Post Model

struct Post: Codable, Identifiable, Hashable {
    let id: Int
    let userId: Int?
    let title: String?
    let content: String?
    let img: String?
    let deleted: Bool?
    let createdAt: String?
    let modifiedAt: String?
    
    // MARK: - Formatted Date
    
    var formattedDate: String {
        guard let dateString = createdAt else { return "" }
        
        let inputFormatter = ISO8601DateFormatter()
        inputFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        
        if let date = inputFormatter.date(from: dateString) {
            let outputFormatter = DateFormatter()
            outputFormatter.dateFormat = "yyyy.MM.dd"
            outputFormatter.locale = Locale(identifier: "ko_KR")
            return outputFormatter.string(from: date)
        }
        return dateString
    }
    
    var contentPreview: String {
        guard let content = content else { return "" }
        if content.count > 50 {
            return String(content.prefix(50)) + "..."
        }
        return content
    }
}

// MARK: - Request DTOs

struct PostCreateRequest: Encodable {
    let title: String
    let content: String
    let img: String
}

struct PostScrollListRequest: Encodable {
    let cursor: Int?
    let perpage: Int
    let orderby: String
    let orderway: String
    
    init(cursor: Int? = nil, perpage: Int = 10, orderby: String = "id", orderway: String = "DESC") {
        self.cursor = cursor
        self.perpage = perpage
        self.orderby = orderby
        self.orderway = orderway
    }
}

struct PostDetailRequest: Encodable {
    let id: Int
}

// MARK: - Response DTOs

struct PostCreateResponse: Decodable {
    let id: Int
}
