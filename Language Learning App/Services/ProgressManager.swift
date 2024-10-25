//
//  ProgressManager.swift
//  Language Learning App
//
//  Created by William Pendleton on 10/24/24.
//

import Foundation
import SwiftUI
import Combine

class ProgressManager:ObservableObject {
    static let shared = ProgressManager()
    
    private let userDefaults = UserDefaults.standard
    
    @Published private(set) var didChangeFlag = false
    
    private init() {}
    
    // MARK: - Keys
    
    private func key(for property: String, topicId: String) -> String {
        return "\(property)_\(topicId)"
    }
    
    // MARK: - DidChange Flag
    
    func setDidChangeFlag() {
        didChangeFlag = true
        objectWillChange.send()
    }
    
    func resetDidChangeFlag() {
        didChangeFlag = false
    }
    
    // MARK: - Lesson Read
    
    func isLessonRead(for topicId: String) -> Bool {
        let key = key(for: "isLessonRead", topicId: topicId)
        return userDefaults.bool(forKey: key)
    }
    
    func setLessonRead(_ read: Bool, for topicId: String) {
        let key = key(for: "isLessonRead", topicId: topicId)
        userDefaults.set(read, forKey: key)
        setDidChangeFlag()
    }
    
    func lessonBinding(for topicId: String) -> Binding<Bool> {
        .init(
            get: { self.isLessonRead(for: topicId) },
            set: { self.setLessonRead($0, for: topicId) }
        )
    }
    
    // MARK: - Flashcards Completed
    
    func isFlashcardsCompleted(for topicId: String) -> Bool {
        let key = key(for: "isFlashcardsCompleted", topicId: topicId)
        return userDefaults.bool(forKey: key)
    }
    
    func setFlashcardsCompleted(_ completed: Bool, for topicId: String) {
        let key = key(for: "isFlashcardsCompleted", topicId: topicId)
        userDefaults.set(completed, forKey: key)
        setDidChangeFlag()
    }
    
    func flashcardsBinding(for topicId: String) -> Binding<Bool> {
        .init(
            get: { self.isFlashcardsCompleted(for: topicId) },
            set: { self.setFlashcardsCompleted($0, for: topicId) }
        )
    }
    
    // MARK: - Quiz Completed
    
    func isQuizCompleted(for topicId: String) -> Bool {
        let key = key(for: "isQuizCompleted", topicId: topicId)
        return userDefaults.bool(forKey: key)
    }
    
    func setQuizCompleted(_ completed: Bool, for topicId: String) {
        let key = key(for: "isQuizCompleted", topicId: topicId)
        userDefaults.set(completed, forKey: key)
        setDidChangeFlag()
    }
    
    // MARK: - High Score
    
    func highScore(for topicId: String) -> Int {
        let key = key(for: "highScore", topicId: topicId)
        return userDefaults.integer(forKey: key)
    }
    
    func setHighScore(_ score: Int, for topicId: String) {
        let key = key(for: "highScore", topicId: topicId)
        userDefaults.set(score, forKey: key)
        setDidChangeFlag()
    }
    
    // MARK: - Reset Progress
    
    func resetProgress(for topicId: String) {
        let keys = [
            key(for: "isLessonRead", topicId: topicId),
            key(for: "isFlashcardsCompleted", topicId: topicId),
            key(for: "isQuizCompleted", topicId: topicId),
            key(for: "highScore", topicId: topicId)
        ]
        for key in keys {
            userDefaults.removeObject(forKey: key)
        }
    }
    
    func resetAllProgress(topicIds: [String]) {
        for topicId in topicIds {
            resetProgress(for: topicId)
        }
    }
}
