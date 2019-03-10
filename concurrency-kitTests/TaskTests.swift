//
//  TaskTests.swift
//  concurrency-kitTests
//
//  Created by Astemir Eleev on 10/03/2019.
//  Copyright © 2019 Astemir Eleev. All rights reserved.
//

import XCTest
@testable import concurrency_kit

class TaskTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testPerform() {
        let expectation = XCTestExpectation(description: "Task Expectation")
        
        let iterationTask = Task { controller in
            DispatchQueue.global().async {
                (0...10_000).forEach({
                    let _ = $0 * $0
                })
                controller.finish()
            }
        }
        
        iterationTask.perform { outcome in
            XCTAssertEqual(outcome, Task.Outcome.success)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    func testGroup() {
        let expectation = XCTestExpectation(description: "Task Expectation")

        func longRunningTaskMock(completion: @escaping () -> Void) {
            DispatchQueue.global().async {
                (0...10_000).forEach({
                    let _ = $0 * $0
                })
                completion()
            }
        }
        
        let longRunningOperations = [longRunningTaskMock, longRunningTaskMock, longRunningTaskMock, longRunningTaskMock, longRunningTaskMock]
        
        let anotherSetOfLongRunningOperations = longRunningOperations
        
        let longRunningTasks = longRunningOperations.map { operation in
            Task.init(closure: { controller in
                operation() {
                    controller.finish()
                }
            })
        }
        
        let anotherSeOfLongRunningTasks = anotherSetOfLongRunningOperations.map { operation in
            Task.init(closure: { controller in
                operation() {
                    controller.finish()
                }
            })
        }
        
        let group = Task.group(longRunningTasks + anotherSeOfLongRunningTasks)
        group.perform { outcome in
            XCTAssertEqual(outcome, Task.Outcome.success)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 8.0)
    }
    
    func testSequence() {
        let expectation = XCTestExpectation(description: "Task Expectation")
        
        func longRunningTaskMock(completion: @escaping () -> Void) {
            DispatchQueue.global().async {
                (0...10_000).forEach({
                    let _ = $0 * $0
                })
                completion()
            }
        }
        
        let longRunningOperations = [longRunningTaskMock, longRunningTaskMock, longRunningTaskMock, longRunningTaskMock, longRunningTaskMock]
        
        let anotherSetOfLongRunningOperations = longRunningOperations
        
        let longRunningTasks = longRunningOperations.map { operation in
            Task.init(closure: { controller in
                operation() {
                    controller.finish()
                }
            })
        }
        
        let anotherSeOfLongRunningTasks = anotherSetOfLongRunningOperations.map { operation in
            Task.init(closure: { controller in
                operation() {
                    controller.finish()
                }
            })
        }
        
        let group = Task.sequence(longRunningTasks + anotherSeOfLongRunningTasks)
        group.perform { outcome in
            XCTAssertEqual(outcome, Task.Outcome.success)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 8.0)
    }
    

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
