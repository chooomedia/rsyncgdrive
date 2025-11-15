//
//  SyncViewModel.swift
//  MySyncApp
//
//  Created: App ViewModels
//

import Foundation
import SwiftUI
import Combine

/// ViewModel für die Sync-Status-Verwaltung
@MainActor
public class SyncViewModel: ObservableObject {
    @Published public var syncStatus: SyncStatus = SyncStatus()
    @Published public var syncConfig: SyncConfig = SyncConfig()
    @Published public var isSyncing: Bool = false
    
    private let syncManager = SyncManager.shared
    private let storageManager = StorageManager.shared
    private var cancellables = Set<AnyCancellable>()
    
    public init() {
        // Lade initiale Daten
        syncStatus = storageManager.loadSyncStatus()
        syncConfig = storageManager.loadSyncConfig()
        
        // Setze Callback für Status-Updates
        syncManager.onStatusUpdate = { [weak self] status in
            Task { @MainActor in
                self?.syncStatus = status
                self?.isSyncing = (status.state == .syncing)
            }
        }
    }
    
    /// Startet die Synchronisation
    public func startSync() {
        guard !isSyncing else { return }
        
        isSyncing = true
        Task {
            await syncManager.startSync()
            isSyncing = false
        }
    }
    
    /// Stoppt die Synchronisation
    public func stopSync() {
        syncManager.stopSync()
        isSyncing = false
    }
    
    /// Speichert die Konfiguration
    public func saveConfig() {
        storageManager.saveSyncConfig(syncConfig)
    }
    
    /// Aktualisiert den Status manuell
    public func refreshStatus() {
        syncStatus = storageManager.loadSyncStatus()
    }
}

