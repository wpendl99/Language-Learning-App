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
                            if topic.isLessonRead && topic.isFlashcardsCompleted && topic.isQuizCompleted {
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
