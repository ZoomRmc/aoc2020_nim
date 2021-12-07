import aocutils, zero_functional

const
  SECRET = 20201227
  INIT = 7

func transform(n, loop: int): int =
  result = 1
  for i in 0..loop:
    result = result * n mod SECRET

iterator publicKeyGen(n: int): int =
  var k = 1
  for i in 0..int.high():
    k = k * n mod SECRET
    yield k

func findEncryptionKey(handshake: openArray[int]): int =
  let
    (publicA, publicB) = minmax(handshake)
    loopSizeA = publicKeyGen(INIT) --> index(it == publicA)
  result = transform(publicB, loopSizeA)

when isMainModule:
  let input = parseInputFile("input/aoc25.txt")
  echo findEncryptionKey(input)
