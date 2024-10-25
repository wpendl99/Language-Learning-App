//
//  FlashcardsView.swift
//  Language Learning App
//
//  Created by William Pendleton on 10/24/24.
//

import SwiftUI

struct FlashcardsView: View {
    let topic: Topic
    @State private var shuffledTerms: [VocabularyTerm] = []
    @State private var currentIndex = 0
    @State private var isFlipped = false
    
    var body: some View {
        VStack {
            if !shuffledTerms.isEmpty {
                let term = shuffledTerms[currentIndex]
                
                Text(isFlipped ? term.translation : term.word)
                    .font(.largeTitle)
                    .padding()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.white)
                    .cornerRadius(10)
                    .shadow(radius: 5)
                    .rotation3DEffect(
                        .degrees(isFlipped ? 180 : 0),
                        axis: (x: 0, y: 1, z: 0)
                    )
                    .onTapGesture {
                        withAnimation {
                            isFlipped.toggle()
                        }
                    }
                
                HStack {
                    Button("Previous") {
                        if currentIndex > 0 {
                            currentIndex -= 1
                            isFlipped = false
                        }
                    }
                    .disabled(currentIndex == 0)
                    
                    Spacer()
                    
                    Button("Next") {
                        if currentIndex < shuffledTerms.count - 1 {
                            currentIndex += 1
                            isFlipped = false
                        } else {
                            // Mark flashcards as completed
                            ProgressManager.shared.setFlashcardsCompleted(true, for: topic.id)
                        }
                    }
                }
                .padding()
            } else {
                Text("No vocabulary terms available.")
            }
        }
        .onAppear {
            shuffledTerms = topic.vocabulary.shuffled()
            currentIndex = 0
            isFlipped = false
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Toggle(isOn: ProgressManager.shared.flashcardsBinding(for: topic.id)) {
                    Text("Completed")
                }.toggleStyle(.switch)
            }
        }
    }
}

//#Preview {
//    FlashcardsView()
//}
