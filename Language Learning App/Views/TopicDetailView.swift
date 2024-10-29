//
//  TopicDetailView.swift
//  Language Learning App
//
//  Created by William Pendleton on 10/24/24.
//

import SwiftUI

struct TopicDetailView: View {
    @ObservedObject var progressManager = ProgressManager.shared
    @State var topic: Topic
    @Binding var didChangeFlag: Bool
    @State private var showResetTopicQuizAlert = false
    @State private var showResetAllProgressAlert = false

    
    var body: some View {
        VStack(spacing: 20) {
            Text(topic.name)
                .font(.largeTitle)
                .multilineTextAlignment(.center)
                .bold()
                .padding()
            
            NavigationLink(destination: LessonView(topic: topic)) {
                OptionButton(
                    title: "Read Lesson",
                    completed: ProgressManager.shared.isLessonRead(for: topic.id)
                )
            }
            
            NavigationLink(destination: FlashcardsView(topic: topic)) {
                OptionButton(
                    title: "Practice Flashcards",
                    completed: ProgressManager.shared.isFlashcardsCompleted(for: topic.id)
                )
            }
            
            NavigationLink(destination: QuizView(viewModel: QuizViewModel(topic: topic))) {
                OptionButton(
                    title: "Take Quiz",
                    completed: ProgressManager.shared.isQuizCompleted(for: topic.id)
                )
            }
            
            Text("High Score: \(progressManager.highScore(for: topic.id))")
                .font(.subheadline)
                .foregroundStyle(.secondary)
            
            Spacer()
                        
            Button("Reset Quiz Progress", role: .destructive) {
                showResetTopicQuizAlert = true
            }
            .buttonStyle(.bordered)
            .alert(isPresented: $showResetTopicQuizAlert) {
                Alert(
                    title: Text("Reset Topic Quiz Progress"),
                    message: Text("Are you sure you want to reset the quiz progress and high score for \(topic.name)?"),
                    primaryButton: .destructive(Text("Reset")) {
                        progressManager.resetQuizProgress(for: topic.id)
                    },
                    secondaryButton: .cancel()
                )
            }
            
            Button("Reset All Topic Progress", role: .destructive) {
                showResetAllProgressAlert = true
            }
            .buttonStyle(.borderedProminent)
            .alert(isPresented: $showResetAllProgressAlert) {
                Alert(
                    title: Text("Reset All Topic Progress"),
                    message: Text("Are you sure you want to reset all progress, including quizzes, lessons, and flashcards for this topic?"),
                    primaryButton: .destructive(Text("Reset All")) {
                        progressManager.resetTopicProgress(for: topic.id)
                    },
                    secondaryButton: .cancel()
                )
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            if progressManager.didChangeFlag {
                progressManager.resetDidChangeFlag()
                didChangeFlag = true
            }
        }
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

#Preview {
    TopicDetailView(topic: SampleData.sampleTopic, didChangeFlag: .constant(false))
}
