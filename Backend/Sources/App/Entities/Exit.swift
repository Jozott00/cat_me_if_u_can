import Foundation
import Shared

class Exit: Hashable, Equatable {
  let id: UUID
  let position: Position

  init(id: UUID, position: Position) {
    self.id = id
    self.position = position
  }

  public static func == (lhs: Exit, rhs: Exit) -> Bool {
    return lhs.id == rhs.id
  }

  func hash(into hasher: inout Hasher) {
    hasher.combine(id)
  }
}
