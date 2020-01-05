//
//  StatefulOperation.swift
//  ConcurrencyKit
//
//  Created by Astemir Eleev on 14/03/2019.
//  Copyright © 2019 Astemir Eleev. All rights reserved.
//

import Foundation

/// Operation that has more 'Swifty' state management system, where state is an enum type with a number of possible cases:
/// - `ready` - an operation is initialized and is ready to be executed
/// - `executing` - an operation is performing a work
/// - `cancelled` - an operation has not yet successfully finished the work, but was interrupted
/// - `finished` - an operation has successfully finished the work
///
/// In order to use the class, you need to subclass it and override the `executableSection` method, where the work need to be done. When the work is done, you need to call the `finish` or `finishIfNotCancelled` methods in order to properly change the internal state of an operation.
open class StatefulOperation: Operation {
    
    // MARK: - Enum types
    
    public enum State: Equatable {
        
        // MARK: - Cases
        
        case ready
        case executing
        case cancelled
        case finished
        
        // MARK: - Fileprivate properties
        
        fileprivate var key: String {
            switch self {
            case .ready:
                return "isReady"
            case .executing:
                return "isExecuting"
            case .cancelled:
                return "isCancelled"
            case .finished:
                return "isFinished"
            }
        }
    }
    
    // MARK: - Private properties
    
    private let queue = DispatchQueue(label: "io.eleev.astemir.concurrency-kit.statefull-operation")
    private var _state: Atomic<State> = Atomic(.ready)
    
    // MARK: - Public properties
    
    public private(set) var state: State {
        get {
            return _state.get()
        }
        set {
            queue.sync {
                let oldValue = _state.get()
                guard newValue != oldValue else { return }
                
                willChangeValue(forKey: oldValue.key)
                willChangeValue(forKey: newValue.key)
                
                _state.set(newValue)
                
                didChangeValue(forKey: oldValue.key)
                didChangeValue(forKey: newValue.key)
            }
        }
    }
    
    // MARK: - Overriden properties
    
    final public override var isAsynchronous: Bool {
        return true
    }
    
    final public override var isExecuting: Bool {
        return state == .executing
    }
    
    final public override var isFinished: Bool {
        return state == .finished
    }
    
    final public override var isCancelled: Bool {
        return state == .cancelled
    }
    
    // MARK: - Overriden methods
    
    final public override func start() {
        if isCancelled  { interrupt();  return }
        if isFinished   { finish();     return }
        main()
    }
    
    final public override func main() {
        if isCancelled  { interrupt();  return }
        if isFinished   { finish();     return }
        state = .executing
        executableSection()
    }
    
    // MARK: - Methods
   
    final public func interrupt() {
        state = .cancelled
        cancel()
    }
    
    final public func finish() {
        state = .finished
    }
    
    final public func finishIfNotCancelled() {
        if state != .cancelled { finish() }
    }
    
    /// Overridable point, that is required to call `finish` method in order to mark the executable section as finished.
    open func executableSection() {
        finish()
    }
}
