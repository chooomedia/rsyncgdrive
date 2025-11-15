//
//  SyncManager.swift
//  MySyncApp
//
//  Created: Shared Services
//

import Foundation

/// Verwaltet die Synchronisation mit rsync oder rclone
public class SyncManager {
    public static let shared = SyncManager()
    
    private let storageManager = StorageManager.shared
    private var currentTask: Task<Void, Never>?
    
    // Callback für Status-Updates
    public var onStatusUpdate: ((SyncStatus) -> Void)?
    
    private init() {}
    
    // MARK: - Public Methods
    
    /// Startet die Synchronisation asynchron
    public func startSync() async {
        // Breche vorherige Sync ab falls vorhanden
        currentTask?.cancel()
        
        let config = storageManager.loadSyncConfig()
        
        guard config.isValid() else {
            let errorStatus = SyncStatus(
                state: .error,
                errorMessage: "Ungültige Konfiguration: Bitte Source- und Destination-Pfade prüfen"
            )
            updateStatus(errorStatus)
            return
        }
        
        currentTask = Task {
            await performSync(config: config)
        }
        
        await currentTask?.value
    }
    
    /// Stoppt die laufende Synchronisation
    public func stopSync() {
        currentTask?.cancel()
        let status = storageManager.loadSyncStatus()
        updateStatus(status.updating(state: .idle))
    }
    
    /// Lädt den aktuellen Status
    public func getCurrentStatus() -> SyncStatus {
        storageManager.loadSyncStatus()
    }
    
    // MARK: - Private Methods
    
    private func performSync(config: SyncConfig) async {
        // Status auf "syncing" setzen
        let syncingStatus = SyncStatus(state: .syncing)
        updateStatus(syncingStatus)
        
        do {
            let success: Bool
            
            switch config.syncMethod {
            case .rsync:
                success = try await runRsync(
                    source: config.sourcePath,
                    destination: config.destinationPath
                )
            case .rclone:
                success = try await runRclone(
                    source: config.sourcePath,
                    destination: config.destinationPath
                )
            }
            
            if Task.isCancelled {
                updateStatus(SyncStatus(state: .idle))
                return
            }
            
            if success {
                let successStatus = SyncStatus(
                    state: .success,
                    lastSyncDate: Date()
                )
                updateStatus(successStatus)
            } else {
                let errorStatus = SyncStatus(
                    state: .error,
                    errorMessage: "Sync-Befehl fehlgeschlagen"
                )
                updateStatus(errorStatus)
            }
        } catch {
            let errorStatus = SyncStatus(
                state: .error,
                errorMessage: error.localizedDescription
            )
            updateStatus(errorStatus)
        }
    }
    
    private func runRsync(source: String, destination: String) async throws -> Bool {
        // TODO: Implementiere rsync-Befehl hier
        // Beispiel-Struktur:
        // let process = Process()
        // process.executableURL = URL(fileURLWithPath: "/usr/bin/rsync")
        // process.arguments = ["-av", "--delete", source, destination]
        // ...
        
        // Simuliere Sync für MVP
        try await Task.sleep(nanoseconds: 2_000_000_000) // 2 Sekunden
        
        // Prüfe ob Task abgebrochen wurde
        if Task.isCancelled {
            throw CancellationError()
        }
        
        // Für MVP: Simuliere Erfolg
        return true
    }
    
    private func runRclone(source: String, destination: String) async throws -> Bool {
        // TODO: Implementiere rclone-Befehl hier
        // Beispiel-Struktur:
        // let process = Process()
        // process.executableURL = URL(fileURLWithPath: "/usr/local/bin/rclone")
        // process.arguments = ["sync", source, destination]
        // ...
        
        // Simuliere Sync für MVP
        try await Task.sleep(nanoseconds: 2_000_000_000) // 2 Sekunden
        
        // Prüfe ob Task abgebrochen wurde
        if Task.isCancelled {
            throw CancellationError()
        }
        
        // Für MVP: Simuliere Erfolg
        return true
    }
    
    private func updateStatus(_ status: SyncStatus) {
        storageManager.saveSyncStatus(status)
        onStatusUpdate?(status)
    }
}

