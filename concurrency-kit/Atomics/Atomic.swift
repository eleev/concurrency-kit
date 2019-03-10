//
//  Atomic.swift
//  concurrency-kit
//
//  Created by Astemir Eleev on 10/03/2019.
//  Copyright © 2019 Astemir Eleev. All rights reserved.
//

import Foundation

/// Guarantees that a valid value will be returned when accessing such property by using multiple thread. The valid does not always mean correct (atomic property may not be in the state that you expect, at a time when you access it).
final public class Atomic<T> {

    // MARK: - Properties

    internal private(set) var mutex: Mutex
    private(set) var value: T

    // MARK: - Initialzers

    public init(_ value: T) {
        mutex = Mutex()
        self.value = value
    }

    // MARK: - Methods

    public func set(_ value: T) {
        mutex.withCriticalScope { [weak self] in
            self?.value = value
        }
    }

    public func get() -> T {
        return mutex.withCriticalScope { value }
    }

    public func swap(_ value: T) -> T {
        return modify { _ in value }
    }

    @discardableResult
    public func with<R>(_ closure: (T) throws -> R) rethrows -> R {
        return try mutex.withCriticalScope {
            try closure(value)
        }
    }

    @discardableResult
    public func modify(_ action: (T) throws -> T) rethrows -> T {
        return try mutex.withCriticalScope {
            let previous = value
            value = try action(value)
            return previous
        }
    }
}
