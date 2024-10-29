//
//  CardView.swift
//  Language Learning App
//
//  Created by William Pendleton on 10/25/24.
//

import SwiftUI

struct CardView: View {
    let term: VocabularyTerm
    var cardColor: Color
    
    @Binding var isFaceUp: Bool
    
    var body: some View {
        ZStack {
            VStack {
                Text("Word")
                    .font(.headline)
                    .foregroundColor(.gray)
                Text(term.word)
                    .font(.title)
                    .bold()
                    .padding(.bottom)
                Text("Translation")
                    .font(.headline)
                    .foregroundColor(.gray)
                Text(term.translation)
                    .font(.title)
                    .bold()
            }
            .padding()
        }
        .cardify(isFaceUp: isFaceUp, term: term)
        .transition(.scale)
        .foregroundStyle(cardColor)
        .rotation3DEffect(
            .degrees(isFaceUp ? 180 : 0),
            axis: (x: 0, y: 1, z: 0)
        )
        .onTapGesture {
            withAnimation {
                isFaceUp.toggle()
            }
        }
    }
}

#Preview {
    CardView(term: .init(id: "1", word: "Hello", phonetic: "OH-lah", translation: "Hola"), cardColor: .red, isFaceUp: .constant(true))
}
