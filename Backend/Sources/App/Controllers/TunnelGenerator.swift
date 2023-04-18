import Foundation
import Shared

/// Generate the tunnel layout for a new round of the game
/// - Returns: the list of tunnels
func generateTunnels() -> [Tunnel] {
    let NUM_TUNNELS = 5

    var tunnels: [Tunnel] = []
    for _ in 1 ... NUM_TUNNELS {
        let numEntries = Int.random(in: 2 ... 4)

        let entries = (2 ... numEntries).map { _ in
            Entry(
                id: UUID(),
                position: Position(
                    x: Int.random(in: 100 ... 900),
                    y: Int.random(in: 100 ... 900)
                )
            )
        }
        let tunnel = Tunnel(id: UUID(), entries: entries)
        tunnels.append(tunnel)
    }
    return tunnels
}
