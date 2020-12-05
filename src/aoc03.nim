import zero_functional, sequtils

const 
  MOVES = [(1, 1), (3, 1), (5, 1), (7, 1), (1, 2)]
  CYCLE = 31

type
  Move = tuple[x, y: int]

proc countTrees(s: seq[string], d: Move): int =
  result = countup(0, s.len() - 1, d.y) --> enumerate().map(
    block:
      let x = it[0] * d.x mod CYCLE # echo s[it[1]], "|", align($it[1],4), align($x, 2),' ', s[it[1]][0..<x], "█", s[it[1]][x+1..^1]
      s[it[1]][x]
    ).
    filter(it == '#').
    count()

when isMainModule:
  let input = toSeq(open("input/aoc03.txt").lines())
  block Part1:
    echo countTrees(input, MOVES[2])
  block Part2:
    echo MOVES --> map(countTrees(input, it)).product()
