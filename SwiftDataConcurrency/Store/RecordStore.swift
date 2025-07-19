//
//  RecordStore.swift
//  SwiftDataConcurrency
//
//  Created by Maksym Horobets on 18.07.2025.
//

import SwiftData
import Foundation

@ModelActor
actor RecordStore {
    
    @discardableResult
    func insert(_ item: ProtectedRecord) throws -> PersistentIdentifier {
        let model = Record(from: item)
        modelContext.insert(model)
        try modelContext.save()
        return model.persistentModelID
    }
    
    @discardableResult
    func insertBatch(_ items: [ProtectedRecord], saveAtEach: Int) throws -> Set<PersistentIdentifier> {
        var ids = Set<PersistentIdentifier>()
        
        for start in stride(from: 0, to: items.count, by: saveAtEach) {
            let end = min(start + saveAtEach, items.count)
            
            items[start..<end].forEach { item in
                let model = Record(from: item)
                modelContext.insert(model)
                ids.insert(model.persistentModelID)
            }
            
            try modelContext.save()
        }
        return ids
    }
    
    func delete(id: PersistentIdentifier) throws {
        let model = try fetchForID(id)
        
        modelContext.delete(model)
        
        try modelContext.save()
    }
    
    func fetch() throws -> [ProtectedRecord] {
        try modelContext
            .fetch(FetchDescriptor<Record>())
            .map { ProtectedRecord(from: $0) }
    }
    
    func fetch(page: Int = 0, amountPerPage: Int = 50) throws -> [ProtectedRecord] {
        let alreadyFetched = page * amountPerPage
        
        var descriptor = FetchDescriptor<Record>()
        descriptor.fetchLimit = amountPerPage
        descriptor.fetchOffset = alreadyFetched
        
        let fetched = try modelContext.fetch(descriptor)
        
        return fetched.map {
            ProtectedRecord(from: $0)
        }
    }
    
    func fetch(id: PersistentIdentifier) throws -> ProtectedRecord? {
        let model = try fetchForID(id)
        
        return ProtectedRecord(from: model)
    }
    
    func fetch(descriptor: FetchDescriptor<Record>) throws -> [ProtectedRecord] {
        try modelContext.fetch(descriptor).map{ ProtectedRecord(from: $0) }
    }
    
    func updateFields(id: PersistentIdentifier, using updates: (Record) -> Void) throws {
        let model = try fetchForID(id)
        
        updates(model)
        
        try modelContext.save()
    }
    
    func eraseAllData() throws {
        try modelContext.delete(model: Record.self)
    }
}

// MARK: Helpers
extension RecordStore {
    func fetchForID(_ id: PersistentIdentifier) throws -> Record {
        let descriptor = FetchDescriptor<Record>(
            predicate: #Predicate { $0.persistentModelID == id }
        )
        
        guard let model = try? modelContext.fetch(descriptor).first else {
            throw PersistenceError.notFound
        }
        
        return model
    }
}

