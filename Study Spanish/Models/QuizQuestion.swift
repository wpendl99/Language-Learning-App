//
//  QuizQuestion.swift
//  Language Learning App
//
//  Created by William Pendleton on 10/24/24.
//

import Foundation

struct QuizQuestion: Identifiable, Codable {
    let id: String
    let question: String
    let correctAnswer: String
    let options: [String]? // For multiple-choice questions
}

