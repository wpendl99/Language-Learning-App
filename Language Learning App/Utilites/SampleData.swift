//
//  SampleData.swift
//  Language Learning App
//
//  Created by William Pendleton on 10/24/24.
//

import Foundation

struct SampleData {
    static let sampleTopic: Topic = Topic(
        id: "UUID-0",
        name: "Super Simple (REMOVE FROM PROD)",
        lesson: "In this lesson, you'll learn basic greetings and farewells in Spanish.",
        vocabulary: [
            VocabularyTerm(
                id: "UUID-1-1",
                word: "Hola",
                translation: "Hello"
            ),
            VocabularyTerm(
                id: "UUID-1-2",
                word: "Adiós",
                translation: "Goodbye"
            ),
            VocabularyTerm(
                id: "UUID-1-3",
                word: "Buenos días",
                translation: "Good morning"
            )
        ],
        quizQuestions: [
            QuizQuestion(
                id: "UUID-1-Q1",
                question: "What is the Spanish word for 'Hello'?",
                correctAnswer: "Hola",
                options: nil
            ),
            QuizQuestion(
                id: "UUID-1-Q2",
                question: "What does 'Adiós' mean in English?",
                correctAnswer: "Goodbye",
                options: ["Goodbye", "Hello", "Good night", "See you later"]
            )
        ]
    )
    
    static let sampleTopics: [Topic] = [sampleTopic]
}
