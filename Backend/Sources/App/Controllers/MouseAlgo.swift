//
//  MouseAlgo.swift
//
//
//  Created by flo on 09.05.23.
//

import Foundation
import Shared

class Node: Hashable, Equatable {

  var position: Position
  var exit: Exit
  var tunnel: Tunnel
  var cost: Double

  init(position: Position, exit: Exit, tunnel: Tunnel, cost: Double) {
    self.position = position
    self.exit = exit
    self.tunnel = tunnel
    self.cost = cost
  }

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

func costBetween(from: Node, to: Node, cats: [Position]?) -> Double {
  if from.tunnel == to.tunnel {
    return 0
  }

  let start = from.position
  let end = to.position

  let lineLength = start.distance(to: end)
  guard let cats = cats else {
    return lineLength
  }

  var risk: Double = 0
  for cat in cats {
    var t =
      ((cat.x - start.x) * (end.x - start.x)
        + (cat.y - start.y) * (end.y - start.y)) / (lineLength * lineLength)

    if t < 0 {
      t = 0
    } else if t > 1 {
      t = 1
    }

    let nearestPointonLine = Position(
      x: start.x + t * (end.x - start.x),
      y: start.y + t * (end.y - start.y)
    )

    let catDistance = cat.distance(to: nearestPointonLine)
    risk += (1 / catDistance)
  }

  return lineLength * risk
}

func getSavestPath(mouse: Mouse, tunnels: [Tunnel], cats: [Position]?) -> Path {
  // Create all nodes
  let nodes: [Node] = tunnels.flatMap { t in
    t.exits.map { e in
      Node(position: e.position, exit: e, tunnel: t, cost: Double.infinity)
    }
  }
  var paths: [Node: Path] = [:]

  // Calcualte the reachabel costs
  let pseudoExit = Exit(id: UUID(), position: mouse.position)
  let pseudoStartNode = Node(
    position: mouse.position,
    exit: pseudoExit,
    tunnel: mouse.hidesIn ?? Tunnel(id: UUID(), exits: [pseudoExit], isGoal: false),
    cost: Double.infinity)

  for n in nodes {
    guard !mouse.isHidden || n.tunnel == mouse.hidesIn else {
      continue
    }

    n.cost = costBetween(from: pseudoStartNode, to: n, cats: cats)
    paths[n] = Path(nodes: [n])
  }

  // Let dijkstra do the job
  var unvisited = Set<Node>(nodes.map { $0 })
  while !unvisited.isEmpty {

    // 1. Select the shortest not filtered node
    let selected = unvisited.min { a, b in
      a.cost < b.cost
    }!

    if selected.tunnel.isGoal {
      return paths[selected]!
    }

    // 2. Make the selected visited
    unvisited.remove(selected)

    // 3. Update all new possible distances from the selected node
    for n in unvisited {
      let newCost = selected.cost + costBetween(from: selected, to: n, cats: cats)
      guard newCost < n.cost else {
        continue
      }

      n.cost = newCost
      paths[n] = paths[selected]!.extendBy(node: n)
    }

  }

  // This cannot be reached
  // FIXME: throw error or something
  assertionFailure("We shouldn't get here")
  return Path(nodes: [])
}

func calculateMousePosition(mouse: Mouse, mice: inout [Mouse], tunnels: [Tunnel], cats: [Position])
{
  let curPos = mouse.position
  let path =
    mouse.cachedPath
    ?? getSavestPath(
      mouse: mouse, tunnels: tunnels, cats: mouse.isHidden ? mouse.sightedCats : cats)

  // Update the cache for hidden mice
  if mouse.isHidden {
    mouse.cachedPath = path
  } else {
    mouse.cachedPath = nil
  }

  let nextNode = path.nodes.first!
  let nextPos = nextNode.position

  if curPos.distance(to: nextPos) <= Constants.CAT_MOVEMENT_PER_TICK {
    mouse.position = Position(position: nextPos)

    // Exit the tunnel if in tunnel if the next node is not in the same tunnel
    if mouse.isHidden {
      mouse.hidesIn = nil
      mouse.cachedPath = nil

    } else {
      mouse.hidesIn = nextNode.tunnel
      if nextNode.tunnel.isGoal {
        mouse.state = .reachedGoal
        return
      }

      // Update cache and invalidate other mices caches
      mouse.cachedPath = Path(nodes: Array(path.nodes[1...]))
      mice.filter { m in
        m.hidesIn == mouse.hidesIn
      }.forEach { m in
        m.cachedPath = nil
      }

      // Notify the other mice about the cats
      mice.filter { m in
        m.hidesIn == mouse.hidesIn
      }.forEach { m in
        m.sightedCats = cats
      }

    }

    return
  }

  let movementVector =
    (nextPos.asVector - mouse.position.asVector).normalized * Constants.MOUSE_MOVEMENT_PER_TICK
  mouse.position.translate(vec: movementVector)
}
