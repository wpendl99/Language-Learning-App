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
                    .bold()
                Text("⏱️ **Timing:** Each question is timed. The faster you answer, the higher your score!")
                    .bold()
                Text("🏆 **Scoring:** Earn up to **10 points** per question, plus a **speed bonus** for quick answers.")
                    .bold()
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
                let question = viewModel.topic.quizQuestions[viewModel.currentQuestionIndex]
                
                Text(question.question)
                    .font(.headline)
                    .padding()
                
                if let options = question.options {
                    ForEach(options, id: \.self) { option in
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
                        Text("Correct Answer: \(question.correctAnswer)")
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
                Group {
                    if viewModel.didCompleteQuiz {
                        Text("Quiz Completed!")
                            .font(.largeTitle)
                            .padding()
                    } else {
                        Text("Try Again!")
                            .font(.largeTitle)
                            .padding()
                    }
                    
                    Text("Correct Answers \(viewModel.correctAnswerCount) / \(viewModel.topic.quizQuestions.count)")
                        .font(.title)
                        .padding()
                    
                    Text("Your Score: \(viewModel.score)")
                        .font(.title)
                        .padding()
                    
                    Button("Finish") {
                        // Handle quiz completion action
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
