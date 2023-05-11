//
//  MouseAlgo.swift
//
//
//  Created by flo on 09.05.23.
//

import Foundation
import Shared

struct Node: Hashable, Equatable {
  var position: Position
  var exit: Exit
  var tunnel: Tunnel

  static func == (lhs: Node, rhs: Node) -> Bool {
    lhs.exit == rhs.exit
  }

  func hash(into hasher: inout Hasher) {
    hasher.combine(exit)
  }

}

struct Path {
  var nodes: [Node]

  func extendBy(node: Node) -> Path {
    var newNodes = nodes
    newNodes.append(node)
    return Path(nodes: newNodes)
  }
}

func costBetween(from: Node, to: Node) -> Double {
  if from.tunnel == to.tunnel {
    return 0
  }

  return from.position.distance(to: to.position)
}

func getSavestPath(mouse: Mouse, tunnels: [Tunnel], cats: [Cat]) -> Path {
  // Create all nodes
  var nodes: [Node] = []
  for tunnel in tunnels {
    for exit in tunnel.exits {
      nodes.append(
        Node(
          position: exit.position,
          exit: exit,
          tunnel: tunnel
        )
      )
    }
  }

  var costs: [Node: Double] = [:]
  var paths: [Node: Path] = [:]


  // Calcualte the reachabel costs
  for n in nodes {
    guard !mouse.isHidden || n.tunnel == mouse.hidesIn else {
      costs[n] = Double.infinity
      continue
    }

    if mouse.isHidden && mouse.hidesIn == n.tunnel {
      costs[n] = 0
    } else {
      costs[n] = mouse.position.distance(to: n.position)
    }
    paths[n] = Path(nodes: [n])
  }


  // Let dijkstra do the job
  var unvisited = Set<Node>(nodes.map { $0 })
  while !unvisited.isEmpty {
    // 1. Select the shortest not filtered node
    let selected = unvisited.min { a, b in
      costs[a]! < costs[b]!
    }!

    if selected.tunnel.isGoal {
      return paths[selected]!
    }

    // 2. Make the selected visited
    unvisited.remove(selected)

    // 3. Update all new possible distances from the selected node
    for n in unvisited {
      let newCost = costs[selected]! + costBetween(from: selected, to: n)
      guard newCost < costs[n]! else {
        continue
      }

      costs[n] = newCost
      paths[n] = paths[selected]!.extendBy(node: n)
    }

  }

  // This cannot be reached
  // FIXME: throw error or something
  assert(false, "We shouldn't get here")

}

func calculateMousePosition(mouse: Mouse, tunnels: [Tunnel], cats: [Cat]) {
  let curPos = mouse.position

  //mouse.hidesIn = nil
  let path = getSavestPath(mouse: mouse, tunnels: tunnels, cats: cats)
  let nextNode = path.nodes.first!
  let nextPos = nextNode.position

  if curPos.distance(to: nextPos) <= Constants.CAT_MOVEMENT_PER_TICK {
    mouse.position = Position(position: nextPos)

    // Exit the tunnel if in tunnel if the next node is not in the same tunnel
    if mouse.isHidden {
      mouse.hidesIn = nil
      return
    }

    // If we are on the surface we must have directly chosen a exit we want to enter
    if !mouse.isHidden {
      mouse.hidesIn = nextNode.tunnel
      // FIXME: Notify the other mice about the cats
      if nextNode.tunnel.isGoal {
        mouse.state = .reachedGoal
      }
      return
    }

    return
  }

  let movementVector =
    (nextPos.asVector - mouse.position.asVector).normalized * Constants.MOUSE_MOVEMENT_PER_TICK
  mouse.position.translate(vec: movementVector)
}
