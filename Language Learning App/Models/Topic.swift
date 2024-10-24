//
//  Topic.swift
//  Language Learning App
//
//  Created by William Pendleton on 10/24/24.
//

import Foundation

struct Topic: Identifiable, Codable {
    let id: String
    let name: String
    let lesson: String
    let vocabulary: [VocabularyTerm]
    let quizQuestions: [QuizQuestion]
    
    var isLessonRead: Bool = false
    var isFlashcardsCompleted: Bool = false
    var isQuizCompleted: Bool = false
    var highScore: Int = 0
}
