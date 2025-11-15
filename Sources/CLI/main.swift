//
//  main.swift
//  MySyncApp CLI
//
//  Created: CLI Entry Point
//

import Foundation
import MySyncAppShared

/// CLI-Tool zum Testen der Sync-Funktionalität
@main
struct SyncCLI {
    static func main() {
        Task {
            await run()
        }
        // Warte auf Task-Completion (für CLI)
        RunLoop.main.run(until: Date(timeIntervalSinceNow: 30))
    }
    
    static func run() async {
        print("Google Drive Sync CLI")
        print("====================\n")
        
        let syncManager = SyncManager.shared
        let storageManager = StorageManager.shared
        
        // Lade Konfiguration
        let config = storageManager.loadSyncConfig()
        
        print("Aktuelle Konfiguration:")
        print("  Methode: \(config.syncMethod.displayName)")
        print("  Quelle: \(config.sourcePath)")
        print("  Ziel: \(config.destinationPath)")
        print("  Auto-Sync: \(config.autoSyncEnabled ? "Aktiviert" : "Deaktiviert")")
        print()
        
        // Zeige aktuellen Status
        let status = storageManager.loadSyncStatus()
        print("Aktueller Status: \(status.state.rawValue)")
        if let lastSync = status.lastSyncDate {
            print("Letzte Sync: \(lastSync.formattedForDisplay())")
        }
        if let error = status.errorMessage {
            print("Fehler: \(error)")
        }
        print()
        
        // Frage ob Sync gestartet werden soll
        print("Synchronisation starten? (j/n): ", terminator: "")
        if let input = readLine(), input.lowercased() == "j" {
            print("\nStarte Synchronisation...")
            
            // Setze Callback für Status-Updates
            syncManager.onStatusUpdate = { status in
                print("Status: \(status.state.rawValue)")
                if let progress = status.progress {
                    let percentage = Int(progress * 100)
                    print("Fortschritt: \(percentage)%")
                }
                if let currentFile = status.currentFile {
                    print("Aktuelle Datei: \(currentFile)")
                }
                if let error = status.errorMessage {
                    print("Fehler: \(error)")
                }
            }
            
            await syncManager.startSync()
            
            // Zeige finalen Status
            let finalStatus = storageManager.loadSyncStatus()
            print("\nSynchronisation abgeschlossen!")
            print("Status: \(finalStatus.state.rawValue)")
            if let lastSync = finalStatus.lastSyncDate {
                print("Letzte Sync: \(lastSync.formattedForDisplay())")
            }
        } else {
            print("Abgebrochen.")
        }
    }
}

