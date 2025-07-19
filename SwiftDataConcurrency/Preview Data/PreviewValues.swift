//
//  PreviewValues.swift
//  SwiftDataConcurrency
//
//  Created by Maksym Horobets on 18.07.2025.
//

import SwiftData
import Foundation

struct PreviewValues {
    static let modelContainer: ModelContainer = {
        let schema = Schema(Record.self)
        let configuration = ModelConfiguration(isStoredInMemoryOnly: true)
         
        return try! ModelContainer(for: schema, configurations: configuration)
    }()
    
    private init() { }
}
