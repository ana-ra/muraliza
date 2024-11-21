//
//  LoadingColaborationGif.swift
//  Muralisa
//
//  Created by Rafael Antonio Chinelatto on 13/11/24.
//

import SwiftUI
import WebKit

struct GifView: UIViewRepresentable {
    let gifName: String
    
    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.isOpaque = false
        
        if let url = Bundle.main.url(forResource: gifName, withExtension: ".gif"), let data = try? Data(contentsOf: url) {
            webView.load(data, mimeType: "image/gif", characterEncodingName: "UTF-8", baseURL: url.deletingLastPathComponent())
        } else {
            print("Error: Unable to load LoadingColaboration.git")
        }
        
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        uiView.reload()
    }
}

#Preview {
    GifView(gifName: "loadingColaboration")
}
