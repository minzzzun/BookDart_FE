//
//  NoticeModels.swift
//  BookDart_FE
//
//  Created by 김민준 on 1/19/26.
//

import Foundation

struct Notice: Codable, Identifiable {
    let id: Int
    let title: String?
    let content: String?
    let pinned: Bool?
    let createdAt: String?
}
