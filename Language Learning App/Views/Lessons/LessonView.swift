//
//  LessonView.swift
//  Language Learning App
//
//  Created by William Pendleton on 10/24/24.
//

import SwiftUI

import SwiftUI

struct LessonView: View {
    @Binding var topic: Topic
    
    var body: some View {
        ScrollView {
            Text(topic.lesson)
                .padding()
        }
        .navigationTitle("Lesson")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            topic.isLessonRead = true
            // Save progress if needed
        }
    }
}


//#Preview {
//    LessonView()
//}
