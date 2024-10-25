//
//  LessonView.swift
//  Language Learning App
//
//  Created by William Pendleton on 10/24/24.
//

import SwiftUI

import SwiftUI

struct LessonView: View {
    let topic: Topic
        
    var body: some View {
        ScrollView {
            Text(topic.lesson)
                .padding()
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
