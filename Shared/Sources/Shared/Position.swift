//
//  File.swift
//
//
//  Created by Johannes Zottele on 28.03.23.
//

import Foundation

public class Position: Codable {
    var x: Int
    var y: Int

    init(x: Int, y: Int) {
        self.x = x
        self.y = y
    }
}
