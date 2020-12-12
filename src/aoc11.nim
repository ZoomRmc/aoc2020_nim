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

  DIRS = [(-1, 0), (-1, 1), (0, 1), (1, 1), (1, 0), (1, -1), (0, -1), (-1, -1)]

type  
  Cell = enum 
    Occ = "#",
    Floor = ".",
    Empty = "L"

  Part = enum 
    P1, P2

func parseRow(row: sink string): seq[Cell] =
  row.mapIt(parseEnum[Cell]($it))

# Handling it this way relies on compiler to optimize out zero summations.
# Range checking is probably suffers too, relative to manually unrolled branching.
# However, this is shorter. Unrolled version's in git, if optimizations are needed.
iterator scanAround(m: openArray[seq[Cell]]; r, c: int): Cell =
  for d in DIRS:
    var (x, y) = (c, r)
    while true:
      y += d[0]
      x += d[1]
      if (y in 0..<m.len) and (x in 0..<m[0].len):
        if m[y][x] != Floor:
          yield m[y][x]
          break
      else:
        break

template scanNeighbours(part: Part) =
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
  scanNeighbours(P1)

func stepStateP2(m: sink seq[seq[Cell]]): (bool, seq[seq[Cell]]) =
  scanNeighbours(P2)

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
