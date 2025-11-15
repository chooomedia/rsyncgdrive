//
//  WidgetStatusView.swift
//  MySyncApp Widget
//
//  Created: Widget Views
//

import SwiftUI
import WidgetKit

/// Widget-Ansicht für kleine Größe
struct SmallWidgetView: View {
    var entry: SyncStatusEntry
    
    var body: some View {
        VStack(spacing: 8) {
            StatusIconView(state: entry.status.state, size: 30)
            
            Text(statusText)
                .font(.caption)
                .foregroundColor(.secondary)
            
            if let lastSync = entry.status.lastSyncDate {
                Text(lastSync.shortRelativeFormat())
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private var statusText: String {
        switch entry.status.state {
        case .idle:
            return "Bereit"
        case .syncing:
            return "Sync..."
        case .success:
            return "Erfolg"
        case .error:
            return "Fehler"
        }
    }
}

/// Widget-Ansicht für mittlere Größe
struct MediumWidgetView: View {
    var entry: SyncStatusEntry
    
    var body: some View {
        HStack(spacing: 16) {
            StatusIconView(state: entry.status.state, size: 40)
            
            VStack(alignment: .leading, spacing: 4) {
                Text("Google Drive Sync")
                    .font(.headline)
                
                Text(statusText)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                if let lastSync = entry.status.lastSyncDate {
                    Text("Letzte Sync: \(lastSync.shortRelativeFormat())")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                if let errorMessage = entry.status.errorMessage {
                    Text(errorMessage)
                        .font(.caption2)
                        .foregroundColor(.red)
                        .lineLimit(2)
                }
            }
            
            Spacer()
        }
        .padding()
    }
    
    private var statusText: String {
        switch entry.status.state {
        case .idle:
            return "Bereit für Synchronisation"
        case .syncing:
            return "Synchronisiere..."
        case .success:
            return "Erfolgreich synchronisiert"
        case .error:
            return "Fehler aufgetreten"
        }
    }
}

/// Widget-Ansicht für große Größe
struct LargeWidgetView: View {
    var entry: SyncStatusEntry
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                StatusIconView(state: entry.status.state, size: 50)
                Text("Google Drive Sync")
                    .font(.title2)
                    .bold()
                Spacer()
            }
            
            Divider()
            
            VStack(alignment: .leading, spacing: 8) {
                Label(statusText, systemImage: statusIcon)
                    .font(.headline)
                
                if let lastSync = entry.status.lastSyncDate {
                    Label("Letzte Sync: \(lastSync.formattedForDisplay())", systemImage: "clock")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                if let errorMessage = entry.status.errorMessage {
                    Label(errorMessage, systemImage: "exclamationmark.triangle")
                        .font(.caption)
                        .foregroundColor(.red)
                }
                
                if entry.status.state == .syncing,
                   let progress = entry.status.progress {
                    ProgressView(value: progress)
                        .progressViewStyle(.linear)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            Spacer()
        }
        .padding()
    }
    
    private var statusText: String {
        switch entry.status.state {
        case .idle:
            return "Bereit für Synchronisation"
        case .syncing:
            return "Synchronisiere..."
        case .success:
            return "Erfolgreich synchronisiert"
        case .error:
            return "Fehler aufgetreten"
        }
    }
    
    private var statusIcon: String {
        switch entry.status.state {
        case .idle:
            return "circle.fill"
        case .syncing:
            return "arrow.triangle.2.circlepath"
        case .success:
            return "checkmark.circle.fill"
        case .error:
            return "exclamationmark.triangle.fill"
        }
    }
}

