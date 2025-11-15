//
//  SyncViewModelTests.swift
//  MySyncApp Tests
//
//  Created: Unit Tests
//

import XCTest
import SwiftUI
@testable import MySyncApp

@MainActor
final class SyncViewModelTests: XCTestCase {
    var viewModel: SyncViewModel!
    var storageManager: StorageManager!
    
    override func setUp() {
        super.setUp()
        storageManager = StorageManager.shared
        viewModel = SyncViewModel()
    }
    
    override func tearDown() {
        // Cleanup
        let emptyConfig = SyncConfig()
        storageManager.saveSyncConfig(emptyConfig)
        super.tearDown()
    }
    
    func testViewModelInitialization() {
        XCTAssertNotNil(viewModel.syncStatus)
        XCTAssertNotNil(viewModel.syncConfig)
        XCTAssertFalse(viewModel.isSyncing)
    }
    
    func testConfigSave() {
        viewModel.syncConfig.sourcePath = "/test/path"
        viewModel.syncConfig.destinationPath = "/test/dest"
        viewModel.saveConfig()
        
        let loadedConfig = storageManager.loadSyncConfig()
        XCTAssertEqual(loadedConfig.sourcePath, "/test/path")
        XCTAssertEqual(loadedConfig.destinationPath, "/test/dest")
    }
    
    func testStatusRefresh() {
        let testStatus = SyncStatus(state: .success, lastSyncDate: Date())
        storageManager.saveSyncStatus(testStatus)
        
        viewModel.refreshStatus()
        
        XCTAssertEqual(viewModel.syncStatus.state, .success)
        XCTAssertNotNil(viewModel.syncStatus.lastSyncDate)
    }
}

