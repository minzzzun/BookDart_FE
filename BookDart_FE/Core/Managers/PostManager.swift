//
//  PostManager.swift
//  BookDart_FE
//
//  Created by 김민준 on 1/18/26.
//

import Foundation
import Alamofire

final class PostManager {
    
    // MARK: - Singleton
    
    static let shared = PostManager()
    private init() {}
    
    // MARK: - Dependencies
    
    private let tokenManager = TokenManager.shared
    
    // MARK: - Endpoints
    
    private enum Endpoint {
        static let base = NetworkConfig.baseURL + "/api/post"
        static let scrollList = base + "/scrollList"
    }
    
    // MARK: - Fetch Scroll List (무한 스크롤)
    
    func fetchScrollList(
        cursor: Int?,
        perpage: Int = 10,
        completion: @escaping (Result<[Post], PostError>) -> Void
    ) {
        guard let accessToken = tokenManager.bearerAccessToken else {
            completion(.failure(.unauthorized))
            return
        }
        
        let headers: HTTPHeaders = [
            "Authorization": accessToken
        ]
        
        var parameters: [String: Any] = [
            "perpage": perpage,
            "orderby": "id",
            "orderway": "DESC"
        ]
        
        if let cursor = cursor {
            parameters["cursor"] = cursor
        }
        
        AF.request(
            Endpoint.scrollList,
            method: .get,
            parameters: parameters,
            encoding: URLEncoding.default,
            headers: headers
        )
        .validate(statusCode: 200..<300)
        .responseDecodable(of: [Post].self) { response in
            switch response.result {
            case .success(let posts):
                completion(.success(posts))
                
            case .failure(let error):
                let statusCode = response.response?.statusCode ?? -1
                
                if statusCode == 401 {
                    completion(.failure(.unauthorized))
                } else if statusCode == 404 {
                    completion(.failure(.notFound))
                } else {
                    completion(.failure(.networkError(error.localizedDescription)))
                }
            }
        }
    }
    
    // MARK: - Fetch Detail
    
    func fetchDetail(
        id: Int,
        completion: @escaping (Result<Post, PostError>) -> Void
    ) {
        guard let accessToken = tokenManager.bearerAccessToken else {
            completion(.failure(.unauthorized))
            return
        }
        
        let headers: HTTPHeaders = [
            "Authorization": accessToken
        ]
        
        let parameters: [String: Any] = [
            "id": id
        ]
        
        AF.request(
            Endpoint.base,
            method: .get,
            parameters: parameters,
            encoding: URLEncoding.default,
            headers: headers
        )
        .validate(statusCode: 200..<300)
        .responseDecodable(of: Post.self) { response in
            switch response.result {
            case .success(let post):
                completion(.success(post))
                
            case .failure(let error):
                let statusCode = response.response?.statusCode ?? -1
                
                if statusCode == 401 {
                    completion(.failure(.unauthorized))
                } else if statusCode == 404 {
                    completion(.failure(.notFound))
                } else {
                    completion(.failure(.networkError(error.localizedDescription)))
                }
            }
        }
    }
    
    // MARK: - Create Post
    
    func createPost(
        title: String,
        content: String,
        img: String,
        completion: @escaping (Result<Int, PostError>) -> Void
    ) {
        guard let accessToken = tokenManager.bearerAccessToken else {
            completion(.failure(.unauthorized))
            return
        }
        
        let headers: HTTPHeaders = [
            "Authorization": accessToken,
            "Content-Type": "application/json"
        ]
        
        let parameters: [String: Any] = [
            "title": title,
            "content": content,
            "img": img
        ]
        
        AF.request(
            Endpoint.base,
            method: .post,
            parameters: parameters,
            encoding: JSONEncoding.default,
            headers: headers
        )
        .validate(statusCode: 200..<300)
        .responseDecodable(of: PostCreateResponse.self) { response in
            switch response.result {
            case .success(let createResponse):
                completion(.success(createResponse.id))
                
            case .failure:
                let statusCode = response.response?.statusCode ?? -1
                
                if statusCode == 401 {
                    completion(.failure(.unauthorized))
                } else {
                    completion(.failure(.createFailed))
                }
            }
        }
    }
}
