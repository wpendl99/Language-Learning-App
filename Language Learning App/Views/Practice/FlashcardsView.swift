//
//  FlashcardsView.swift
//  Language Learning App
//
//  Created by William Pendleton on 10/24/24.
//

import SwiftUI

struct FlashcardsView: View {
    @Binding var topic: Topic
    
    var body: some View {
        Text("Flashcards will go here")
            .onAppear {
                // Shuffle vocabulary terms
//                topic.vocabulary.shuffled()
            }
            .navigationTitle("Flashcards")
            .navigationBarTitleDisplayMode(.inline)
    }
}

//#Preview {
//    FlashcardsView()
//}
