import tables, bitops, pegs, strutils, zero_functional, math

const 
  MASKL = 36
  TEST1 = """
mask = XXXXXXXXXXXXXXXXXXXXXXXXXXXXX1XXXX0X
mem[8] = 11
mem[7] = 101
mem[8] = 0"""
  TEST2 = """
mask = 000000000000000000000000000000X1001X
mem[42] = 100
mask = 00000000000000000000000000000000X0XX
mem[26] = 1"""

let RULES = """
Input <- Mask (Write)+
Mask <- ('mask = ')? {(\d / 'X')+} \n*
Write <- Address Op {\d+} \n*
Address <- 'mem[' {\d+} ']'
Op <- \s '=' \s
""".peg

type
  Mask = object
    z, o: uint
    f: seq[int]
  Write = tuple[ad, val: uint]
  Ops = object
    mask: Mask
    writes: seq[Write]

proc applyMask(v: uint, mask: Mask): uint =
  bitOr(bitAnd(v, mask.z), mask.o)

func parseMask(s: string): Mask =
  result.z = uint.high()
  for (i, c) in s.pairs():
    let bit = MASKL - 1 - i
    case c 
    of '0': result.z.clearBit(bit)
    of '1': result.o.setBit(bit)
    of 'X': result.f.add(bit)
    else: discard

func isSet(n: int, bit: int): bool =
  bitAnd(n, 1 shl bit) > 0

iterator floats(v: uint; f: seq[int]): uint =
  var perm = v
  for i in 0..<(2 ^ f.len):
    for (bit, pos) in f.pairs():
      if i.isSet(bit):
        perm.setBit(pos)
      else:
        perm.clearBit(pos)
    yield perm

proc parseOps(s: string): Ops =
  if s =~ RULES:
    var writes: seq[(uint, uint)]
    for i in countUp(1, matches.len - 2, 2):
      if matches[i] == "": break
      else:
        writes.add( (parseUint(matches[i]), parseUint(matches[i+1])) )
    result = Ops(mask: parseMask(matches[0]), writes: writes.move)

proc parseInputS(s: string): seq[Ops] =
  s.split("mask = ") --> map(strip).map(parseOps)

proc parseInput(path: string): seq[Ops] =
  parseInputS(readFile(path))

func solveP1(ops: openArray[Ops]): uint =
  var t: Table[uint, uint]
  for op in ops: 
    for write in op.writes:
      t[write.ad] = applyMask(write.val, op.mask)
  t.values() --> sum()

proc solveP2(ops: openArray[Ops]): uint =
  var t: Table[uint, uint]
  for op in ops: 
    for write in op.writes:
      let addrMasked = bitOr(write.ad, op.mask.o)
      for address in floats(addrMasked, op.mask.f):
        t[address] = write.val
  t.values() --> sum()

proc doTests() =
  doAssert solveP1(parseInputS(TEST1)) == 165
  doAssert solveP2(parseInputS(TEST2)) == 208

when isMainModule:
  doTests()
  let input = parseInput("input/aoc14.txt")
  echo solveP1(input)
  echo solveP2(input)
