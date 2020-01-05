//
//  DispatchQueue+OnceTests.swift
//  ConcurrencyKitTests
//
//  Created by Astemir Eleev on 10/03/2019.
//  Copyright © 2019 Astemir Eleev. All rights reserved.
//

import XCTest
@testable import ConcurrencyKit

class DispatchQueue_OnceTests: XCTestCase {

    static var allTests = [
        ("test", test)
    ]
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test() {
        var occurences = 0
        let dispatchQueue = DispatchQueue.global()
        let dispatchGroup = DispatchGroup()
        
        for _ in 0..<100 {
            dispatchGroup.enter()
            dispatchQueue.async {
                DispatchQueue.once(token: "Unique Id") {
                    occurences += 1
                }
                dispatchGroup.leave()
            }
        }
        let extation = expectation(description: "Dispatch Group Completion")
        dispatchGroup.notify(queue: dispatchQueue) {
            extation.fulfill()
        }
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertEqual(occurences, 1)
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
