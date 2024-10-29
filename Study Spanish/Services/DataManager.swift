//
//  DataManager.swift
//  Language Learning App
//
//  Created by William Pendleton on 10/24/24.
//

import Foundation

class DataManager: ObservableObject {
    @Published var topics: [Topic] = []
    
    init() {
        loadTopics()
    }
    
    func loadTopics() {
        if let url = Bundle.main.url(forResource: "topics", withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                topics = try decoder.decode([Topic].self, from: data)
            } catch {
                print("Error loading topics: \(error)")
            }
        }
    }
}
