//
//  SyncState.swift
//  MySyncApp
//
//  Created: Shared Models
//

import Foundation

/// Repräsentiert den aktuellen Synchronisationsstatus
public enum SyncState: String, Codable {
    case idle = "idle"
    case syncing = "syncing"
    case success = "success"
    case error = "error"
}

/// Repräsentiert den verwendeten Sync-Methode
public enum SyncMethod: String, Codable, CaseIterable {
    case rsync = "rsync"
    case rclone = "rclone"
    
    public var displayName: String {
        switch self {
        case .rsync:
            return "rsync"
        case .rclone:
            return "rclone"
        }
    }
}

/// Vollständiger Synchronisationsstatus mit Metadaten
public struct SyncStatus: Codable {
    public var state: SyncState
    public var lastSyncDate: Date?
    public var errorMessage: String?
    public var progress: Double? // 0.0 - 1.0
    public var currentFile: String?
    
    public init(
        state: SyncState = .idle,
        lastSyncDate: Date? = nil,
        errorMessage: String? = nil,
        progress: Double? = nil,
        currentFile: String? = nil
    ) {
        self.state = state
        self.lastSyncDate = lastSyncDate
        self.errorMessage = errorMessage
        self.progress = progress
        self.currentFile = currentFile
    }
}

extension SyncStatus {
    /// Erstellt einen neuen Status mit aktualisiertem State
    public func updating(state: SyncState) -> SyncStatus {
        var updated = self
        updated.state = state
        return updated
    }
    
    /// Erstellt einen neuen Status mit aktualisiertem Progress
    public func updating(progress: Double, currentFile: String?) -> SyncStatus {
        var updated = self
        updated.progress = progress
        updated.currentFile = currentFile
        return updated
    }
}

