//
//  ProtectedRecord.swift
//  SwiftDataConcurrency
//
//  Created by Maksym Horobets on 18.07.2025.
//

import SwiftData
import Foundation

// Opt out of Xcode 26 default MainActor isolation.
nonisolated struct ProtectedRecord: Equatable {
    var id: UUID = UUID()
    // If the struct was created for insertion and does not have any Model representation yet
    // then the PersistentIdentifier is nil.
    var persistentModelID: PersistentIdentifier?
    
    var title: String
    var details: String
    var createdAt: Date = .now
    var updatedAt: Date?
}

extension ProtectedRecord: ProtectedModel {
    init(from record: Record) {
        self.init(id: record.id,
                  persistentModelID: record.persistentModelID,
                  title: record.title,
                  details: record.details,
                  createdAt: record.createdAt,
                  updatedAt: record.updatedAt)
    }
}
