//
//  Record.swift
//  SwiftDataConcurrency
//
//  Created by Maksym Horobets on 18.07.2025.
//

import SwiftData
import Foundation

@Model
// Opt out of Xcode 26 default MainActor isolation.
nonisolated final class Record {
    var id: UUID // This does not replace the PersistenceIdentifier!
    var title: String
    var details: String
    var createdAt: Date
    var updatedAt: Date?
    
    init(
        id: UUID = UUID(),
        title: String,
        details: String,
        createdAt: Date,
        updatedAt: Date? = nil
    ) {
        self.id = id
        self.title = title
        self.details = details
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
    
    convenience init(from protectedRecord: ProtectedRecord) {
        self.init(id: protectedRecord.id,
                  title: protectedRecord.title,
                  details: protectedRecord.details,
                  createdAt: protectedRecord.createdAt,
                  updatedAt: protectedRecord.updatedAt)
    }
}
