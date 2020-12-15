import tables, zero_functional, sequtils, strutils

const
  ENDTURN1 = 2020
  ENDTURN2 = 30000000
  TESTDATA = [ ([1,3,2], 1), ([2,1,3], 10), ([1,2,3], 27),
               ([2,3,1], 78), ([3,2,1], 438), ([3,1,2], 1836) ]

type
  Age = int
  Game = object
    mem: Table[int, Age]
    last: int
    round: int

iterator memoryGame(g: var Game): int =
  while true:
    let new = g.round - g.mem.getOrDefault(g.last, g.round) # 0 for newly spoken
    g.mem[g.last] = g.round
    g.round.inc()
    g.last = new
    yield new

func prefillTable(s: openArray[int]): Game =
  for (i, n) in s.pairs():
    result.mem[n] = i+1 # NOTE: what if some starting numbers repeat?
    result.last = n
  result.round = s.len

proc runGame(game: var Game; endturn: int): int =
  for n in memoryGame(game):
    if game.round == endturn: break
  result = game.last

proc doTest() =
  var game = prefillTable([0, 3, 6])
  doAssert runGame(game, 10) == 0
  for (data, res) in TESTDATA:
    game = prefillTable(data)
    doAssert runGame(game, ENDTURN1) == res

when isMainModule:
  doTest()

  let input = toSeq(readFile("input/aoc15.txt").split(',').mapIt(parseInt(it.strip())))
  var game = prefillTable(input)
  
  block Part1:
    echo runGame(game, ENDTURN1)

  block Part2:
    echo runGame(game, ENDTURN2)
