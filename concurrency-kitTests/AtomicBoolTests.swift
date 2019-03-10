//
//  AtomicBoolTests.swift
//  concurrency-kitTests
//
//  Created by Astemir Eleev on 10/03/2019.
//  Copyright © 2019 Astemir Eleev. All rights reserved.
//

import XCTest
@testable import concurrency_kit

class AtomicBoolTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testSet() {
        let atomic = AtomicBool(true)
        atomic.set(false)
        XCTAssertEqual(atomic.value, false)
    }
    
    func testGet() {
        let atomic = AtomicBool(false)
        atomic.set(true)
        let value = atomic.get()
        XCTAssertEqual(value, true)
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
