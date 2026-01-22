//
//  DataScannerRepresentable.swift
//  BookDart_FE
//
//  Created by 김민준 on 1/18/26.
//

import SwiftUI
import VisionKit

@available(iOS 16.0, *)
struct DataScannerRepresentable: UIViewControllerRepresentable {
    
    let onTextRecognized: (String, UIImage?) -> Void
    let onCancel: () -> Void
    
    func makeUIViewController(context: Context) -> DataScannerViewController {
        let scanner = DataScannerViewController(
            recognizedDataTypes: [.text()],
            qualityLevel: .accurate,
            recognizesMultipleItems: true,
            isHighFrameRateTrackingEnabled: false,
            isPinchToZoomEnabled: true,
            isGuidanceEnabled: true,
            isHighlightingEnabled: true
        )
        scanner.delegate = context.coordinator
        return scanner
    }
    
    func updateUIViewController(_ uiViewController: DataScannerViewController, context: Context) {
        if !uiViewController.isScanning {
            try? uiViewController.startScanning()
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(onTextRecognized: onTextRecognized, onCancel: onCancel)
    }
    
    // MARK: - Coordinator
    
    class Coordinator: NSObject, DataScannerViewControllerDelegate {
        
        let onTextRecognized: (String, UIImage?) -> Void
        let onCancel: () -> Void
        
        init(onTextRecognized: @escaping (String, UIImage?) -> Void, onCancel: @escaping () -> Void) {
            self.onTextRecognized = onTextRecognized
            self.onCancel = onCancel
        }
        
        func dataScanner(_ dataScanner: DataScannerViewController, didTapOn item: RecognizedItem) {
            // #region agent log
            if let data = try? JSONSerialization.data(withJSONObject: ["location": "DataScannerRepresentable.swift:53", "message": "didTapOn called", "data": ["itemType": String(describing: type(of: item))], "timestamp": Date().timeIntervalSince1970 * 1000, "sessionId": "debug-session", "hypothesisId": "B"] as [String: Any], options: []), let str = String(data: data, encoding: .utf8) {
                let logPath = "/Users/kimminjun/Desktop/BookDart_FE/.cursor/debug.log"
                if let handle = FileHandle(forWritingAtPath: logPath) { handle.seekToEndOfFile(); handle.write((str + "\n").data(using: .utf8)!); handle.closeFile() } else { FileManager.default.createFile(atPath: logPath, contents: (str + "\n").data(using: .utf8), attributes: nil) }
            }
            // #endregion
            
            // RecognizedItem에서 직접 텍스트 추출
            switch item {
            case .text(let textItem):
                let recognizedText = textItem.transcript
                // #region agent log
                if let data = try? JSONSerialization.data(withJSONObject: ["location": "DataScannerRepresentable.swift:65", "message": "Text extracted from RecognizedItem", "data": ["textLength": recognizedText.count, "textPreview": String(recognizedText.prefix(100))], "timestamp": Date().timeIntervalSince1970 * 1000, "sessionId": "debug-session", "hypothesisId": "F"] as [String: Any], options: []), let str = String(data: data, encoding: .utf8) {
                    let logPath = "/Users/kimminjun/Desktop/BookDart_FE/.cursor/debug.log"
                    if let handle = FileHandle(forWritingAtPath: logPath) { handle.seekToEndOfFile(); handle.write((str + "\n").data(using: .utf8)!); handle.closeFile() } else { FileManager.default.createFile(atPath: logPath, contents: (str + "\n").data(using: .utf8), attributes: nil) }
                }
                // #endregion
                
                // 화면 캡처 (프리뷰용)
                let image = captureScreen(from: dataScanner)
                dataScanner.stopScanning()
                onTextRecognized(recognizedText, image)
                
            default:
                break
            }
        }
        
        private func captureScreen(from scanner: DataScannerViewController) -> UIImage? {
            let renderer = UIGraphicsImageRenderer(bounds: scanner.view.bounds)
            let image = renderer.image { context in
                scanner.view.drawHierarchy(in: scanner.view.bounds, afterScreenUpdates: true)
            }
            return image
        }
    }
}

// MARK: - Scanner Availability Check

struct ScannerAvailabilityView: View {
    
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "camera.badge.ellipsis")
                .font(.system(size: 60))
                .foregroundColor(.gray)
            
            Text("카메라 스캔을 사용할 수 없습니다")
                .font(.headline)
            
            Text("이 기기에서는 텍스트 스캔 기능을 지원하지 않습니다.")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding()
    }
}
