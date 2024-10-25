//
//  TopicsListView.swift
//  Language Learning App
//
//  Created by William Pendleton on 10/24/24.
//

import SwiftUI

struct TopicsListView: View {
    @ObservedObject var dataManager = DataManager()
    
    var body: some View {
        NavigationView {
            List {
                ForEach(dataManager.topics) { topic in
                    NavigationLink(destination: TopicDetailView(topic: topic)) {
                        HStack {
                            Text(topic.name)
                                .font(.headline)
                            Spacer()
                            if ProgressManager.shared.isLessonRead(for: topic.id) &&
                                ProgressManager.shared.isFlashcardsCompleted(for: topic.id) &&
                                ProgressManager.shared.isQuizCompleted(for: topic.id) {
                                Image(systemName: "checkmark.seal.fill")
                                    .foregroundColor(.green)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Language Topics")
        }
    }
}

#Preview {
    TopicsListView()
}
