import Foundation
import Shared

/// Generate the tunnel layout for a new round of the game
/// - Returns: the list of tunnels
func generateTunnels() -> [Tunnel] {
    var tunnels: [Tunnel] = []
    var exitPositions: [Position] = []

    for i in 1 ... Constants.TUNNELS_NUM {
        // Generate how many exits the tunnel should have
        let numExits = Int.random(in: 2 ... Constants.MAX_EXITS)

        // First we create a virtual center point for our tunnel, around this
        // center we will generate the exits of the tunnel (with polar
        // translation)
        // FIXME: This is not optimal, because they will cluster in the middle
        let padding = Constants.FIELD_LENGTH / 10
        let virtualCenter = Position(
            x: Double.random(in: padding ... (Constants.FIELD_LENGTH - padding)),
            y: Double.random(in: padding ... (Constants.FIELD_LENGTH - padding))
        )

        let exits = (2 ... numExits).map { _ in
            // Optimistically generate a position for this exit and check if
            // it is viable (not too close to any other exit of any of the
            // other tunnels)
            var position: Position
            repeat {
                position = Position(position: virtualCenter)
                position.translate(
                    r: Double.random(in: (Constants.EXIT_SIZE * 2) ... (Constants.EXITS_MAX_DISTANCE / 2)),
                    phi: Double.random(in: 0 ... 2) * Double.pi
                )
            } while exitPositions.contains { ep in
                ep.distance(to: position) < Constants.EXITS_MIN_DISTANCE
            }

            exitPositions.append(position)
            return Exit(id: UUID(), position: position)
        }

        tunnels.append(
            Tunnel(id: UUID(), exits: exits, isGoal: i == 0)
        )
    }

    return tunnels
}
