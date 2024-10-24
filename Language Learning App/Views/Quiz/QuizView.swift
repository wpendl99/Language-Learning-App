//
//  QuizView.swift
//  Language Learning App
//
//  Created by William Pendleton on 10/24/24.
//

import SwiftUI

struct QuizView: View {
    @Binding var topic: Topic
    
    var body: some View {
        Text("Quiz will go here")
            .navigationTitle("Quiz")
            .navigationBarTitleDisplayMode(.inline)
    }
}

//#Preview {
//    QuizView()
//}
