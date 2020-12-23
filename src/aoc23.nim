import sequtils, strutils
from math import `^`

type
  Ring = seq[int]

func parseInput(s: string): seq[int] =
  result = s.strip().mapIt(it.ord() - '0'.ord())

const
  Input = readFile("input/aoc23.txt").parseInput()
  MinN = Input.min()

func wrDec(a: Natural, max: int): int {.inline.} =
  result = a - 1
  if result < MinN:
    result = max

proc splice(ring: var Ring; node: int; s: openArray[int]) {.inline.} =
  ring[s[s.high()]] = ring[node]
  ring[node] = s[0]

proc game(ring: sink Ring, start, maxN, rounds: int): Ring =
  var
    tripleN: array[3, int]
    head = start
  for _ in 0..<rounds:
    for i in 0..2:
      tripleN[i] = ring[head]
      ring[head] = ring[ring[head]]
    var next = head.wrDec(maxN)
    while next in tripleN:
      next = next.wrDec(maxN)
    ring.splice(next, tripleN)
    head = ring[head]
  result = ring.move

proc solveP1(ring: openArray[int]): int =
  var next = ring[1]
  for i in countDown(7, 0):
    result += next * 10^i
    next = ring[next]

func solveP2(ring: openArray[int]): int =
  var next = ring[1]
  result = next * ring[next]

func initRing(s: openArray[int], length: int): Ring =
  result = newSeq[int](length+1)
  var prev = s[0]
  for n in s[1..<s.len()]:
    result[prev] = n
    prev = n
  if length > s.len():
    for n in s.len()+1..length:
      result[prev] = n
      prev = n
  result[prev] = s[0]

proc doTests() =
  let init = parseInput("389125467")
  doAssert solveP1(game(initRing(init, 9), init[0], 9, 10)) == 92658374
  doAssert solveP1(game(initRing(init, 9), init[0], 9, 100)) == 67384529

when isMainModule:
  doTests()

  block Part1:
    let 
      maxN = Input.max()
      result = solveP1(game(initRing(Input, 9), Input[0], maxN, 100))
    echo result
    doAssert result == 25468379

  block Part2:
    let
      maxN = 1000000
      result = solveP2(game(initRing(Input, maxN), Input[0], maxN, 10000000))
    echo result
    doAssert result == 474747880250
