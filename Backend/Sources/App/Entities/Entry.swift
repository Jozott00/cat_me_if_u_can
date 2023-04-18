import Foundation
import Shared

class Entry {
    let id: UUID
    let position: Position

    init(id: UUID, position: Position) {
        self.id = id
        self.position = position
    }
}
