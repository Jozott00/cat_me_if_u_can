//
//  MouseAlgo.swift
//
//
//  Created by flo on 09.05.23.
//

import Foundation
import Shared

struct Node {
  var position: Position
  var exit: Exit
  var tunnel: Tunnel
}

struct Path {
  var nodes: [Node]
}

func getSavestPath(mouse: Mouse, tunnels: [Tunnel], cats: [Cat]) -> Path {
  // FIXME: Implement a proper dijkstra algorithm
  return Path(nodes: [
    Node(
      position: tunnels.first!.exits.first!.position,
      exit: tunnels.first!.exits.first!,
      tunnel: tunnels.first!
    )
  ])
}

func calculateMousePosition(mouse: Mouse, tunnels: [Tunnel], cats: [Cat]) {
  let curPos = mouse.position

  // FIXME: this should not be needed with correct paht calculation
  mouse.hidesIn = nil

  var path = getSavestPath(mouse: mouse, tunnels: tunnels, cats: cats)
  let nextNode = path.nodes.first!
  let nextPos = nextNode.position

  if curPos.distance(to: nextPos) <= Constants.CAT_MOVEMENT_PER_TICK {
    mouse.position = Position(position: nextPos)

    // Exit the tunnel if in tunnel if the next node is not in the same tunnel
    if mouse.isHidden && nextNode.tunnel.id != path.nodes[1].tunnel.id {
      mouse.hidesIn = nil
    }

    // If we are on the surface we must have directly chosen a exit we want to enter
    if !mouse.isHidden {
      mouse.hidesIn = nextNode.tunnel
      if nextNode.tunnel.isGoal {
        mouse.state = .reachedGoal
      }
    }

    return
  }

  let movementVector =
    (nextPos.asVector - mouse.position.asVector).normalized * Constants.MOUSE_MOVEMENT_PER_TICK
  print(movementVector.length)
  mouse.position.translate(vec: movementVector)
}
