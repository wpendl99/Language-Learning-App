//
//  WebView.swift
//  Language Learning App
//
//  Created by William Pendleton on 10/24/24.
//

import SwiftUI
import WebKit

struct WebView : UIViewRepresentable {
    @Binding var dynamicHeight: CGFloat
    var webview: WKWebView = WKWebView()
    let htmlContent: String

    class Coordinator: NSObject, WKNavigationDelegate {
        var parent: WebView

        init(_ parent: WebView) {
            self.parent = parent
        }

        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            webView.evaluateJavaScript("document.documentElement.scrollHeight", completionHandler: { (height, error) in
                DispatchQueue.main.async {
                    self.parent.dynamicHeight = height as! CGFloat
                }
            })
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIView(context: Context) -> WKWebView  {
        webview.scrollView.bounces = false
        webview.navigationDelegate = context.coordinator
        webview.loadHTMLString(htmlContent, baseURL:  nil)
        return webview
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
    }
}
