import sequtils, strutils, aocutils, bitops, zero_functional

func alpha(c: char): int {.inline.} =
  c.ord() - 97

func setWordBits(s: string): uint32 =
  result = s.items() --> filter(it in 'a'..'z').
    map(alpha).fold(0'u32, block:
      setBit(a, it)
      a
    )

func countAny(s: string): int {.discardable.} =
  setWordbits(s).countSetBits()

func countAll(s: string): int =
  let n:uint = s.splitWhitespace() --> map(setWordBits).
    fold(uint32.high(), a and it)
  result = n.countSetBits()
  
when isMainModule:
  let input = toSeq(lines("input/aoc06.txt"))
  
  block Part1:
    echo input.buffered("") --> map(countAny).sum()
  
  block Part2:
    echo input.buffered("") --> map(countAll).sum()
