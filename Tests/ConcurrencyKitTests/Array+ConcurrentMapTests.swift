//
//  Array+ConcurrentMapTests.swift
//  ConcurrencyKitTests
//
//  Created by Astemir Eleev on 02/06/2019.
//  Copyright © 2019 Astemir Eleev. All rights reserved.
//

import XCTest
@testable import ConcurrencyKit

final class ArrayConcurrentMapTests: XCTestCase {
    
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
        let elements = Array<Int>(repeating: 5, count: 100000)
        
        measure {
            let _ = elements.concurrentMap { element -> Int in
                return element * element
            }
        }
        
//        measure {
//            var output = [elements.count]
//
//            for (index, element) in elements.enumerated() {
//                let result = element * index
//                output.append(result)
//            }
//        }
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
