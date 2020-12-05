{.experimental: "views".}
import sequtils, zero_functional

const
  ROWS = 128
  COLUMNS = 8

func binWalk(s: openArray[char]; max: int; loChar: char): int =
  var
    lo = 0
    hi = max - 1
  for c in s[0..^2]:
    let half: int = (hi - lo) div 2 + 1
    if c == loChar: hi -= half
    else: lo += half
    #{.cast(noSideEffect).}: echo lo, ' ', hi, ' ', half
  result = if s[^1] == loChar:
      lo
    else:
      hi

func parseRow(s: openArray[char]): int =
  binWalk(s[0..6], ROWS, 'F')

func parseCol(s: openArray[char]): int =
  binWalk(s[7..9], COLUMNS, 'L')

func getID(s: openArray[char]): int =
  parseRow(s) * 8 + parseCol(s)

func doTests() =
  let s = ["FBFBBFFRLR", "BFFFBBFRRR"]
  doAssert(parseRow(s[0]) == 44)
  doAssert(parseCol(s[0]) == 5)
  doAssert(getID(s[0]) == 357)
  doAssert(getID(s[1]) == 567)

when isMainModule:
  let input = toSeq(open("input/aoc05.txt").lines())
  
  doTests()

  block Part1:
    echo input --> map(getID).max()
  
  block Part2:
    var 
      mi = int.high()
      ma = 0
      xorred = input --> map(getID).fold(0, block:
        mi = min(mi, it)
        ma = max(ma, it)
        a xor it
      )
    echo mi..ma --> fold(xorred, a xor it)
