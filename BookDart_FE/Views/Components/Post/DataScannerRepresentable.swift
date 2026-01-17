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
    
    let onCapture: (UIImage) -> Void
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
        Coordinator(onCapture: onCapture, onCancel: onCancel)
    }
    
    // MARK: - Coordinator
    
    class Coordinator: NSObject, DataScannerViewControllerDelegate {
        
        let onCapture: (UIImage) -> Void
        let onCancel: () -> Void
        
        init(onCapture: @escaping (UIImage) -> Void, onCancel: @escaping () -> Void) {
            self.onCapture = onCapture
            self.onCancel = onCancel
        }
        
        func dataScanner(_ dataScanner: DataScannerViewController, didTapOn item: RecognizedItem) {
            // 탭 시 현재 화면 캡처
            captureScreen(from: dataScanner)
        }
        
        private func captureScreen(from scanner: DataScannerViewController) {
            let renderer = UIGraphicsImageRenderer(bounds: scanner.view.bounds)
            let image = renderer.image { context in
                scanner.view.drawHierarchy(in: scanner.view.bounds, afterScreenUpdates: true)
            }
            scanner.stopScanning()
            onCapture(image)
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
