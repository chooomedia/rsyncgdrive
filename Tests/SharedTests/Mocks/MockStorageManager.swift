//
//  MockStorageManager.swift
//  MySyncApp Tests
//
//  Created: Mock für Testing
//

import Foundation
@testable import MySyncAppShared

/// Mock StorageManager für Tests
class MockStorageManager: StorageManager {
    var savedStatus: SyncStatus?
    var savedConfig: SyncConfig?
    var config: SyncConfig = SyncConfig()
    
    override func saveSyncStatus(_ status: SyncStatus) {
        savedStatus = status
    }
    
    override func loadSyncStatus() -> SyncStatus {
        return savedStatus ?? SyncStatus()
    }
    
    override func saveSyncConfig(_ config: SyncConfig) {
        savedConfig = config
        self.config = config
    }
    
    override func loadSyncConfig() -> SyncConfig {
        return config
    }
}

