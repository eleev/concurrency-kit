//
//  AtomicTests.swift
//  concurrency-kitTests
//
//  Created by Astemir Eleev on 10/03/2019.
//  Copyright © 2019 Astemir Eleev. All rights reserved.
//

import XCTest
@testable import concurrency_kit

class AtomicTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testModify() {
        let atomic = Atomic(0)
        atomic.modify { $0 + 10 }
        XCTAssertEqual(atomic.value, 10)
    }
    
    func testWith() {
        let atomic = Atomic(0)
        let result = atomic.with { $0 + 10 }
        XCTAssertEqual(atomic.value, 0)
        XCTAssertEqual(result, 10)
    }
    
    func testSet() {
        let atomic = Atomic(0)
        atomic.set(10)
        XCTAssertEqual(atomic.value, 10)
    }
    
    func testGet() {
        let atomic = Atomic(0)
        atomic.set(30)
        XCTAssertEqual(atomic.value, 30)
    }
    
    func testSwap() {
        let atomic = Atomic(1)
        let oldValue = atomic.swap(10)
        XCTAssertEqual(oldValue, 1)
        XCTAssertEqual(atomic.value, 10)
    }
    
    func testRethrowFromWithValue() {
        let atomic = Atomic(5)
        var didCatch = false
        
        do {
            try atomic.with { value in
                throw NSError(domain: NSCocoaErrorDomain, code: value, userInfo: nil)
            }
            XCTFail()
        } catch let error as NSError {
            didCatch = true
            XCTAssertEqual(error, NSError(domain: NSCocoaErrorDomain, code: 5, userInfo: nil))
        }
        
        if atomic.mutex.tryLock() == 0 {
            atomic.mutex.unlock()
        } else {
            XCTFail()
        }
        XCTAssert(didCatch)
    }

    func testRethrowFromModify() {
        let atomic = Atomic(5)
        var didCatch = false
        
        do {
            try atomic.modify { value in
                throw NSError(domain: NSCocoaErrorDomain, code: value, userInfo: nil)
            }
            XCTFail()
        } catch let error as NSError {
            didCatch = true
            XCTAssertEqual(error, NSError(domain: NSCocoaErrorDomain, code: 5, userInfo: nil))
        }
        
        if atomic.mutex.tryLock() == 0 {
            atomic.mutex.unlock()
        } else {
            XCTFail()
        }
        XCTAssert(didCatch)
    }

    func testHighlyContestedLocking() {
        let contestedAtomic = Atomic(0)

        let concurrentQueue = DispatchQueue.global()
        let dispatchGroup = DispatchGroup()
        let count = 10_000
        
        for _ in 0..<count {
            dispatchGroup.enter()
            concurrentQueue.async {
                contestedAtomic.modify { $0 + 1 }
                dispatchGroup.leave()
            }
        }
        
        let extation = expectation(description: "Dispatch Group Completion")

        dispatchGroup.notify(queue: concurrentQueue) {
            extation.fulfill()
        }

        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertEqual(contestedAtomic.value, count)
        print("value: ", contestedAtomic.value)
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
