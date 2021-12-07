import zero_functional, strutils

const 
  CYCLES = 6
  INITS = 8
  MAXS = INITS+(CYCLES+1)*2
  TEST = """.#.
..#
###"""
  NEIGHBOURS2D = [ (-1, -1), (0, -1), (1, -1),
                  (-1, 0),  (0, 0),  (1, 0),
                  (-1, 1),  (0, 1),  (1, 1) ]

type
  Map3D = array[MAXS, array[MAXS, array[MAXS, bool]]]
  Map4D = array[MAXS, array[MAXS, array[MAXS, array[MAXS, bool]]]]

func Neighbours3D(): array[26, (int, int, int)] {.compileTime.} =
  for (i, n) in NEIGHBOURS2D.pairs():
    result[i] = (n[0], n[1], -1)
  for i in 9..12:
    result[i] = (NEIGHBOURS2D[i-9][0], NEIGHBOURS2D[i-9][1], 0)
  for i in 13..16:
    result[i] = (NEIGHBOURS2D[i-8][0], NEIGHBOURS2D[i-8][1], 0)
  for (i, n) in NEIGHBOURS2D.pairs():
    result[i+17] = (n[0], n[1], 1)

# I've thrown the towel at this point
func Neighbours4D(): array[80, (int, int, int, int)] {.compileTime.} =
  var s: seq[(int, int, int, int)]
  for w in -1..1:
    for z in -1..1:
      for y in -1..1:
        for x in -1..1:
          if not ((x, y, z, w) == (0, 0, 0, 0)):
            s.add((x, y, z, w))
  for (i, t) in s.pairs():
    result[i] = t

###################################################
## PRINTING
###################################################
func prCell(c: bool): char =
  if c: '#' else: '.'

proc printZSlice(m: Map3D; z: int) =
  for x in m:
    for y in x:
      stdout.write(prCell(y[z]))
    echo "" 
  echo ""
###################################################

iterator neighbours3DUnsafe*(x, y, z: int): (int, int, int) =
  for pt in Neighbours3D():
    yield (pt[0]+x, pt[1]+y, pt[2]+z)

iterator neighbours4DUnsafe*(x, y, z, w: int): (int, int, int, int) =
  for pt in Neighbours4D():
    yield (pt[0]+x, pt[1]+y, pt[2]+z, pt[3]+w)

func parseBool(c: char): bool =
  result = if c == '.': false
    elif c == '#': true
    else: raise newException(ValueError, "cannot interpret as a bool: " & $c)

func init3DFrom2D(s: string): Map3D =
  for (x, l) in s.splitLines.pairs():
    for (y, c) in l.pairs():
      result[x+CYCLES+1][y+CYCLES+1][CYCLES + 1] = parseBool(c)

func init4DFrom2D(s: string): Map4D =
  for (x, l) in s.splitLines.pairs():
    for (y, c) in l.pairs():
      result[x+CYCLES+1][y+CYCLES+1][CYCLES + 1][CYCLES + 1] = parseBool(c)

func countActiveNeighbours3D(m: Map3D; x, y, z: int): int {.inline.} =
  for n in neighbours3DUnsafe(x, y, z):
    if m[n[0]][n[1]][n[2]] == true:
      result.inc()

func countActiveNeighbours4D(m: Map4D; x, y, z, w: int): int {.inline.} =
  for n in neighbours4DUnsafe(x, y, z, w):
    if m[n[0]][n[1]][n[2]][n[3]] == true:
      result.inc()

func evolve3D(m: sink Map3D): Map3D =
  for x in 1..<m.len-1:
    for y in 1..<m[x].len-1:
      for z in 1..<m[x][y].len-1:
        var actN = countActiveNeighbours3D(m, x, y, z)
        let cell = m[x][y][z]
        result[x][y][z] = 
          if (cell and actN in {2..3}) or (not cell and actN != 3):
            cell
          else:
            not cell

func evolve4D(m: sink Map4D): Map4D =
  for x in 1..<m.len-1:
    for y in 1..<m[x].len-1:
      for z in 1..<m[x][y].len-1:
        for w in 1..<m[x][y].len-1:
          var actN = countActiveNeighbours4D(m, x, y, z, w)
          let cell = m[x][y][z][w]
          result[x][y][z][w] = 
            if (cell and actN in {2..3}) or (not cell and actN != 3):
              cell
            else:
              not cell

func countActive3D(m: Map3D): int =
  for x in m:
    for y in x:
      for cell in y:
        result += cell.ord()

func countActive4D(m: Map4D): int =
  for x in m:
    for y in x:
      for z in y:
        for cell in z:
          result += cell.ord()

when isMainModule:
  
  block Part1:
    var state = init3DFrom2D(readFile("input/aoc17.txt"))
    for _ in 0..<6:
      state = state.evolve3D()
    echo countActive3D(state)

  block Part2:
    var state = init4DFrom2D(readFile("input/aoc17.txt"))
    for _ in 0..<6:
      state = state.evolve4D()
    echo countActive4D(state)
