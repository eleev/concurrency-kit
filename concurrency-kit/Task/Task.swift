//
//  Task.swift
//  concurrency-kit
//
//  Created by Astemir Eleev on 10/03/2019.
//  Copyright © 2019 Astemir Eleev. All rights reserved.
//

import Foundation

public struct Task {
    
    // MARK: - Typealiases
    
    public typealias Closure = (Controller) -> Void
    
    // MARK: - Properties
    
    private let closure: Closure
    
    // MARK: - Initializers
    
    public init(closure: @escaping Closure) {
        self.closure = closure
    }
    
    // MARK: - Methods
    
    public func perform(on queue: DispatchQueue = .global(),
                 then handler: @escaping (Outcome) -> Void) {
        queue.async {
            let controller = Controller(
                queue: queue,
                handler: handler
            )
            
            self.closure(controller)
        }
    }
}


// MARK: - Constroller extension
public extension Task {
    
    // MARK: - Controller struct
    
    struct Controller {
        
        // MARK: - Priperties
        
        fileprivate let queue: DispatchQueue
        fileprivate let handler: (Outcome) -> Void
        
        // MARK: - Methods
        
        public func finish() {
            handler(.success)
        }
        
        public func fail(with error: Error) {
            handler(.failure(error))
        }
    }
}

// MARK: - Outcome extension
public extension Task {

    // MARK: - Enum type
    
    enum Outcome: Equatable {
       
        // MARK: - Cases
        
        case success
        case failure(Swift.Error)
        
        // MARK: - Conformance to Equatable protocol
        
        public static func == (lhs: Task.Outcome, rhs: Task.Outcome) -> Bool {
            switch (lhs, rhs) {
            case (.success, .success):
                return true
            case (.failure( _), .failure( _)):
                return true
            default:
                return false
            }
        }
    }
}

// MARK: - Serial task executor
public extension Task {
    
    static func group(_ tasks: [Task]) -> Task {
        return Task { controller in
            let group = DispatchGroup()
            let errorSyncQueue = DispatchQueue(label: "Task.Error.Sync")
            var anyError: Error?
            
            for task in tasks {
                group.enter()
                task.perform(on: controller.queue) { outcome in
                    switch outcome {
                    case .success:
                        break
                    case .failure(let error):
                        errorSyncQueue.sync {
                            anyError = anyError ?? error
                        }
                    }
                    
                    group.leave()
                }
            }
            
            group.notify(queue: controller.queue) {
                if let error = anyError {
                    controller.fail(with: error)
                } else {
                    controller.finish()
                }
            }
        }
    }
}

// MARK: - Concurrent task executor
public extension Task {
    
    static func sequence(_ tasks: [Task]) -> Task {
        var index = 0
        
        func performNext(using controller: Controller) {
            guard index < tasks.count else {
                controller.finish()
                return
            }
            
            let task = tasks[index]
            index += 1
            
            task.perform(on: controller.queue) { outcome in
                switch outcome {
                case .success:
                    performNext(using: controller)
                case .failure(let error):
                    // As soon as an error was occurred, we’ll
                    // fail the entire sequence.
                    controller.fail(with: error)
                }
            }
        }
        
        return Task(closure: performNext)
    }
}
