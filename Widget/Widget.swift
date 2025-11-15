//
//  Widget.swift
//  MySyncApp Widget
//
//  Created: Widget Entry Point
//

import WidgetKit
import SwiftUI

@main
struct SyncWidget: Widget {
    let kind: String = "SyncWidget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: SyncTimelineProvider()) { entry in
            WidgetEntryView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
        }
        .configurationDisplayName("Google Drive Sync Status")
        .description("Zeigt den aktuellen Status der Google Drive Synchronisation an.")
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
    }
}

/// Haupt-Widget-Entry-View
struct WidgetEntryView: View {
    var entry: SyncStatusEntry
    @Environment(\.widgetFamily) var family
    
    var body: some View {
        switch family {
        case .systemSmall:
            SmallWidgetView(entry: entry)
        case .systemMedium:
            MediumWidgetView(entry: entry)
        case .systemLarge:
            LargeWidgetView(entry: entry)
        default:
            SmallWidgetView(entry: entry)
        }
    }
}

#Preview(as: .systemSmall) {
    SyncWidget()
} timeline: {
    SyncStatusEntry(
        date: Date(),
        status: SyncStatus(state: .idle)
    )
    SyncStatusEntry(
        date: Date(),
        status: SyncStatus(state: .syncing, progress: 0.5)
    )
    SyncStatusEntry(
        date: Date(),
        status: SyncStatus(state: .success, lastSyncDate: Date())
    )
    SyncStatusEntry(
        date: Date(),
        status: SyncStatus(state: .error, errorMessage: "Verbindungsfehler")
    )
}

