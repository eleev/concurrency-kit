//
//  AtomicBool.swift
//  ConcurrencyKit
//
//  Created by Astemir Eleev on 10/03/2019.
//  Copyright © 2019 Astemir Eleev. All rights reserved.
//

import Foundation

final public class AtomicBool {
    
    // MARK: - Properties
    
    internal private(set) var mutex: Mutex
    private(set) var value: Bool
    
    // MARK: - Initialzers
    
    public init(_ value: Bool) {
        mutex = Mutex()
        self.value = value
    }
    
    // MARK: - Methods
    
    public func set(_ value: Bool) {
        mutex.withCriticalScope { [weak self] in
            self?.value = value
        }
    }
    
    public func get() -> Bool {
        return mutex.withCriticalScope { value }
    }
}
