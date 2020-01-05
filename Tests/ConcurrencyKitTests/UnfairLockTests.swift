//
//  UnfairLockTests.swift
//  ConcurrencyKitTests
//
//  Created by Astemir Eleev on 10/03/2019.
//  Copyright © 2019 Astemir Eleev. All rights reserved.
//

import XCTest
@testable import ConcurrencyKit

class UnfairLockTests: XCTestCase {

    static var allTests = [
        ("testModify", testModify),
        ("testTryLock", testTryLock),
        ("testAsync", testAsync),
        ("testAsyncTwoQueues", testAsyncTwoQueues),
    ]
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testModify() {
        let lock = UnfairLock()
        var value = 0
        
        lock.lock()
        value = 10
        lock.unlock()
        XCTAssertEqual(value, 10)
    }
    
    func testTryLock() {
        let lock = UnfairLock()
        var value = 0
        
        lock.tryLock()
        value = 10
        lock.unlock()
        XCTAssertEqual(value, 10)
    }
    
    func testAsync() {
        var value = 0
        let lock = UnfairLock()
        
        let concurrentQueue = DispatchQueue.global()
        let dispatchGroup = DispatchGroup()
        let count = 10_000
        
        for _ in 0..<count {
            dispatchGroup.enter()
            concurrentQueue.async {
                lock.lock()
                value += 1
                lock.unlock()
                dispatchGroup.leave()
            }
        }
        
        let extation = expectation(description: "Dispatch Group Completion")
        
        dispatchGroup.notify(queue: concurrentQueue) {
            extation.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertEqual(value, count)
        print("value: ", value)
    }
    
    func testAsyncTwoQueues() {
        var value = 0
        let lock = UnfairLock()
        
        let concurrentQueue = DispatchQueue.global()
        let anotherConcurrentQueue = DispatchQueue.global()
        let dispatchGroup = DispatchGroup()
        let anotherDispatchGroup = DispatchGroup()
        let count = 10_000
        
        for _ in 0..<count {
            dispatchGroup.enter()
            concurrentQueue.async {
                lock.lock()
                value += 1
                lock.unlock()
                dispatchGroup.leave()
            }
        }
        
        for _ in 0..<count {
            anotherDispatchGroup.enter()
            anotherConcurrentQueue.async {
                lock.lock()
                value += 1
                lock.unlock()
                anotherDispatchGroup.leave()
            }
        }
        
        let extation = expectation(description: "Dispatch Group Completion")
        let anotherExtation = expectation(description: "Dispatch Group Completion")
        
        dispatchGroup.notify(queue: concurrentQueue) {
            extation.fulfill()
        }
        
        anotherDispatchGroup.notify(queue: anotherConcurrentQueue) {
            anotherExtation.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertEqual(value, count * 2)
        print("value: ", value)
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
