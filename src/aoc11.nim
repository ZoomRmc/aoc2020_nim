import aocutils, sequtils, strutils, zero_functional

const 
  TEST = """
L.LL.LL.LL
LLLLLLL.LL
L.L.L..L..
LLLL.LL.LL
L.LL.LL.LL
L.LLLLL.LL
..L.L.....
LLLLLLLLLL
L.LLLLLL.L
L.LLLLL.LL"""

type  
  Cell = enum 
    Occ = "#",
    Floor = ".",
    Empty = "L",

  Part = enum 
    P1, P2

func parseRow(row: sink string): seq[Cell] =
  row.mapIt(parseEnum[Cell]($it))

iterator scanAround(m: openArray[seq[Cell]]; r, c: int): Cell =
  var
    registered: seq[Cell]
    x = c
    y = r
  template register(x, y: var int) =
    if m[y][x] != Floor:
      registered.add(m[y][x])
      break
  while y > 0: # N
    y.dec()
    register(x, y)
  (x, y) = (c, r)
  while y > 0 and x < m[0].len - 1: # NE
    y.dec()
    x.inc()
    register(x, y)
  (x, y) = (c, r)
  while x < m[0].len - 1: # E
    x.inc()
    register(x, y)
  (x, y) = (c, r)
  while y < m.len - 1 and x < m[0].len - 1: # SE
    y.inc()
    x.inc()
    register(x, y)
  (x, y) = (c, r)
  while y < m.len - 1: # S
    y.inc()
    register(x, y)
  (x, y) = (c, r)
  while y < m.len - 1 and x > 0: # SW
    y.inc()
    x.dec()
    register(x, y)
  (x, y) = (c, r)
  while x > 0: #W
    x.dec()
    register(x, y)
  (x, y) = (c, r)
  while x > 0 and y > 0: # NW
    x.dec()
    y.dec()
    register(x, y)
  for cell in registered:
    yield cell

template scanNeighbours(m: openArray[seq[Cell]]; part: Part) =
  let
    w = m[0].len
    h = m.len
  var
    changed = false
  for r in 0..<h:
    var newrow = newSeq[Cell](w)
    for c in 0..<w:
      let seat = m[r][c]
      newrow[c] = if seat != Floor:
        let occupied = when part == P1:
            neighboursSafe(w, h, (c, r)) --> map(m[it[1]][it[0]]).
                                              filter(it == Occ).count()
        else:
            toSeq(scanAround(m, r, c)).foldl(if b == Occ: a + 1 else: a, 0)
        if seat == Empty and occupied == 0:
          block:
            changed = true
            Occ
        elif seat == Occ and (when part == P1: occupied >= 4 else: occupied >= 5):
          block:
            changed = true
            Empty
        else:
          seat
      else: Floor
    result[1].add(newrow)
  result[0] = changed

func stepStateP1(m: sink seq[seq[Cell]]): (bool, seq[seq[Cell]]) =
  scanNeighbours(m, P1)

func stepStateP2(m: sink seq[seq[Cell]]): (bool, seq[seq[Cell]]) =
  scanNeighbours(m, P2)

func countCell(m: seq[seq[Cell]], cell: Cell): int =
  m --> map( it --> filter(it == cell).count() ).sum()

template solve(m: seq[seq[Cell]], part: Part): int =
  var 
    stateChanged = true
    state = m
  while stateChanged:
    (stateChanged, state) = when part == P1:
        stepStateP1(state.move())
      else:
        stepStateP2(state.move())
  state.countCell(Occ)

proc doTest() =
  let input = TEST.splitLines() --> map(parseRow(it))
  doAssert solve(input, P1) == 37
  doAssert solve(input, P2) == 26

when isMainModule:
  doTest()
  
  let input = lines("input/aoc11.txt") --> map(parseRow(it))
  
  block Part1:
    echo solve(input, P1)

  block Part2:
    echo solve(input, P2)
