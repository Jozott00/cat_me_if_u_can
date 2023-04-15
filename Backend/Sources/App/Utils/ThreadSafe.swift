//
//  File.swift
//
//
//  Created by Johannes Zottele on 21.03.23.
//

import Foundation

class ThreadSafe<T> {
    private var element: T
    private let lock = NSLock()

    init(element: T) {
        self.element = element
    }

    func op<R>(_ op: (_ elem: () -> T) -> R) -> R {
        lock.lock()
        defer { lock.unlock() }
        return op { element }
    }
}
