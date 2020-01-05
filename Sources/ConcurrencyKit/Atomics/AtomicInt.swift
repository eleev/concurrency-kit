//
//  AtomicInt.swift
//  ConcurrencyKit
//
//  Created by Astemir Eleev on 10/03/2019.
//  Copyright © 2019 Astemir Eleev. All rights reserved.
//

import Foundation

final public class AtomicInt {
    
    // MARK: - Properties
    
    internal private(set) var mutex: Mutex
    private(set) var value: Int
    
    // MARK: - Initialzers
    
    public init(_ value: Int) {
        mutex = Mutex()
        self.value = value
    }
    
    // MARK: - Methods
    
    public func set(_ value: Int) {
        mutex.withCriticalScope { [weak self] in
            self?.value = value
        }
    }
    
    public func get() -> Int {
        return mutex.withCriticalScope { value }
    }
    
    public func swap(_ value: Int) -> Int {
        return modify { _ in value }
    }
    
    @discardableResult
    public func with(_ closure: (Int) throws -> Int) rethrows -> Int {
        return try mutex.withCriticalScope {
            try closure(value)
        }
    }
    
    @discardableResult
    public func modify(_ action: (Int) throws -> Int) rethrows -> Int {
        return try mutex.withCriticalScope {
            let previous = value
            value = try action(value)
            return previous
        }
    }
}
