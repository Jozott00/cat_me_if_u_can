import Foundation
import Shared

/// Generate the tunnel layout for a new round of the game
/// - Returns: the list of tunnels
func generateTunnels() -> [Tunnel] {
    var tunnels: [Tunnel] = []
    var entryPositions: [Position] = []

    for i in 1 ... Constants.TUNNELS_NUM {
        // Generate how many entries the tunnel should have
        let numEntries = Int.random(in: 2 ... Constants.MAX_ENTRIES)

        // First we create a virtual center point for our tunnel, around this
        // center we will generate the entries of the tunnel (with polar
        // translation)
        // FIXME: This is not optimal, because they will cluster in the middle
        let padding = Constants.FIELD_LENGTH / 10
        let virtualCenter = Position(
            x: Int.random(in: padding ... (Constants.FIELD_LENGTH - padding)),
            y: Int.random(in: padding ... (Constants.FIELD_LENGTH - padding))
        )

        let entries = (2 ... numEntries).map { _ in
            // Optimistically generate a position for this entry and check if
            // it is viable (not too close to any other entry of any of the
            // other tunnels)
            var position: Position
            repeat {
                position = Position(position: virtualCenter)
                position.translate(
                    r: Int.random(in: (Constants.ENTRY_SIZE * 2) ... (Constants.ENTRIES_MAX_DISTANCE / 2)),
                    phi: Float64.random(in: 0 ... 2) * Float64.pi
                )
            } while entryPositions.contains { ep in
                ep.distance(to: position) < Constants.ENTRIES_MIN_DISTANCE
            }

            entryPositions.append(position)
            return Entry(id: UUID(), position: position)
        }

        tunnels.append(
            Tunnel(id: UUID(), entries: entries, isGoal: i == 0)
        )
    }

    return tunnels
}
