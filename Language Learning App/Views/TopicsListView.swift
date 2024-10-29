//
//  TopicsListView.swift
//  Language Learning App
//
//  Created by William Pendleton on 10/24/24.
//

import SwiftUI

struct TopicsListView: View {
    @ObservedObject var dataManager = DataManager()
    @State var didChangeFlag: Bool = false
    
    var body: some View {
        NavigationView {
            List {
                ForEach(dataManager.topics) { topic in
                    NavigationLink(destination: TopicDetailView(topic: topic, didChangeFlag: $didChangeFlag)) {
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
            .navigationTitle("Study Spanish Topics")
            .onAppear {
                if didChangeFlag {
                    didChangeFlag = false
                    // Refresh view
                    #if os(iOS) || os(tvOS) || targetEnvironment(macCatalyst)
                    DispatchQueue.main.async {
                        self.dataManager.loadTopics()
                    }
                    #endif
                }
            }
        }
    }
}

#Preview {
    TopicsListView()
}
