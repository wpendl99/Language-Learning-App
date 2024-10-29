//
//  Cardify.swift
//  Language Learning App
//
//  Created by William Pendleton on 10/25/24.
//

import SwiftUI

struct Cardify: Animatable, ViewModifier {
    var isFaceUp: Bool {
        rotation < 90
    }
    
    var animatableData: Double {
        get { rotation }
        set { rotation = newValue }
    }
    
    var rotation: Double
    var term: VocabularyTerm
    
    init(isFaceUp: Bool, term: VocabularyTerm) {
        self.rotation = isFaceUp ? 180 : 0
        self.term = term
    }
    
    func body(content: Content) -> some View {
        GeometryReader { geometry in
            ZStack {
                if isFaceUp {
                    RoundedRectangle(cornerRadius: corderRadius(for: geometry.size)).fill(.white)
                    RoundedRectangle(cornerRadius: corderRadius(for: geometry.size)).strokeBorder(style: StrokeStyle(lineWidth: 10))
                    
                } else {
                    RoundedRectangle(cornerRadius: corderRadius(for: geometry.size))
                }
                
                content.opacity(isFaceUp ? 1 : 0)
                VStack{
                    Text("\(term.word)")
                        .font(.largeTitle)
                        .bold()
//                        .padding()
                    Text("'\(term.phonetic)'")
                }
                .opacity(isFaceUp ? 0 : 1)
                .foregroundColor(.white)
                .padding()
            }
        }
        .rotation3DEffect(
            .degrees(rotation),
            axis: (x: 0, y: 1, z: 0)
        )
    }
    
    // MARK: - Drawing Constants
    
    private func corderRadius(for size: CGSize) -> Double {
        min(size.width, size.height) * 0.05
    }
}

extension View {
    func cardify(isFaceUp: Bool, term: VocabularyTerm) -> some View {
        modifier(Cardify(isFaceUp: isFaceUp, term: term))
    }
}
