//
//  Array+ConcurrentMap.swift
//  ConcurrencyKit
//
//  Created by Astemir Eleev on 02/06/2019.
//  Copyright © 2019 Astemir Eleev. All rights reserved.
//

import Foundation

extension Array {
    
    /// Concurrently performs map function for the given collection of elements
    public func concurrentMap<E>(_ transform: @escaping (Element) -> E) -> [E?] {
        var result = Array<E?>(repeating: nil, count: count)
        let queue = DispatchQueue(label: "array.concurrent.map")
        
        DispatchQueue.concurrentPerform(iterations: count) { index in
            let element = self[index]
            let transformed = transform(element)
            queue.sync {
                result[index] = transformed
            }
        }
        return result
    }
}
