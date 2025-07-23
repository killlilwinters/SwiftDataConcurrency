//
//  MainListViewModel.swift
//  SwiftDataConcurrency
//
//  Created by Maksym Horobets on 18.07.2025.
//

import SwiftData
import Foundation

// This project was created in Xcode 26
// so any declaration inherits default isolation.
// In this case MainActor - meaning this ViewModel is implicitly @MainActor.
@Observable
final class MainListViewModel {
    var isLoading: Bool = false
    var page: Int = 0
    @ObservationIgnored let itemsPerPage: Int = 100
    
    let store: RecordStore
    var records: [ProtectedRecord] = []
    
    @ObservationIgnored var notificationTask: Task<Void, Never>? = nil
    
    init(container: ModelContainer) {
        self.store = RecordStore(modelContainer: container)
        subscribeToNotifications()
    }
    
    deinit {
        notificationTask?.cancel()
        notificationTask = nil
    }
    
    func subscribeToNotifications() {
        // NotificationCenter will run on cooperative thread pool in this case.
        // But notification are posted in the same context as where the notifications(named: ) method was called.
        notificationTask = Task.detached {
            for await _ in NotificationCenter.default.notifications(named: ModelContext.didSave) {
                print("NotificationCenter posts notifications on the " + DispatchQueue.currentLabel)
                // This will run successfully even during an insert since we are fetching off
                // the ModelActor which is too busy inserting.
                let context = ModelContext(self.store.modelContainer)
                let page = await self.page
                let itemsPerPage = self.itemsPerPage
                
                var descriptor = FetchDescriptor<Record>()
                descriptor.fetchLimit = page * itemsPerPage
                
                let records = try? context.fetch(descriptor).compactMap { ProtectedRecord(from: $0) }
                await MainActor.run {
                    guard let records else { return }
                    self.records = records
                }
            }
        }
    }
    
    func addRecords(amount: Int) {
        Task.detached(priority: .userInitiated) { // Detach from MainActor.
            await self.store.checkQueueInfo()
            // Many articles in the past suggested creating ModelActor instance directly in the detached
            // task, but I am seeing my actor queue being "Actor queue: NSManagedObjectContext 0x6000035009a0"
            // even though I create it in the init, which is isolated to the MainActor.
            var records = [ProtectedRecord]()
            for _ in 0..<amount {
                records.append(.init(title: UUID().uuidString, details: "Description"))
            }
            
            try await self.store.insertBatch(records, saveAtEach: 100_000)
        }
    }
    
    func loadRecords() {
        guard !isLoading else { return }
        isLoading = true
        Task.detached(priority: .userInitiated) {
            let records = try? await self.store.fetch(page: self.page, amountPerPage: self.itemsPerPage)
            // We will get stuck here for a long time if we try to fetch after a notification
            // while trying to insert at the same time.
            await MainActor.run {
                self.records.append(contentsOf: records ?? [])
                self.isLoading = false
                self.page += 1
            }
        }
    }
    
}
