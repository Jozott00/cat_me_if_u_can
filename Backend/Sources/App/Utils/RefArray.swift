//
//  File.swift
//
//
//  Created by Johannes Zottele on 21.03.23.
//

import Foundation
import WebSocketKit

class RefArray<T: Equatable>: Collection {
  typealias Element = T
  typealias Index = Int

  private var values = [T]()

  var startIndex: Index {
    return values.startIndex
  }

  var endIndex: Index {
    return values.endIndex
  }

  var count: Int {
    return values.count
  }

  var last: Element? {
    return values.last
  }

  subscript(position: Int) -> T { values[position] }
  func index(after i: Int) -> Int {
    return values.index(after: i)
  }

  func remove(ws: T) {
    values.removeAll { w in ws == w }
  }

  func add(ws: T) {
    guard !values.contains(where: { w in ws == w }) else { return }
    values.append(ws)
  }
}
