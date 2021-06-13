//
//  WebView.swift
//  MikeOnlinGame
//
//  Created by 白謹瑜 on 2021/6/13.
//

import Foundation
import SwiftUI
import WebKit

extension UIView {
    func snapshot() -> UIImage {
        let rect = CGRect(x: -10, y: 230, width: 400, height: 350)
               let renderer = UIGraphicsImageRenderer(bounds: rect)
               return renderer.image{ rendererContect in
                   layer.render(in: rendererContect.cgContext)
               }
    }
}

struct WebView: UIViewRepresentable {
    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        if let url = URL(string: "https://picrew.me/image_maker/35494") {
            let request = URLRequest(url: url)
            webView.load(request)
        }
        
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        
    }
    
    typealias UIViewType = WKWebView
    
    
}

struct WebView_Previews: PreviewProvider {
    static var previews: some View {
        WebView()
    }
}
