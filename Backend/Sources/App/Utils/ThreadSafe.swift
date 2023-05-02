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

class SafeArray<T> {
    private var array: [T]
    private let queue = DispatchQueue(label: "me.cat.\(UUID().uuidString)", attributes: .concurrent)

    init(_ array: [T] = []) {
        self.array = array
    }

    // Get the number of elements in the array
    var count: Int {
        return queue.sync { array.count }
    }

    // Check if the array is empty
    var isEmpty: Bool {
        return queue.sync { array.isEmpty }
    }

    var plain: [T] {
        return array
    }

    // Add an element to the end of the array
    func append(_ element: T) {
        queue.async(flags: .barrier) {
            self.array.append(element)
        }
    }

    // Insert an element at a specific index
    func insert(_ element: T, at index: Int) {
        queue.async(flags: .barrier) {
            if index >= 0, index <= self.array.count {
                self.array.insert(element, at: index)
            }
        }
    }

    // Remove an element at a specific index
    func remove(at index: Int) {
        queue.async(flags: .barrier) {
            if index >= 0, index < self.array.count {
                self.array.remove(at: index)
            }
        }
    }

    // Remove an element
    func removeAll(where condition: @escaping (T) -> Bool) {
        queue.async(flags: .barrier) {
            self.array.removeAll(where: condition)
        }
    }

    // Remove all elements from the array
    func removeAll() {
        queue.async(flags: .barrier) {
            self.array.removeAll()
        }
    }

    func contains(where condition: (T) throws -> Bool) rethrows -> Bool {
        return try queue.sync {
            try array.contains(where: condition)
        }
    }

    // Access or modify elements using subscripting
    subscript(index: Int) -> T? {
        get {
            return queue.sync {
                guard index >= 0, index < array.count else { return nil }
                return array[index]
            }
        }
        set {
            guard let newValue = newValue else { return }
            queue.async(flags: .barrier) {
                if index >= 0, index < self.array.count {
                    self.array[index] = newValue
                }
            }
        }
    }

    // Access the first element
    var first: T? {
        return queue.sync { array.first }
    }

    // Access the last element
    var last: T? {
        return queue.sync { array.last }
    }

    // Find the first index where the specified condition is true
    func firstIndex(where predicate: @escaping (T) -> Bool) -> Int? {
        return queue.sync { array.firstIndex(where: predicate) }
    }

    // Find the last index where the specified condition is true
    func lastIndex(where predicate: @escaping (T) -> Bool) -> Int? {
        return queue.sync { array.lastIndex(where: predicate) }
    }

    // Iterate over the elements in the array
    func forEach(_ body: @escaping (T) -> Void) {
        queue.sync {
            array.forEach(body)
        }
    }

    // Filter the array based on a condition
    func filter(_ isIncluded: @escaping (T) -> Bool) -> [T] {
        return queue.sync { array.filter(isIncluded) }
    }

    // Map the elements in the array to a new type
    func map<R>(_ transform: @escaping (T) -> R) -> [R] {
        return queue.sync { array.map(transform) }
    }

    func atomically(_ op: @escaping (SafeArray<T>) -> Void) {
        queue.async(flags: .barrier) { op(self) }
    }
}
