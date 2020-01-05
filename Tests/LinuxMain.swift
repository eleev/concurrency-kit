import XCTest

import ConcurrencyKitTests

var tests = [XCTestCaseEntry]()
tests += ArrayConcurrentMapTests.allTests()
tests += AtomicBoolTests.allTests()
tests += AtomicIntTests.allTests()
tests += AtomicTests.allTests()
tests += DispatchQueue_AsyncAfterTests.allTests()
tests += DispatchQueue_OnceTests.allTests()
tests += ReadWriteLockTests.allTests()
tests += StatefullOperationTests.allTests()
tests += TaskTests.allTests()
tests += UnfairLockTests.allTests()
XCTMain(tests)
