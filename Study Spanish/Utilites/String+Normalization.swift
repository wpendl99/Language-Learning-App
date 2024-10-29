//
//  String+Normalization.swift
//  Language Learning App
//
//  Created by William Pendleton on 10/25/24.
//

import Foundation

extension String {
    // Normalize string by removing diacritics and converting to lowercase
    func normalized() -> String {
        return self.folding(options: .diacriticInsensitive, locale: .current).lowercased()
    }
    
    // Levenshtein distance algorithm to measure similarity between two strings
    func levenshteinDistance(to other: String) -> Int {
        let selfCount = self.count
        let otherCount = other.count
        
        guard selfCount != 0 else { return otherCount }
        guard otherCount != 0 else { return selfCount }
        
        var matrix = Array(repeating: Array(repeating: 0, count: otherCount + 1), count: selfCount + 1)
        
        // Initialize the matrix
        for i in 0...selfCount {
            matrix[i][0] = i
        }
        for j in 0...otherCount {
            matrix[0][j] = j
        }
        
        // Compute the Levenshtein distance
        for i in 1...selfCount {
            for j in 1...otherCount {
                let cost = self[self.index(self.startIndex, offsetBy: i - 1)] ==
                           other[other.index(other.startIndex, offsetBy: j - 1)] ? 0 : 1
                matrix[i][j] = Swift.min(matrix[i - 1][j] + 1, // deletion
                                         matrix[i][j - 1] + 1, // insertion
                                         matrix[i - 1][j - 1] + cost) // substitution
            }
        }
        
        return matrix[selfCount][otherCount]
    }
}
