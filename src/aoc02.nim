import zero_functional, strutils, sequtils, pegs

const RULE = """{\d+}'-'{\d+}\ {[a-z]}': '{\w+}"""

template parseLine(cond: untyped): untyped =
  if s =~ peg(RULE):
    let 
      lo {.inject.} = parseInt(matches[0])
      hi {.inject.} = parseInt(matches[1])
      ch {.inject.}: char = matches[2][0]
      pwd {.inject.} = matches[3]
    if cond:
      return true
  result = false

proc parseLineA(s: string): bool =
  parseLine(pwd.count(ch) in lo..hi)

proc parseLineB(s: string): bool =
  parseLine(pwd[lo - 1] == ch xor pwd[hi - 1] == ch)

when isMainModule:
  let input = toSeq(open("input/aoc02.txt").lines())
  echo input --> map(strip).filter(it != "").
                map(parseLineA).
                map(ord).sum()

  echo input --> map(strip).filter(it != "").
                map(parseLineB).
                map(ord).sum()
