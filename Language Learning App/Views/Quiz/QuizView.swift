//
//  QuizView.swift
//  Language Learning App
//
//  Created by William Pendleton on 10/24/24.
//

import SwiftUI

struct QuizView: View {
    let topic: Topic
    @State private var startQuiz: Bool = false
    @State private var currentQuestionIndex = 0
    @State private var elapsedTime: Double = 0
    @State private var correctAnswerCount: Int = 0
    @State private var score: Int = 0
    @State private var timer: Timer?
    @State private var showResult = false
    @State private var isCorrectAnswer = false
    @State private var answerSubmitted = false
    @State private var selectedOption: String = ""
    @State private var userAnswer: String = ""
    
    var body: some View {
        VStack(alignment: .center) {
                if startQuiz {
                    quizContent
                } else {
                    quizIntroduction
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar{
                ToolbarItem(placement: .navigationBarTrailing) {
                    if !startQuiz || showResult {
                        Text("Quiz Completed: \(ProgressManager.shared.isQuizCompleted(for: topic.id) ? "✅" : "❌")")
                    }
                }
            }
            .onAppear {
                resetQuiz()
            }
            .ignoresSafeArea(.all)
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
                startQuiz = true
                startTimer()
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
            if currentQuestionIndex < topic.quizQuestions.count {
                let question = topic.quizQuestions[currentQuestionIndex]
                
                Text(question.question)
                    .font(.headline)
                    .padding()
                
                if let options = question.options {
                    // Multiple Choice or True/False
                    ForEach(options, id: \.self) { option in
                        Button(action: {
                            selectedOption = option
                            checkAnswer()
                        }) {
                            Text(option)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color(UIColor.secondarySystemBackground))
                                .cornerRadius(10)
                                .padding(.horizontal)
                        }
                        .disabled(answerSubmitted)
                    }
                } else {
                    // Fill in the Blank
                    TextField("Your Answer", text: $userAnswer)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                        .disabled(answerSubmitted)
                        .onSubmit {
                            checkAnswer()
                        }
                }
                
                if answerSubmitted {
                    Text(isCorrectAnswer ? "Correct!" : "Incorrect!")
                        .font(.headline)
                        .foregroundColor(isCorrectAnswer ? .green : .red)
                        .padding(.bottom, 20)
                    
                    if !isCorrectAnswer {
                        Text("Correct Answer: \(question.correctAnswer)")
                            .padding(.bottom, 20)
                    }
                    
                    Button("Next Question") {
                        nextQuestion()
                    }
                } else {
                    if let _ = question.options{
                    } else {
                        Button("Submit") {
                            checkAnswer()
                        }
                        .disabled(userAnswer.isEmpty)
                    }
                }
                
                ProgressView(value: elapsedTime, total: 20)
                    .padding()
                    .accentColor(.blue)
            } else {
                if (correctAnswerCount == topic.quizQuestions.count) {
                    Text("Quiz Completed!")
                        .font(.largeTitle)
                        .padding()
                } else {
                    Text("Try Again!")
                        .font(.largeTitle)
                        .padding()
                }
                
                Text("Correct Answers \(correctAnswerCount) / \(topic.quizQuestions.count)")
                    .font(.title)
                    .padding()
                
                Text("Your Score: \(score)")
                    .font(.title)
                    .padding()
                
                Button("Finish") {
                    completeQuiz()
                }
            }
        }
    }
    
    private func resetQuiz() {
        score = 0
        currentQuestionIndex = 0
        elapsedTime = 0
        answerSubmitted = false
        selectedOption = ""
        userAnswer = ""
        isCorrectAnswer = false
        startQuiz = false
    }
    
    private func completeQuiz() {
        if correctAnswerCount == topic.quizQuestions.count {
            ProgressManager.shared.setQuizCompleted(true, for: topic.id)
        }
        let highScore = ProgressManager.shared.highScore(for: topic.id)
        if score > highScore {
            ProgressManager.shared.setHighScore(score, for: topic.id)
        }
    }
    
    // MARK: - Timer Methods
    
    func startTimer() {
        stopTimer()
        elapsedTime = 0
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
            elapsedTime += 0.1
            if elapsedTime >= 20 {
                timer?.invalidate()
                checkAnswer(timeout: true)
            }
        }
    }
    
    func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    // MARK: - Answer Checking
    
    func checkAnswer(timeout: Bool = false) {
        stopTimer()
        answerSubmitted = true
        
        let question = topic.quizQuestions[currentQuestionIndex]
        let correctAnswer = question.correctAnswer.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        
        if timeout {
            isCorrectAnswer = false
            playIncorrectSound()
            return
        }
        
        if let _ = question.options {
            // Multiple Choice or True/False
            isCorrectAnswer = selectedOption.lowercased() == correctAnswer
        } else {
            // Fill in the Blank
            isCorrectAnswer = userAnswer.lowercased().trimmingCharacters(in: .whitespacesAndNewlines) == correctAnswer
        }
        
        if isCorrectAnswer {
            correctAnswerCount += 1
            let bonus = max(0, Int(ceil((20 - elapsedTime) / 2)))
            let totalScore = 10 + bonus
            score += totalScore
            playCorrectSound()
        } else {
            playIncorrectSound()
        }
    }
    
    func nextQuestion() {
        currentQuestionIndex += 1
        elapsedTime = 0
        answerSubmitted = false
        selectedOption = ""
        userAnswer = ""
        isCorrectAnswer = false
        if currentQuestionIndex < topic.quizQuestions.count {
            startTimer()
        } else {
            ProgressManager.shared.setQuizCompleted(true, for: topic.id)
            let highScore = ProgressManager.shared.highScore(for: topic.id)
            if score > highScore {
                ProgressManager.shared.setHighScore(score, for: topic.id)
            }
        }
    }
    
    // MARK: - Sound Effects
    
    func playCorrectSound() {
        // Implement sound playing for correct answer
    }
    
    func playIncorrectSound() {
        // Implement sound playing for incorrect answer
    }
}

#Preview {
    QuizView(topic: SampleData.sampleTopic)
}
