//
//  TopicDetailView.swift
//  Language Learning App
//
//  Created by William Pendleton on 10/24/24.
//

import SwiftUI

struct TopicDetailView: View {
    @State var topic: Topic
    
    var body: some View {
        VStack(spacing: 20) {
            Text(topic.name)
                .font(.largeTitle)
                .padding()
            
            NavigationLink(destination: LessonView(topic: $topic)) {
                OptionButton(title: "Read Lesson", completed: topic.isLessonRead)
            }
            
            NavigationLink(destination: FlashcardsView(topic: $topic)) {
                OptionButton(title: "Practice Flashcards", completed: topic.isFlashcardsCompleted)
            }
            
            NavigationLink(destination: QuizView(topic: $topic)) {
                OptionButton(title: "Take Quiz", completed: topic.isQuizCompleted)
            }
            
            Spacer()
        }
        .navigationTitle(topic.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct OptionButton: View {
    let title: String
    let completed: Bool
    
    var body: some View {
        HStack {
            Text(title)
                .font(.headline)
            Spacer()
            if completed {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(.green)
            }
            Image(systemName: "chevron.right")
                .foregroundColor(.gray)
        }
        .padding()
        .background(Color(UIColor.secondarySystemBackground))
        .cornerRadius(10)
        .padding(.horizontal)
    }
}

//#Preview {
//    TopicDetailView()
//}
