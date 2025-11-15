//
//  SyncConfig.swift
//  MySyncApp
//
//  Created: Shared Models
//

import Foundation

/// Konfiguration für die Synchronisation
public struct SyncConfig: Codable {
    public var syncMethod: SyncMethod
    public var sourcePath: String
    public var destinationPath: String
    public var autoSyncEnabled: Bool
    public var autoSyncIntervalMinutes: Int // Minuten zwischen Auto-Syncs
    
    public init(
        syncMethod: SyncMethod = .rsync,
        sourcePath: String = "",
        destinationPath: String = "",
        autoSyncEnabled: Bool = false,
        autoSyncIntervalMinutes: Int = 60
    ) {
        self.syncMethod = syncMethod
        self.sourcePath = sourcePath
        self.destinationPath = destinationPath
        self.autoSyncEnabled = autoSyncEnabled
        self.autoSyncIntervalMinutes = autoSyncIntervalMinutes
    }
    
    /// Validiert die Konfiguration
    public func isValid() -> Bool {
        guard !sourcePath.isEmpty,
              !destinationPath.isEmpty else {
            return false
        }
        
        // Prüfe ob Pfade existieren (nur für Source, da Destination erstellt werden kann)
        let sourceURL = URL(fileURLWithPath: sourcePath)
        return FileManager.default.fileExists(atPath: sourceURL.path)
    }
}

