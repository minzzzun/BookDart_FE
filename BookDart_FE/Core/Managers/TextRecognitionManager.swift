//
//  TextRecognitionManager.swift
//  BookDart_FE
//
//  Created by 김민준 on 1/18/26.
//

import UIKit
import Vision
import CoreImage
import CoreImage.CIFilterBuiltins

final class TextRecognitionManager {
    
    // MARK: - Singleton
    
    static let shared = TextRecognitionManager()
    private init() {}
    
    // MARK: - Private Properties
    
    private let context = CIContext()
    
    // MARK: - Public Methods
    
    /// 이미지에서 텍스트를 인식합니다
    /// - Parameters:
    ///   - image: 텍스트를 인식할 UIImage
    ///   - completion: 인식 결과 (성공 시 텍스트 문자열, 실패 시 에러)
    func recognizeText(
        from image: UIImage,
        completion: @escaping (Result<String, Error>) -> Void
    ) {
        // 전처리된 이미지로 변환
        guard let cgImage = processForOCR(image: image) else {
            completion(.failure(TextRecognitionError.imageProcessingFailed))
            return
        }
        
        // Vision 요청 생성
        let request = VNRecognizeTextRequest { request, error in
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }
            
            guard let observations = request.results as? [VNRecognizedTextObservation] else {
                DispatchQueue.main.async {
                    completion(.failure(TextRecognitionError.noTextFound))
                }
                return
            }
            
            // 인식된 텍스트들을 줄바꿈으로 연결
            let recognizedStrings = observations.compactMap { observation in
                observation.topCandidates(1).first?.string
            }
            
            let resultText = recognizedStrings.joined(separator: "\n")
            
            DispatchQueue.main.async {
                if resultText.isEmpty {
                    completion(.failure(TextRecognitionError.noTextFound))
                } else {
                    completion(.success(resultText))
                }
            }
        }
        
        // 인식 옵션 설정
        request.recognitionLevel = .accurate
        request.usesLanguageCorrection = true
        request.recognitionLanguages = ["ko-KR", "en-US"]  // 한국어 + 영어
        request.minimumTextHeight = 0.02
        
        // 백그라운드에서 실행
        let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        DispatchQueue.global(qos: .userInitiated).async {
            do {
                try handler.perform([request])
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }
    
    // MARK: - Private Methods (이미지 전처리)
    
    /// OCR을 위한 이미지 전처리
    private func processForOCR(image: UIImage) -> CGImage? {
        guard let ciImage = CIImage(image: image) else { return nil }
        
        // 1) 흑백 + 대비/밝기
        let colorControls = CIFilter.colorControls()
        colorControls.inputImage = ciImage
        colorControls.saturation = 0.0      // 흑백
        colorControls.contrast = 1.3        // 대비 증가
        colorControls.brightness = 0.05     // 밝기 약간 증가
        
        guard let step1 = colorControls.outputImage else { return nil }
        
        // 2) 샤픈 (글자 경계선 선명)
        let sharpen = CIFilter.sharpenLuminance()
        sharpen.inputImage = step1
        sharpen.sharpness = 0.6
        
        guard let step2 = sharpen.outputImage else { return nil }
        
        // 3) 노이즈 감소
        let noiseReduction = CIFilter.noiseReduction()
        noiseReduction.inputImage = step2
        noiseReduction.noiseLevel = 0.02
        noiseReduction.sharpness = 0.4
        
        let finalImage = noiseReduction.outputImage ?? step2
        
        // CIImage -> CGImage
        let extent = finalImage.extent
        return context.createCGImage(finalImage, from: extent)
    }
}

// MARK: - Text Recognition Error

enum TextRecognitionError: LocalizedError {
    case imageProcessingFailed
    case noTextFound
    
    var errorDescription: String? {
        switch self {
        case .imageProcessingFailed:
            return "이미지 처리에 실패했습니다."
        case .noTextFound:
            return "텍스트를 찾을 수 없습니다."
        }
    }
}
