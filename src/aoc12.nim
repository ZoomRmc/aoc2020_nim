import zero_functional, strutils, math

type
  Dir = enum
    N, E, S, W, F, R, L
  Point = tuple[x, y: int]

const
  STARTD = E
  MOVES = [(0, -1), (1, 0), (0, 1), (-1, 0)]
  WAYPOINT: Point = (10, -1)

func moveTo(pt: Point; d: Dir; val: int): Point =
  (pt.x + MOVES[d.ord][0] * val, pt.y + MOVES[d.ord][1] * val)

# relative to ship, so always around 0,0
func rotatePoint(pt: Point; d: Dir; v: int): Point =
  let rot = if d == L: 360 - v else: v
  result = case rot:
    of 90: (-pt.y, pt.x)
    of 180: (-pt.x, -pt.y)
    of 270: (pt.y, -pt.x)
    else: pt

func computeP1(s: openArray[(Dir, int)]): Point =
  var facing = STARTD
  for (d, val) in s:
    if d in {N, E, S, W}:
      result = moveTo(result, d, val)
    elif d in {R, L}:
      let
        rot = val div 90
        newf = (if d == R: facing.ord + rot else: facing.ord - rot).floorMod(4)
      facing = Dir(newf)
    else:
      result = moveTo(result, facing, val)

func computeP2(s: openArray[(Dir, int)]): Point =
  var wp = WAYPOINT
  for (d, val) in s:
    if d in {N, E, S, W}:
      wp = moveTo(wp, d, val)
    elif d in {R, L}:
      wp = rotatePoint(wp, d, val)
    else:
      result = (result.x + wp.x*val, result.y + wp.y*val)

func manhattanDistance(pt: Point): int =
  pt.x.abs() + pt.y.abs()
      
when isMainModule:
  let input = lines("input/aoc12.txt") -->
              map((parseEnum[Dir]($it[0]), parseInt(it[1..^1])))
  echo computeP1(input).manhattanDistance()
  echo computeP2(input).manhattanDistance()
