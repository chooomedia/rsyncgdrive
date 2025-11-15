//
//  SyncTimelineProvider.swift
//  MySyncApp Widget
//
//  Created: Widget Timeline Provider
//

import WidgetKit
import SwiftUI

/// Timeline Provider für das Widget
struct SyncTimelineProvider: TimelineProvider {
    typealias Entry = SyncStatusEntry
    
    func placeholder(in context: Context) -> SyncStatusEntry {
        SyncStatusEntry(
            date: Date(),
            status: SyncStatus(state: .idle)
        )
    }
    
    func getSnapshot(in context: Context, completion: @escaping (SyncStatusEntry) -> Void) {
        let storageManager = StorageManager.shared
        let status = storageManager.loadSyncStatus()
        let entry = SyncStatusEntry(date: Date(), status: status)
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<SyncStatusEntry>) -> Void) {
        let storageManager = StorageManager.shared
        let status = storageManager.loadSyncStatus()
        let entry = SyncStatusEntry(date: Date(), status: status)
        
        // Aktualisiere Widget alle 15 Minuten
        let nextUpdate = Calendar.current.date(byAdding: .minute, value: 15, to: Date())!
        let timeline = Timeline(entries: [entry], policy: .after(nextUpdate))
        
        completion(timeline)
    }
}

/// Widget Entry mit Sync-Status
struct SyncStatusEntry: TimelineEntry {
    let date: Date
    let status: SyncStatus
}

