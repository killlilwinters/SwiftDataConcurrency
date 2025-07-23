//
//  MainListView.swift
//  SwiftDataConcurrency
//
//  Created by Maksym Horobets on 18.07.2025.
//

import SwiftUI
import SwiftData

struct MainListView: View {
    @State var viewModel: MainListViewModel
    
    var body: some View {
        NavigationStack {
                List(viewModel.records) { record in
                    Text(record.title)
                        .onAppear {
                            viewModel.records.last == record ? viewModel.loadRecords() : nil
                        }
                }
            .navigationTitle("Record List")
            .toolbar { toolBarItems }
            .onAppear { viewModel.loadRecords() }
            .overlay {
                if viewModel.isLoading {
                    ProgressView()
                }
            }
        }
    }
    
    @ToolbarContentBuilder
    var toolBarItems: some ToolbarContent {
        ToolbarItem(placement: .topBarTrailing) {
            Button("Add 1000 records") {
                viewModel.addRecords(amount: 1_000)
            }
        }
    }
}

#Preview {
    MainListView(
        viewModel: MainListViewModel(
            container: PreviewValues.modelContainer
        )
    )
}
