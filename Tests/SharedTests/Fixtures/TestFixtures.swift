//
//  TestFixtures.swift
//  MySyncApp Tests
//
//  Created: Test Fixtures
//

import Foundation
@testable import MySyncAppShared

/// Test-Fixtures für wiederkehrende Test-Daten
enum TestFixtures {
    
    // MARK: - SyncConfig
    
    static func validSyncConfig(
        sourcePath: String = "/test/source",
        destinationPath: String = "/test/dest",
        syncMethod: SyncMethod = .rsync
    ) -> SyncConfig {
        var config = SyncConfig()
        config.syncMethod = syncMethod
        config.sourcePath = sourcePath
        config.destinationPath = destinationPath
        config.autoSyncEnabled = false
        config.autoSyncIntervalMinutes = 60
        return config
    }
    
    static func invalidSyncConfig() -> SyncConfig {
        return SyncConfig() // Leere Config ist ungültig
    }
    
    // MARK: - SyncStatus
    
    static func idleStatus() -> SyncStatus {
        return SyncStatus(state: .idle)
    }
    
    static func syncingStatus(progress: Double? = nil) -> SyncStatus {
        return SyncStatus(
            state: .syncing,
            progress: progress,
            currentFile: progress != nil ? "test-file.txt" : nil
        )
    }
    
    static func successStatus(lastSyncDate: Date = Date()) -> SyncStatus {
        return SyncStatus(
            state: .success,
            lastSyncDate: lastSyncDate
        )
    }
    
    static func errorStatus(message: String = "Test error") -> SyncStatus {
        return SyncStatus(
            state: .error,
            errorMessage: message
        )
    }
    
    // MARK: - File System
    
    static func createTempDirectory(name: String) throws -> URL {
        let tempDir = FileManager.default.temporaryDirectory
        let testDir = tempDir.appendingPathComponent(name)
        try FileManager.default.createDirectory(
            at: testDir,
            withIntermediateDirectories: true
        )
        return testDir
    }
    
    static func cleanupTempDirectory(_ url: URL) {
        try? FileManager.default.removeItem(at: url)
    }
}

