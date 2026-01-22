//
//  ScannerSheet.swift
//  BookDart_FE
//
//  Created by 김민준 on 1/18/26.
//

import SwiftUI
import VisionKit

struct ScannerSheet: View {
    
    let onTextRecognized: (String, UIImage?) -> Void
    let onCancel: () -> Void
    
    var body: some View {
        if #available(iOS 16.0, *), DataScannerViewController.isSupported {
            NavigationStack {
                DataScannerRepresentable(
                    onTextRecognized: onTextRecognized,
                    onCancel: onCancel
                )
                .ignoresSafeArea()
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button("취소", action: onCancel)
                    }
                }
            }
        } else {
            ScannerAvailabilityView()
        }
    }
}
