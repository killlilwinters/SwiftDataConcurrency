<div align="center">
  <img src="https://github.com/user-attachments/assets/2f6ade61-7b00-4485-befc-d244b9ee556e" alt="SwiftDataConcurrencyAppIcon" width="30%">
</div>
<h2 align="center">SwiftData & Modern Concurrency</h2>

<p align="center">
  This is the sample project for the article:<br>
  <strong><a href="https://medium.com/@killlilwinters/taking-swiftdata-further-modelactor-swift-concurrency-and-avoiding-mainactor-pitfalls-3692f61f2fa1">Taking SwiftData further with Modern Concurrency</a></strong>
</p>


It demonstrates a possible architecture for using SwiftData in a production-level application, focusing on moving all database operations to a background thread to ensure a responsive UI, while adhering to modern Swift concurrency safety practices.

## Core Concepts

This project showcases a solution to the common problem of SwiftData's `modelContext` blocking the main thread. The key patterns used are:

*   **Background Persistence with `@ModelActor`**: All CRUD (Create, Read, Update, Delete) operations are encapsulated within `RecordStore`, an `@ModelActor`. This guarantees every database interaction happens on a dedicated background thread, preventing UI freezes.

*   **The "Protected Model" Pattern**: To safely pass data between the main thread (SwiftUI Views) and the background `ModelActor`, this project uses two model types:
    *   `Record`: The non-`Sendable` `@Model` class that lives exclusively within the `RecordStore`.
    *   `ProtectedRecord`: A `Sendable` `struct` that acts as a safe Data Transfer Object (DTO) for use across actor boundaries. This pattern is essential for Swift 6 concurrency safety.

*   **MVVM Architecture**: A separation of concerns between the View (`MainListView`), ViewModel (`MainListViewModel`), and the persistence layer (`RecordStore`).

*   **Automatic UI Updates via `NotificationCenter`**: Instead of relying on the main-thread-bound `@Query` property wrapper, the `MainListViewModel` observes `ModelContext.didSave` notifications. When data is saved in the background, the ViewModel is notified and efficiently re-fetches the latest data, updating the UI automatically.

## How to Run

### Prerequisites
*   Xcode 26 or later
*   iOS 26 or later

### Steps
1.  Clone the repository.
2.  Open `SwiftDataConcurrency.xcodeproj` in Xcode.
3.  Build and run the app on a simulator or device.

You can test the background processing by tapping the **Add** button in the toolbar. This will begin inserting a large number of records in the background without freezing the UI. The list will update automatically as batches are saved.

## Project Structure



```
└── SwiftDataConcurrency/
    ├── SwiftDataConcurrencyApp.swift  // App entry point, ModelContainer setup
    ├── Extensions/
    │   └── DispatchQueue+Ext.swift    // Debugging helper to check queue labels
    ├── Model/
    │   ├── Record.swift               // The @Model class (lives only in the store)
    │   └── ProtectedRecord.swift      // The Sendable struct (DTO for UI/actors)
    ├── Preview Data/
    │   └── PreviewValues.swift        // In-memory container for SwiftUI Previews
    ├── Store/
    │   ├── RecordStore.swift          // The @ModelActor implementation
    │   └── Protocols/
    │       ├── PersistenceStore.swift // Protocol defining the store's capabilities
    │       ├── ProtectedModel.swift   // Protocol for our Sendable model types
    │       └── PersistenceError.swift // Error type for PersistenceStore
    └── Views/
        └── MainListView/
            ├── MainListView.swift     // The SwiftUI View
            └── MainListViewModel.swift// The ViewModel orchestrating UI and data
```
