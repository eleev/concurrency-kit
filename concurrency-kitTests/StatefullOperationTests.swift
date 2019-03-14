//
//  StatefullOperationTests.swift
//  concurrency-kitTests
//
//  Created by Astemir Eleev on 14/03/2019.
//  Copyright © 2019 Astemir Eleev. All rights reserved.
//

import XCTest
@testable import concurrency_kit

class StatefullOperationTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testOperation() {
        class MockStatefullOperation: StatefulOperation {
        
            private var callback: (StatefulOperation) -> Void
            
            init(callback: @escaping (StatefulOperation) -> Void) {
                self.callback = callback
            }
            
            override func executableSection() {
                DispatchQueue.global().async {
                    sleep(3)
                    self.finish()
                    self.callback(self)
                }
            }
        }
         
        
        let expectation = XCTestExpectation(description: "Operation Expectation")
        
        let statefullOperation = MockStatefullOperation {
            XCTAssertEqual($0.state, .finished)
            expectation.fulfill()
        }

        XCTAssertEqual(statefullOperation.state, .ready)
        statefullOperation.start()
        
        XCTAssertEqual(statefullOperation.state, .executing)
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    func testInterruptedOperation() {
        class MockStatefullOperation: StatefulOperation {
            
            private var callback: (StatefulOperation) -> Void
            
            init(callback: @escaping (StatefulOperation) -> Void) {
                self.callback = callback
            }
            
            override func executableSection() {
                DispatchQueue.global().async {
                    sleep(3)
                    
                    self.finishIfNotCancelled()
                    self.callback(self)
                }
            }
        }
        
        
        let expectation = XCTestExpectation(description: "Operation Expectation")
        
        let statefullOperation = MockStatefullOperation {
            XCTAssertEqual($0.state, .cancelled)
            expectation.fulfill()
        }
        
        XCTAssertEqual(statefullOperation.state, .ready)
        statefullOperation.start()
        XCTAssertEqual(statefullOperation.state, .executing)
        
        // Then after 0.75 seconds the operation by some reason is interrupted and it was decided to cancel it
        DispatchQueue.main.asyncAfter(seconds: 0.75) {
            statefullOperation.interrupt()
            
            XCTAssertEqual(statefullOperation.state, .cancelled)
            XCTAssertEqual(statefullOperation.isCancelled, true)
        }
        
        wait(for: [expectation], timeout: 5.0)
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
