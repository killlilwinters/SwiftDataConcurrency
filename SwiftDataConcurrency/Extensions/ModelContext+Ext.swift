//
//  ModelContext+Ext.swift
//  SwiftDataConcurrency
//
//  Created by Maksym Horobets on 14.08.2025.
//

import SwiftData
import Foundation

extension ModelContext {
    nonisolated static func printChanges(for notification: NotificationCenter.Notifications.Iterator.Element) {
        guard let userInfo = notification.userInfo else { return }
        
        func printIDs(_ ids: Any?, label: String) {
            guard let ids = ids as? [PersistentIdentifier] else { return }
            print(label + ":")
            for id in ids {
                print("--> ID: \(id)")
            }
        }
        
        // Query generation (not identifiers, but useful to know)
        if let queryGen = userInfo[NotificationKey.queryGeneration] {
            print("🔄 Query generation: \(queryGen)")
        }
        
        // Invalidated all identifiers.
        printIDs(userInfo[NotificationKey.invalidatedAllIdentifiers.rawValue], label: "🗑️ Items invalidated")

        // Inserted identifiers.
        printIDs(userInfo[NotificationKey.insertedIdentifiers.rawValue], label: "✨ Items inserted")

        // Updated identifiers.
        printIDs(userInfo[NotificationKey.updatedIdentifiers.rawValue], label: "🔄 Items updated")

        // Deleted identifiers.
        printIDs(userInfo[NotificationKey.deletedIdentifiers.rawValue], label: "❌ Items deleted")

    }
}

