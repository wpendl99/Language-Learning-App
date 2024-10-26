import SwiftUI

struct FlashcardsView: View {
    let topic: Topic
    @State private var shuffledTerms: [VocabularyTerm] = []
    @State private var currentIndex = 0
    @State private var isFaceUp = true
    
    private let cardColor = Color.blue // Set your desired front color here
    
    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .center) {
                if !shuffledTerms.isEmpty {
                    CardView(term: shuffledTerms[currentIndex], cardColor: cardColor, isFaceUp: $isFaceUp)
                        .padding(40)
                    
                    // Progress Indicator
                    HStack {
                        ForEach(0..<shuffledTerms.count, id: \.self) { index in
                            Circle()
                                .fill(index == currentIndex ? Color.blue : Color.gray)
                                .frame(width: 10, height: 10)
                        }
                    }
                    .padding(.bottom, 20)
                    
                    HStack {
                        // Previous Button
                        Button("Previous") {
                            if currentIndex > 0 {
                                currentIndex -= 1
                            }
                            isFaceUp = true
                        }
                        .disabled(currentIndex == 0)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        
                        // Shuffle Button - Centered
                        Button("Shuffle") {
                            shuffledTerms.shuffle()
                            isFaceUp = true
                            currentIndex = 0
                        }
                        .frame(maxWidth: .infinity, alignment: .center)
                        
                        // Next Button
                        Button("Next") {
                            if currentIndex < shuffledTerms.count - 1 {
                                currentIndex += 1
                                isFaceUp = true
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .trailing)
                    }
                    .padding(.horizontal)

                } else {
                    Text("No vocabulary terms available.")
                        .font(.title)
                        .foregroundColor(.gray)
                }
            }
            .onAppear {
                shuffledTerms = topic.vocabulary.shuffled()
                currentIndex = 0
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
}

#Preview {
    FlashcardsView(topic: SampleData.sampleTopic)
}
