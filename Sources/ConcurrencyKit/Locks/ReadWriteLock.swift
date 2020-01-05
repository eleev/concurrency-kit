//
//  ReadWriteLock.swift
//  ConcurrencyKit
//
//  Created by Astemir Eleev on 10/03/2019.
//  Copyright © 2019 Astemir Eleev. All rights reserved.
//

import Foundation

/// A synchronization primitive that solves one of the readers–writers problems. An RW lock allows concurrent access for read-only operations, while write operations require exclusive access. This means that multiple threads can read the data in parallel but an exclusive lock is needed for writing or modifying data.
final public class ReadWriteLock {
    
    // MARK: - Properties
    
    private var rwLock = pthread_rwlock_t()
    
    // MARK: - Init & Deinit
    
    public init() {
        let result = pthread_rwlock_init(&rwLock, nil)
        assert(result == 0, "Failed to init read write lock in \(self)")
    }
    
    deinit {
        destroy()
    }
    
    // MARK: - Methods
    
    public func readLock() {
        pthread_rwlock_rdlock(&rwLock)
    }
    
    @discardableResult
    public func tryReadLock() -> Int32 {
        return pthread_rwlock_tryrdlock(&rwLock)
    }
    
    public func writeLock() {
        pthread_rwlock_wrlock(&rwLock)
    }
    
    @discardableResult
    public func tryWriteLock() -> Int32 {
        return pthread_rwlock_trywrlock(&rwLock)
    }
    
    public func unlock() {
        pthread_rwlock_unlock(&rwLock)
    }
    
    // MARK: - Private methods
 
    private func destroy() {
        pthread_rwlock_destroy(&rwLock)
    }
}
