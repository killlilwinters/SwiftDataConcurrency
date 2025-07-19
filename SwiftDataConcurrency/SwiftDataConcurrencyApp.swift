//
//  SwiftDataConcurrencyApp.swift
//  SwiftDataConcurrency
//
//  Created by Maksym Horobets on 18.07.2025.
//

import SwiftUI
import SwiftData

@main
struct SwiftDataConcurrencyApp: App {
    let container: ModelContainer
    
    var body: some Scene {
        WindowGroup {
            MainListView(viewModel: MainListViewModel(container: container))
        }
    }
    
    init() {
        let schema = Schema(Record.self)
        let configuration = ModelConfiguration(isStoredInMemoryOnly: false)
        let modelContext = try! ModelContainer(for: schema, configurations: configuration)
        
        self.container = modelContext
    }
}
