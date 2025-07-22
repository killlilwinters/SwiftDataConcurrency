//
//  DispatchQueue+Ext.swift
//  SwiftDataConcurrency
//
//  Created by Maksym Horobets on 22.07.2025.
//

import Dispatch

extension DispatchQueue {
    nonisolated static var currentLabel: String {
        return String(validatingCString: __dispatch_queue_get_label(nil)) ?? "unknown"
    }
}
