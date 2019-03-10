//
//  DispatchQueue+AsyncAfter.swift
//  concurrency-kit
//
//  Created by Astemir Eleev on 10/03/2019.
//  Copyright © 2019 Astemir Eleev. All rights reserved.
//

import Foundation

public extension DispatchQueue {
    
    func asyncAfter(seconds: Double, execute closure: @escaping () -> ()) {
        let secPerSec = Double(NSEC_PER_SEC)
        let deadline: DispatchTime = DispatchTime.now() + Double(Int64(seconds * secPerSec)) / secPerSec
        self.asyncAfter(deadline: deadline, execute: closure)
    }
}
