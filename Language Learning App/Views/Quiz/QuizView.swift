//
//  QuizView.swift
//  Language Learning App
//
//  Created by William Pendleton on 10/24/24.
//

import SwiftUI

struct QuizView: View {
    @StateObject var viewModel: QuizViewModel
    
    var body: some View {
        ZStack {
            VStack(alignment: .center) {
                if viewModel.startQuiz {
                    quizContent
                } else {
                    quizIntroduction
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    if !viewModel.startQuiz || viewModel.showResult {
                        Text("Quiz Completed: \(ProgressManager.shared.isQuizCompleted(for: viewModel.topic.id) ? "✅" : "❌")")
                    }
                }
            }
            .onAppear {
                viewModel.resetQuiz()
            }
            .ignoresSafeArea(.all)
            
            if viewModel.showGlow {
                RoundedRectangle(cornerSize: CGSize(width: 50, height: 50))
                    .stroke(viewModel.glowColor, lineWidth: 20)
                    .blur(radius: 10)
                    .opacity(0.8)
                    .transition(.opacity)
                    .ignoresSafeArea()
            }
        }
    }
    
    private var quizIntroduction: some View {
        VStack {
            Text("🎉 Get Ready for the Quiz!")
                .font(.largeTitle)
                .padding()
            
            VStack(alignment: .leading, spacing: 15) {
                Text("📝 **Question Types:** You'll face a mix of **multiple-choice** and **free-response** questions.")
                Text("⏱️ **Timing:** Each question is timed. The faster you answer, the higher your score!")
                Text("🏆 **Scoring:** Earn up to **10 points** per question, plus a **speed bonus** for quick answers.")
                Text("✅ Answer all of the questions correctly to complete the quiz!")
                    .bold()
            }
            .multilineTextAlignment(.leading)
            .padding()
            
            Button(action: {
                viewModel.startQuiz = true
                viewModel.startTimer()
            }) {
                Text("🚀 Start Quiz")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            .padding(.horizontal)
        }
        .padding()
    }
    
    private var quizContent: some View {
        VStack {
            if viewModel.currentQuestionIndex < viewModel.topic.quizQuestions.count {
                let question = viewModel.shuffledQuestions[viewModel.currentQuestionIndex]
                
                Text(question.question)
                    .font(.headline)
                    .padding()
                
                if let _ = question.options {
                    ForEach(viewModel.shuffledOptions, id: \.self) { option in
                        Button(action: {
                            viewModel.selectedOption = option
                            viewModel.checkAnswer()
                        }) {
                            Text(option)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color(UIColor.secondarySystemBackground))
                                .cornerRadius(10)
                                .padding(.horizontal)
                        }
                        .disabled(viewModel.answerSubmitted)
                    }
                } else {
                    TextField("Your Answer", text: $viewModel.userAnswer)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                        .disabled(viewModel.answerSubmitted)
                        .onSubmit {
                            viewModel.checkAnswer()
                        }
                }
                
                if viewModel.answerSubmitted {
                    Text(viewModel.isCorrectAnswer ? "Correct!" : "Incorrect!")
                        .font(.headline)
                        .foregroundColor(viewModel.isCorrectAnswer ? .green : .red)
                        .padding(.bottom, 20)
                    
                    if !viewModel.isCorrectAnswer {
                        Text("**Correct Answer**: \(question.correctAnswer)")
                            .padding(.bottom, 20)
                    }
                    
                    Button("Next Question") {
                        viewModel.nextQuestion()
                    }
                } else {
                    if question.options == nil {
                        Button("Submit") {
                            viewModel.checkAnswer()
                        }
                        .disabled(viewModel.userAnswer.isEmpty)
                    }
                }
                
                ProgressView(value: viewModel.elapsedTime, total: 20)
                    .padding()
                    .accentColor(.blue)
            } else {
                // Quiz Completed Section
                VStack {
                    Text(viewModel.didCompleteQuiz ? "Quiz Completed!" : "Try Again...")
                        .font(.largeTitle)
                        .padding()
                    
                    Text("**Correct Answers**: \(viewModel.correctAnswerCount) / \(viewModel.topic.quizQuestions.count)")
                        .font(.title2)
                    
                    Text("**Your Score**: \(viewModel.score)")
                        .font(.title2)
                    
                    Text("High Score: \(viewModel.highScore)")
                        .font(.subheadline)
                        .padding(.bottom)
                    
                    // Conditional Try Again / Finish Button
                    Button(action: {
                        if viewModel.didCompleteQuiz {
                            // Handle finish action
                            viewModel.resetQuiz()
                        } else {
                            // Handle try again action
                            viewModel.resetQuiz()
                            viewModel.startQuiz = true
                            viewModel.startTimer()
                        }
                    }) {
                        Text(viewModel.didCompleteQuiz ? "Finish" : "Try Again")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(viewModel.didCompleteQuiz ? Color.green : Color.blue)
                            .cornerRadius(10)
                    }
                    .padding(.horizontal)
                    
                    // Show "Go Back" button if "Try Again" is displayed
                    if !viewModel.didCompleteQuiz {
                        Button("Go Back") {
                            // Handle go back action, e.g., navigating to a previous view
                        }
                        .buttonStyle(BorderlessButtonStyle())
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .cornerRadius(10)
                        .padding(.horizontal)
                    }
                }
                .displayConfetti(isActive: $viewModel.showConfetti)
            }
        }
    }
}

#Preview {
    QuizView(viewModel: QuizViewModel(topic: SampleData.sampleTopic))
}
