//
//  SyncManagerTests.swift
//  MySyncApp Tests
//
//  Created: Unit Tests
//

import XCTest
@testable import MySyncAppShared

final class SyncManagerTests: XCTestCase {
    var syncManager: SyncManager!
    var mockStorage: MockStorageManager!
    
    override func setUp() {
        super.setUp()
        mockStorage = MockStorageManager()
        // Note: SyncManager verwendet Singleton-Pattern
        // Für echte Tests müsste Dependency Injection verwendet werden
        syncManager = SyncManager.shared
    }
    
    override func tearDown() {
        syncManager = nil
        mockStorage = nil
        super.tearDown()
    }
    
    func testSyncStatusInitialization() {
        let status = SyncStatus()
        XCTAssertEqual(status.state, .idle)
        XCTAssertNil(status.lastSyncDate)
        XCTAssertNil(status.errorMessage)
    }
    
    func testSyncStatusUpdate() {
        var status = SyncStatus()
        status = status.updating(state: .syncing)
        XCTAssertEqual(status.state, .syncing)
        
        status = status.updating(state: .success)
        XCTAssertEqual(status.state, .success)
    }
    
    func testSyncConfig_isValid_withEmptyPaths_shouldReturnFalse() {
        // Arrange
        let config = TestFixtures.invalidSyncConfig()
        
        // Act & Assert
        XCTAssertFalse(config.isValid(), "Leere Konfiguration sollte ungültig sein")
    }
    
    func testSyncConfig_isValid_withValidPaths_shouldReturnTrue() throws {
        // Arrange
        let testDir = try TestFixtures.createTempDirectory(name: "test_source")
        defer { TestFixtures.cleanupTempDirectory(testDir) }
        
        var config = TestFixtures.validSyncConfig(
            sourcePath: testDir.path,
            destinationPath: "/test/dest"
        )
        
        // Act & Assert
        XCTAssertTrue(config.isValid(), "Konfiguration mit existierendem Source sollte gültig sein")
    }
    
    func testStorageManager_saveSyncStatus_shouldPersistStatus() {
        // Arrange
        let testStatus = TestFixtures.successStatus()
        
        // Act
        mockStorage.saveSyncStatus(testStatus)
        let loadedStatus = mockStorage.loadSyncStatus()
        
        // Assert
        XCTAssertEqual(loadedStatus.state, testStatus.state)
        XCTAssertNotNil(loadedStatus.lastSyncDate)
    }
    
    func testStorageManager_saveSyncConfig_shouldPersistConfig() {
        // Arrange
        let testConfig = TestFixtures.validSyncConfig(
            syncMethod: .rclone,
            sourcePath: "/test/source",
            destinationPath: "/test/dest"
        )
        
        // Act
        mockStorage.saveSyncConfig(testConfig)
        let loadedConfig = mockStorage.loadSyncConfig()
        
        // Assert
        XCTAssertEqual(loadedConfig.syncMethod, testConfig.syncMethod)
        XCTAssertEqual(loadedConfig.sourcePath, testConfig.sourcePath)
        XCTAssertEqual(loadedConfig.destinationPath, testConfig.destinationPath)
    }
    
    // MARK: - SyncManager Tests (mit Fixtures)
    
    func testSyncManager_getCurrentStatus_shouldReturnCurrentStatus() {
        // Arrange
        let expectedStatus = TestFixtures.idleStatus()
        mockStorage.saveSyncStatus(expectedStatus)
        
        // Act
        let currentStatus = syncManager.getCurrentStatus()
        
        // Assert
        XCTAssertEqual(currentStatus.state, expectedStatus.state)
    }
}

