//
//  DispatchQueue+Once.swift
//  concurrency-kit
//
//  Created by Astemir Eleev on 10/03/2019.
//  Copyright © 2019 Astemir Eleev. All rights reserved.
//

import Foundation

public extension DispatchQueue {
    
    // MARK: - Properties
    
    private static var _onceTracker = [String]()
    
    // MARK: - Methods
    
    /// Executes a block of code, associated with a unique token, only once.  The code is thread safe and will onle execute the code once even in the presence of multithreaded calls.
    ///
    /// - Parameters:
    ///   - token: is a unique reverse DNS-style name such as io.eleev.astemir or a GUID
    ///   - block: is a non-escaping closure that is executed only once
    class func once(token: String, block: () -> Void) {
        objc_sync_enter(self)
        defer { objc_sync_exit(self) }
        
        if _onceTracker.contains(token) { return }
        _onceTracker.append(token)
        block()
    }
}
