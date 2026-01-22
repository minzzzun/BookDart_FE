//
//  PostCreateViewModel.swift
//  BookDart_FE
//
//  Created by 김민준 on 1/18/26.
//

import UIKit
import Combine

@MainActor
final class PostCreateViewModel: ObservableObject {
    
    // MARK: - Published Properties
    
    @Published var title: String = ""
    @Published var content: String = ""
    @Published var capturedImage: UIImage?
    @Published var isScanning: Bool = false
    @Published var isRecognizing: Bool = false
    @Published var isSubmitting: Bool = false
    @Published var isCreateSuccess: Bool = false
    @Published var errorMessage: String?
    
    // MARK: - Private Properties
    
    private let postManager = PostManager.shared
    private let textRecognitionManager = TextRecognitionManager.shared
    
    // MARK: - Computed Properties
    
    var isSubmitButtonEnabled: Bool {
        !title.isEmpty && !content.isEmpty && !isSubmitting
    }
    
    // MARK: - Public Methods
    
    /// VisionKit에서 인식된 텍스트 처리
    func handleRecognizedText(_ text: String, image: UIImage?) {
       
        
        // #region agent log
        if let data = try? JSONSerialization.data(withJSONObject: ["location": "PostCreateViewModel.swift:39", "message": "handleRecognizedText called", "data": ["textLength": text.count, "textPreview": String(text.prefix(30)), "hasImage": image != nil], "timestamp": Date().timeIntervalSince1970 * 1000, "sessionId": "debug-session", "hypothesisId": "F"] as [String: Any], options: []), let str = String(data: data, encoding: .utf8) {
            let logPath = "/Users/kimminjun/Desktop/BookDart_FE/.cursor/debug.log"
            if let handle = FileHandle(forWritingAtPath: logPath) { handle.seekToEndOfFile(); handle.write((str + "\n").data(using: .utf8)!); handle.closeFile() } else { FileManager.default.createFile(atPath: logPath, contents: (str + "\n").data(using: .utf8), attributes: nil) }
        }
        // #endregion
        capturedImage = image
        content = String(text.prefix(50))
        isScanning = false
    }
    
    /// 게시글 등록
    func submitPost() {
        guard isSubmitButtonEnabled else { return }
        
        isSubmitting = true
        errorMessage = nil
        
        // 현재는 이미지를 빈 문자열로 전송 (추후 S3 업로드 구현)
        let imgString = ""
        
        postManager.createPost(
            title: title,
            content: content,
            img: imgString
        ) { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                self.isSubmitting = false
                
                switch result {
                case .success:
                    self.isCreateSuccess = true
                    
                case .failure(let error):
                    self.errorMessage = error.errorDescription
                }
            }
        }
    }
    
    /// 스캐너 시작
    func startScanning() {
        isScanning = true
        errorMessage = nil
    }
    
    /// 스캐너 취소
    func cancelScanning() {
        isScanning = false
    }
    
    /// 필드 초기화
    func clearFields() {
        title = ""
        content = ""
        capturedImage = nil
        errorMessage = nil
    }
    
    /// 에러 메시지 초기화
    func clearError() {
        errorMessage = nil
    }
    
    // MARK: - Private Methods
    
    /// 이미지에서 텍스트 인식
    private func recognizeText(from image: UIImage) {
        isRecognizing = true
        
        textRecognitionManager.recognizeText(from: image) { [weak self] result in
            DispatchQueue.main.async {
                // #region agent log
                let selfExists = self != nil
                var resultType = "failure"
                if case .success = result { resultType = "success" }
                if let data = try? JSONSerialization.data(withJSONObject: ["location": "PostCreateViewModel.swift:110", "message": "recognizeText callback", "data": ["selfExists": selfExists, "resultType": resultType], "timestamp": Date().timeIntervalSince1970 * 1000, "sessionId": "debug-session", "hypothesisId": "E"] as [String: Any], options: []), let str = String(data: data, encoding: .utf8) {
                    let logPath = "/Users/kimminjun/Desktop/BookDart_FE/.cursor/debug.log"
                    if let handle = FileHandle(forWritingAtPath: logPath) { handle.seekToEndOfFile(); handle.write((str + "\n").data(using: .utf8)!); handle.closeFile() } else { FileManager.default.createFile(atPath: logPath, contents: (str + "\n").data(using: .utf8), attributes: nil) }
                }
                // #endregion
                guard let self = self else { return }
                self.isRecognizing = false
                
                switch result {
                case .success(let text):
                    // #region agent log
                    if let data = try? JSONSerialization.data(withJSONObject: ["location": "PostCreateViewModel.swift:118", "message": "OCR success", "data": ["textLength": text.count, "textPreview": String(text.prefix(30))], "timestamp": Date().timeIntervalSince1970 * 1000, "sessionId": "debug-session", "hypothesisId": "D"] as [String: Any], options: []), let str = String(data: data, encoding: .utf8) {
                        let logPath = "/Users/kimminjun/Desktop/BookDart_FE/.cursor/debug.log"
                        if let handle = FileHandle(forWritingAtPath: logPath) { handle.seekToEndOfFile(); handle.write((str + "\n").data(using: .utf8)!); handle.closeFile() } else { FileManager.default.createFile(atPath: logPath, contents: (str + "\n").data(using: .utf8), attributes: nil) }
                    }
                    // #endregion
                    self.content = text
                    
                case .failure(let error):
                    // #region agent log
                    if let data = try? JSONSerialization.data(withJSONObject: ["location": "PostCreateViewModel.swift:125", "message": "OCR failure", "data": ["error": error.localizedDescription], "timestamp": Date().timeIntervalSince1970 * 1000, "sessionId": "debug-session", "hypothesisId": "D"] as [String: Any], options: []), let str = String(data: data, encoding: .utf8) {
                        let logPath = "/Users/kimminjun/Desktop/BookDart_FE/.cursor/debug.log"
                        if let handle = FileHandle(forWritingAtPath: logPath) { handle.seekToEndOfFile(); handle.write((str + "\n").data(using: .utf8)!); handle.closeFile() } else { FileManager.default.createFile(atPath: logPath, contents: (str + "\n").data(using: .utf8), attributes: nil) }
                    }
                    // #endregion
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }
}
