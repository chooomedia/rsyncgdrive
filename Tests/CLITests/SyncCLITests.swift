//
//  SyncCLITests.swift
//  MySyncApp Tests
//
//  Created: Unit Tests für CLI
//

import XCTest
import MySyncAppShared

final class SyncCLITests: XCTestCase {
    var storageManager: StorageManager!
    
    override func setUp() {
        super.setUp()
        storageManager = StorageManager.shared
    }
    
    override func tearDown() {
        // Cleanup
        let emptyConfig = SyncConfig()
        storageManager.saveSyncConfig(emptyConfig)
        super.tearDown()
    }
    
    func testCLICanLoadConfig() {
        let config = storageManager.loadSyncConfig()
        XCTAssertNotNil(config)
    }
    
    func testCLICanLoadStatus() {
        let status = storageManager.loadSyncStatus()
        XCTAssertNotNil(status)
    }
}

