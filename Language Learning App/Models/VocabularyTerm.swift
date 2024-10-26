//
//  VocabularyTerm.swift
//  Language Learning App
//
//  Created by William Pendleton on 10/24/24.
//

import Foundation

struct VocabularyTerm: Identifiable, Codable {
    let id: String
    let word: String
    let phonetic: String
    let translation: String
}
