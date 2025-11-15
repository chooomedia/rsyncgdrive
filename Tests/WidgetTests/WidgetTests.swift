//
//  WidgetTests.swift
//  MySyncApp Tests
//
//  Created: Unit Tests
//

import XCTest
import WidgetKit
@testable import MySyncApp

final class WidgetTests: XCTestCase {
    var timelineProvider: SyncTimelineProvider!
    var storageManager: StorageManager!
    
    override func setUp() {
        super.setUp()
        timelineProvider = SyncTimelineProvider()
        storageManager = StorageManager.shared
    }
    
    func testTimelineProviderPlaceholder() {
        let placeholder = timelineProvider.placeholder(in: MockContext())
        XCTAssertNotNil(placeholder)
        XCTAssertEqual(placeholder.status.state, .idle)
    }
    
    func testTimelineProviderSnapshot() async {
        let expectation = expectation(description: "Snapshot loaded")
        
        timelineProvider.getSnapshot(in: MockContext()) { entry in
            XCTAssertNotNil(entry)
            XCTAssertNotNil(entry.date)
            XCTAssertNotNil(entry.status)
            expectation.fulfill()
        }
        
        await fulfillment(of: [expectation], timeout: 1.0)
    }
    
    func testTimelineProviderTimeline() async {
        let expectation = expectation(description: "Timeline loaded")
        
        timelineProvider.getTimeline(in: MockContext()) { timeline in
            XCTAssertNotNil(timeline)
            XCTAssertFalse(timeline.entries.isEmpty)
            expectation.fulfill()
        }
        
        await fulfillment(of: [expectation], timeout: 1.0)
    }
}

// Mock Context für Tests
struct MockContext {
    var family: WidgetFamily = .systemSmall
    var isPreview: Bool = false
    var displaySize: CGSize = CGSize(width: 100, height: 100)
}

extension MockContext: TimelineProviderContext {}

