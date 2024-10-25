//
//  QuizViewModel.swift
//  Language Learning App
//
//  Created by William Pendleton on 10/25/24.
//

import SwiftUI
import Combine

class QuizViewModel: ObservableObject {
    @Published var startQuiz: Bool = false
    @Published var currentQuestionIndex = 0
    @Published var elapsedTime: Double = 0
    @Published var correctAnswerCount: Int = 0
    @Published var score: Int = 0
    @Published var showResult = false
    @Published var isCorrectAnswer = false
    @Published var answerSubmitted = false
    @Published var selectedOption: String = ""
    @Published var userAnswer: String = ""
    @Published var showConfetti: Bool = false
    @Published var didCompleteQuiz: Bool = false
    @Published var showGlow = false
    @Published var glowColor: Color = .clear
    @Published var shuffledOptions: [String] = []
    @Published var shuffledQuestions: [QuizQuestion]
    
    private(set) var highScore: Int {
        get { ProgressManager.shared.highScore(for: topic.id) }
        set { ProgressManager.shared.setHighScore(newValue, for: topic.id) }
    }
    
    var topic: Topic
    private var timer: Timer?
    private var soundPlayer = SoundPlayer()
    
    init(topic: Topic) {
        self.topic = topic
        self.shuffledQuestions = topic.quizQuestions.shuffled()
        setupCurrentQuestion()
    }
    
    private func setupCurrentQuestion() {
            if currentQuestionIndex < shuffledQuestions.count {
                let question = shuffledQuestions[currentQuestionIndex]
                shuffledOptions = question.options?.shuffled() ?? []
            }
        }
    
    func startTimer() {
        stopTimer()
        elapsedTime = 0
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
            self.elapsedTime += 0.1
            if self.elapsedTime >= 20 {
                self.timer?.invalidate()
                self.checkAnswer(timeout: true)
            }
        }
    }
    
    func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    func checkAnswer(timeout: Bool = false) {
        stopTimer()
        answerSubmitted = true
        
        let question = shuffledQuestions[currentQuestionIndex]
        let correctAnswer = question.correctAnswer.normalized().trimmingCharacters(in: .whitespacesAndNewlines)
        let userResponse = userAnswer.normalized().trimmingCharacters(in: .whitespacesAndNewlines)
        
        if timeout {
            isCorrectAnswer = false
            playIncorrectSound()
            triggerGlowEffect(isCorrect: false)
            return
        }
        
        if let _ = question.options {
            // Multiple Choice or True/False
            isCorrectAnswer = selectedOption.normalized() == correctAnswer
        } else {
            // Fill in the Blank
            let distance = userResponse.levenshteinDistance(to: correctAnswer)
            let threshold = Int(Double(correctAnswer.count) * 0.3) // Allow 30% character difference
            isCorrectAnswer = distance <= threshold
        }
        
        if isCorrectAnswer {
            correctAnswerCount += 1
            let bonus = max(0, Int(ceil((20 - elapsedTime) / 2)))
            let totalScore = 10 + bonus
            score += totalScore
            playCorrectSound()
            triggerGlowEffect(isCorrect: true)
        } else {
            playIncorrectSound()
            triggerGlowEffect(isCorrect: false)
        }
    }
    
    func nextQuestion() {
        currentQuestionIndex += 1
        elapsedTime = 0
        answerSubmitted = false
        selectedOption = ""
        userAnswer = ""
        isCorrectAnswer = false
        
        if currentQuestionIndex < shuffledQuestions.count {
            setupCurrentQuestion()
            startTimer()
        } else {
            if correctAnswerCount == shuffledQuestions.count {
                ProgressManager.shared.setQuizCompleted(true, for: topic.id)
                didCompleteQuiz = true
                showConfetti = true
                playSuccessSound()
            }
            let highScore = ProgressManager.shared.highScore(for: topic.id)
            if score > highScore {
                ProgressManager.shared.setHighScore(score, for: topic.id)
            }
        }
    }
    
    func resetQuiz() {
        score = 0
        currentQuestionIndex = 0
        elapsedTime = 0
        correctAnswerCount = 0
        answerSubmitted = false
        selectedOption = ""
        userAnswer = ""
        isCorrectAnswer = false
        startQuiz = false
        shuffledOptions = []
        shuffledQuestions = topic.quizQuestions.shuffled()
        setupCurrentQuestion()
    }
    
    func triggerGlowEffect(isCorrect: Bool) {
        glowColor = isCorrect ? .green : .red
        withAnimation(.easeInOut(duration: 0.15)) {
            showGlow = true
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
            withAnimation(.easeInOut(duration: 0.15)) {
                self.showGlow = false
            }
        }
    }
    
    func playCorrectSound() {
        Task {
            await soundPlayer.playSound(named: "correct.m4a")
        }
    }
    
    func playIncorrectSound() {
        Task {
            await soundPlayer.playSound(named: "incorrect.m4a")
        }
    }
    
    func playSuccessSound() {
        Task {
            await soundPlayer.playSound(named: "success.m4a")
        }
    }
}
