//
//  NoticeManager.swift
//  BookDart_FE
//
//  Created by 김민준 on 1/19/26.
//

import Foundation
import Alamofire

final class NoticeManager {
    
    static let shared = NoticeManager()
    private init() {}
    
    
    private let tokenManager = TokenManager.shared
    
    private enum Endpoint {
        static let base = NetworkConfig.baseURL + "/api/notice"
        static let scrollList = base + "/scrollList"
    }
    
    //MARK: - scrollList
    func fetchScrollList(cursor: Int?, perpage: Int = 10, completion: @escaping(Result<[Notice], Error>) -> Void){
        
        guard let accessToken = tokenManager.bearerAccessToken else {
            completion(.failure(NSError(domain: "", code: 401, userInfo: [NSLocalizedDescriptionKey: "인증이 필요합니다."])))
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
        .responseDecodable(of: [Notice].self) { response in
            switch response.result {
            case .success(let notices):
                completion(.success(notices))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    
    
    
    //MARK: - fetch Detail
    func fetchDetail(
        id: Int,
        completion: @escaping (Result<Notice, Error>) -> Void
    ) {
        guard let accessToken = tokenManager.bearerAccessToken else {
            completion(.failure(NSError(domain: "", code: 401, userInfo: [NSLocalizedDescriptionKey: "인증이 필요합니다."])))
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
        .responseDecodable(of: Notice.self) { response in
            switch response.result {
            case .success(let notice):
                completion(.success(notice))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    
    
    
}
