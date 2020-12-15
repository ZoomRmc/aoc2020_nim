import tables, zero_functional, sequtils, strutils

const
  ENDTURN1 = 2020
  ENDTURN2 = 30000000
  TESTDATA = [ ([1,3,2], 1), ([2,1,3], 10), ([1,2,3], 27),
               ([2,3,1], 78), ([3,2,1], 438), ([3,1,2], 1836) ]

type
  Age = tuple[last, penul: int]
  Game = object
    mem: Table[int, Age]
    last: int
    round: int

iterator memoryGame(g: var Game): int =
  while true:
    g.round.inc()
    let age = g.mem[g.last] # ok: it's in state => it must be in the memory
    g.last = if age.penul == 0:
        0
      else:
        age.last - age.penul
    # update memory for the newly spoken n
    g.mem[g.last] = if g.mem.hasKey(g.last):
        (last: g.round, penul: g.mem[g.last].last)
      else:
        (last: g.round, penul: 0)
    yield g.last

func prefillTable(s: openArray[int]): Game =
  for (i, n) in s.pairs():
    result.mem[n] = (i+1, 0) # NOTE: what if some starting numbers repeat?
    result.last = n
  result.round = s.len

proc runGame(game: var Game; endturn: int): int =
  for n in memoryGame(game):
    if game.round == endturn: break
  result = game.last

proc doTest() =
  for (data, res) in TESTDATA:
    var game = prefillTable(data)
    doAssert runGame(game, ENDTURN1) == res

when isMainModule:
  doTest()

  let input = toSeq(readFile("input/aoc15.txt").split(',').mapIt(parseInt(it.strip())))
  var game = prefillTable(input)
  
  block Part1:
    echo runGame(game, ENDTURN1)

  block Part2:
    echo runGame(game, ENDTURN2)
  
