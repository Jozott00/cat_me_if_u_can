import Foundation
import Shared

class Exit {
    let id: UUID
    let position: Position

    init(id: UUID, position: Position) {
        self.id = id
        self.position = position
    }
}
