//
//  LockType.swift
//  ConcurrencyKit
//
//  Created by Astemir Eleev on 10/03/2019.
//  Copyright © 2019 Astemir Eleev. All rights reserved.
//

import Foundation

public protocol LockType {
    func lock()
    func unlock()
}
