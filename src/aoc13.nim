import zero_functional, strutils

const TEST = [("17,x,13,19", 3417),
              ("67,7,59,61", 754018),
              ("67,x,7,59,61", 779210),
              ("67,7,x,59,61", 1261476),
              ("1789,37,47,1889", 1202161486)]

type
  Bus = tuple[id, off: int]

func calcWaitT(time, busT: int): Bus =
  result.id = busT
  result.off = busT - (time mod busT)

proc parseInput(input: string): seq[Bus] =
  result = input.split(',') --> indexedMap(it).
                filter(it.elem != "x").
                map((parseInt(it.elem), it.idx))

func solveP1(time: int, input: string): int =
  let bus = input.split(',') --> filter(it != "x").
        map(calcWaitT(time, parseInt(it))).
        reduce(if it.elem.off < it.accu.off:
            it.elem
          else:
            it.accu
        )
  result = bus.id * bus.off

# Input numbers are primes. Points of departure with the given interval
# occur each N[x] * N[x+1]
proc solveP2(s: seq[Bus]): int =
  var
    i = 0
    jump = s[i].id
  result = s[i].id
  while i < s.len - 1:
    let
      offset = s[i+1].off
      next = s[i+1].id
    while (result + offset) mod next != 0:
      result += jump
    jump = jump * next
    i.inc()

proc doTest() =
  for (data, r) in TEST:
    doAssert solveP2(parseInput(data)) == r

when isMainModule:
  doTest()

  let
    inputF = open("input/aoc13.txt")
    time = readLine(inputF).parseInt()
    input = readLine(inputF)
  
  block Part1:
    echo solveP1(time, input)
  
  block Part2:
    echo solveP2(parseInput(input))
