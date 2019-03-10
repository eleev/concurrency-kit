//
//  ReadWriteLockTests.swift
//  concurrency-kitTests
//
//  Created by Astemir Eleev on 10/03/2019.
//  Copyright © 2019 Astemir Eleev. All rights reserved.
//

import XCTest
@testable import concurrency_kit

class ReadWriteLockTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testReadLock() {
        var value = 0
        let lock = ReadWriteLock()
        
        let concurrentQueue = DispatchQueue.global()
        let anotherConcurrentQueue = DispatchQueue.global()
        let dispatchGroup = DispatchGroup()
        let anotherDispatchGroup = DispatchGroup()
        let count = 10_000
        
        lock.readLock()
        for _ in 0..<count {
            dispatchGroup.enter()
            
            concurrentQueue.async {
                value += 1
                
                if value == count {
                    XCTAssertEqual(value, count)
                }
                dispatchGroup.leave()
            }
        }
        let extation = expectation(description: "Dispatch Group Completion")

        dispatchGroup.notify(queue: concurrentQueue) {
            lock.unlock()
            extation.fulfill()
        }
        
        // Tries to read the value, but the value is locked by the read lock. So it will always be equal to the caught value until the read lock is reelased
        var caughtValue = value
        
        for _ in 0..<count / 2 {
            anotherDispatchGroup.enter()
            
            anotherConcurrentQueue.async {
                DispatchQueue.once(token: "caught") {
                    caughtValue = value
                }
                
                XCTAssertEqual(value, caughtValue)
                anotherDispatchGroup.leave()
            }
        }
        
        let anotherExtation = expectation(description: "Dispatch Group Completion")
        anotherDispatchGroup.notify(queue: anotherConcurrentQueue) {
            anotherExtation.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)    }
    
    func testWriteLock() {
        var value = 0
        let lock = ReadWriteLock()
        
        let concurrentQueue = DispatchQueue.global()
        let anotherConcurrentQueue = DispatchQueue.global()
        let dispatchGroup = DispatchGroup()
        let anotherDispatchGroup = DispatchGroup()
        let count = 10_000

        for _ in 0..<count {
            dispatchGroup.enter()
            
            concurrentQueue.async {
                lock.writeLock()
                value += 1
                
                if value == count {
                    XCTAssertEqual(value, count)
                }
                lock.unlock()
                dispatchGroup.leave()
            }
        }
        
        // Tries to modify the value while it's being written
        for index in 0..<count / 2 {
            anotherDispatchGroup.enter()
            anotherConcurrentQueue.async {
                value = index
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
        
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
