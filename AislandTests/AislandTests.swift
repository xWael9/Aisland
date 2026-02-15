//
//  AislandTests.swift
//  AislandTests
//
//  Created by Aisland on 2026-02-15.
//

import XCTest
@testable import Aisland

final class AislandTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testWindowManagerSingleton() throws {
        let manager1 = WindowManager.shared
        let manager2 = WindowManager.shared
        XCTAssertTrue(manager1 === manager2, "WindowManager should be a singleton")
    }

    func testHoverDetectorInitialization() throws {
        let detector = HoverDetector()
        XCTAssertNotNil(detector, "HoverDetector should initialize successfully")
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
}
