import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(ArrayConcurrentMapTests.allTests),
        testCase(AtomicBoolTests.allTests),
        testCase(AtomicIntTests.allTests),
        testCase(AtomicTests.allTests),
        testCase(DispatchQueue_AsyncAfterTests.allTests),
        testCase(DispatchQueue_OnceTests.allTests),
        testCase(ReadWriteLockTests.allTests),
        testCase(StatefullOperationTests.allTests),
        testCase(TaskTests.allTests),
        testCase(UnfairLockTests.allTests)
    ]
}
#endif
