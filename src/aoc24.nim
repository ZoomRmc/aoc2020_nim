import sequtils, strutils, zero_functional

const
  Axial = [(1,0), (0,1), (-1,1), (-1,0), (0,-1), (1,-1)]
  InputErr = "Malformed input, got: "
  Area = 256
  TEST = """sesenwnenenewseeswwswswwnenewsewsw
neeenesenwnwwswnenewnwwsewnenwseswesw
seswneswswsenwwnwse
nwnwneseeswswnenewneswwnewseswneseene
swweswneswnenwsewnwneneseenw
eesenwseswswnenwswnwnwsewwnwsene
sewnenenenesenwsewnenwwwse
wenwwweseeeweswwwnwwe
wsweesenenewnwwnwsenewsenwwsesesenwne
neeswseenwwswnwswswnw
nenwswwsewswnenenewsenwsenwnesesenew
enewnwewneswsewnwswenweswnenwsenwsw
sweneswneswneneenwnewenewwneswswnese
swwesenesewenwneswnwwneseswwne
enesenwswwswneneswsenwnewswseenwsese
wnwnesenesenenwwnenwsewesewsesesew
nenewswnwewswnenesenwnesewesw
eneswnwswnwsenenwnwnwwseeswneewsenese
neswnwewnwnwseenwseesewsenwsweewe
wseweeenwnesenwwwswnew"""

type
  Dir = enum
    E, SE, SW, W, NW, NE
  Position = (int, int)
  Map = array[Area, array[Area, bool]]

func ax(d: Dir): Position =
  Axial[d.ord()]

func `+`(a, b: Position): Position =
  (a[0] + b[0], a[1] + b[1])

func mark(m: var Map; p: Position) =
  m[p[0] + Area div 2][p[1] + Area div 2] = not m[p[0] + Area div 2][p[1] + Area div 2]

func pathToCoord(path: openArray[Dir]): Position =
  for d in path:
    result = result + d.ax() 

proc parsePath(s: string): seq[Dir] =
  type WtState = enum wZ, wS, wN
  var state = wZ
  for c in s:
    case state
      of wS:
        case c
          of 'e': result.add(SE)
          of 'w': result.add(SW)
          else: quit InputErr & $c
        state = wZ 
      of wN:
        case c
          of 'e': result.add(NE)
          of 'w': result.add(NW)
          else: quit InputErr & $c
        state = wZ 
      else:
        case c
          of 'e': result.add(E)
          of 'w': result.add(W)
          of 'n': state = wN
          of 's': state = wS
          else: quit InputErr & $c

func step(m: openArray[array[Area, bool]]): Map =
  for r in 1..Area - 2:
    for c in 1..Area - 2:
      let tile = m[r][c]
      var blacks = foldl(Axial, a+m[r+b[0]][c+b[1]].ord(), 0)
      result[r][c] = (tile and (blacks in {1,2})) or ((not tile) and (blacks == 2))

func countBlacks(m: openArray[array[Area, bool]]): int =
  foldl(m.mapIt( foldl(it, a+b.ord, 0) ), a+b)

func initMap(input: openArray[seq[Dir]]): Map =
  for s in input:
    result.mark(pathToCoord(s))  

proc doTests() =
  let input: seq[seq[Dir]] = splitLines(TEST) --> map(it.strip().parsePath())
  var map = initMap(input)
  doAssert countBlacks(map) == 10
  for d in 1..100: map = map.step()
  doAssert countBlacks(map) == 2208
  
when isMainModule:
  doTests()

  let input: seq[seq[Dir]] = lines("input/aoc24.txt") --> map(it.strip().parsePath())
  var map = initMap(input)

  block Part1:
    echo countBlacks(map)

  block Part2:
    for d in 1..100:
      map = map.step()
    echo countBlacks(map)
