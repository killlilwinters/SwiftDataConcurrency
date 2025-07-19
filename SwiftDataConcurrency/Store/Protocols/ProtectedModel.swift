//
//  ProtectedModel.swift
//  SwiftDataConcurrency
//
//  Created by Maksym Horobets on 18.07.2025.
//

import SwiftData
import Foundation

// Opt out of Xcode 26 default MainActor isolation.
nonisolated protocol ProtectedModel: Sendable, Identifiable {
    associatedtype Model: PersistentModel
    var persistentModelID: PersistentIdentifier? { get }
    
    init(from item: Model)
}
