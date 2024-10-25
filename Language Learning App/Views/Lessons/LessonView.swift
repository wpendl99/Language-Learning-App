//
//  LessonView.swift
//  Language Learning App
//
//  Created by William Pendleton on 10/24/24.
//

import SwiftUI

struct LessonView: View {
    let topic: Topic
    @State private var webViewHeight: CGFloat = .zero
        
    var body: some View {
        ScrollView {
            WebView(dynamicHeight: $webViewHeight, htmlContent: topic.lesson)
                .frame(height: webViewHeight)
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Toggle(isOn: ProgressManager.shared.lessonBinding(for: topic.id)) {
                    Text("Completed")
                }.toggleStyle(.switch)
            }
        }
    }
}


#Preview {
    LessonView(topic: SampleData.sampleTopic)
}
