//
//  UnfairLock.swift
//  concurrency-kit
//
//  Created by Astemir Eleev on 10/03/2019.
//  Copyright © 2019 Astemir Eleev. All rights reserved.
//

import Foundation

/// A lock which causes a thread trying to acquire it to simply wait in a loop ("spin") while repeatedly checking if the lock is available
final public class UnfairLock: LockType {
    
    // MARK: - Properties
    
    private var unfairLock = os_unfair_lock()
    
    // MARK: - Conformance to LockType protocol
    
    public func lock() {
        os_unfair_lock_lock(&unfairLock)
    }
    
    @discardableResult
    public func tryLock() -> Bool {
        return os_unfair_lock_trylock(&unfairLock)
    }
    
    public func unlock() {
        os_unfair_lock_unlock(&unfairLock)
    }
}
