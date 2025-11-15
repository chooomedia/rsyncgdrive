//
//  StorageManager.swift
//  MySyncApp
//
//  Created: Shared Services
//

import Foundation

/// Verwaltet die persistente Speicherung von Sync-Status und Konfiguration
/// Verwendet App Group Storage für Widget-Zugriff
public class StorageManager {
    public static let shared = StorageManager()
    
    // App Group Identifier - muss in Xcode konfiguriert werden
    private let appGroupIdentifier = "group.com.mysyncapp.shared"
    
    private var containerURL: URL? {
        FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: appGroupIdentifier)
    }
    
    private let statusFileName = "sync_status.json"
    private let configFileName = "sync_config.json"
    
    private init() {}
    
    // MARK: - Sync Status
    
    /// Speichert den aktuellen Sync-Status
    public func saveSyncStatus(_ status: SyncStatus) {
        guard let containerURL = containerURL else { return }
        
        let fileURL = containerURL.appendingPathComponent(statusFileName)
        
        do {
            let encoder = JSONEncoder()
            encoder.dateEncodingStrategy = .iso8601
            let data = try encoder.encode(status)
            try data.write(to: fileURL)
        } catch {
            print("Fehler beim Speichern des Sync-Status: \(error)")
        }
    }
    
    /// Lädt den gespeicherten Sync-Status
    public func loadSyncStatus() -> SyncStatus {
        guard let containerURL = containerURL else {
            return SyncStatus()
        }
        
        let fileURL = containerURL.appendingPathComponent(statusFileName)
        
        guard FileManager.default.fileExists(atPath: fileURL.path) else {
            return SyncStatus()
        }
        
        do {
            let data = try Data(contentsOf: fileURL)
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            return try decoder.decode(SyncStatus.self, from: data)
        } catch {
            print("Fehler beim Laden des Sync-Status: \(error)")
            return SyncStatus()
        }
    }
    
    // MARK: - Sync Config
    
    /// Speichert die Sync-Konfiguration
    public func saveSyncConfig(_ config: SyncConfig) {
        guard let containerURL = containerURL else { return }
        
        let fileURL = containerURL.appendingPathComponent(configFileName)
        
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(config)
            try data.write(to: fileURL)
        } catch {
            print("Fehler beim Speichern der Sync-Konfiguration: \(error)")
        }
    }
    
    /// Lädt die gespeicherte Sync-Konfiguration
    public func loadSyncConfig() -> SyncConfig {
        guard let containerURL = containerURL else {
            return SyncConfig()
        }
        
        let fileURL = containerURL.appendingPathComponent(configFileName)
        
        guard FileManager.default.fileExists(atPath: fileURL.path) else {
            return SyncConfig()
        }
        
        do {
            let data = try Data(contentsOf: fileURL)
            let decoder = JSONDecoder()
            return try decoder.decode(SyncConfig.self, from: data)
        } catch {
            print("Fehler beim Laden der Sync-Konfiguration: \(error)")
            return SyncConfig()
        }
    }
}

