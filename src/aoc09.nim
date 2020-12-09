import aocutils, sequtils, zero_functional, intsets, deques, options

const PREAMBLE = 25

func initSumSet(n: int; v: openArray[int]): IntSet =
  for i in v.filterIt(it != n):
    result.incl(i + n)

func initSumDeque(v: openArray[int]): Deque[IntSet] =
  result = initDeque[IntSet](PREAMBLE)
  for n in v:
    result.addLast(initSumSet(n, v))

func isValid(n: int, deq: Deque[IntSet]): bool {.inline.} =
  result = deq --> exists(contains(it, n))

func findInvalid(input: openArray[int]; deq: var Deque[IntSet]): Option[int] =
  for i in PREAMBLE..<input.len:
    let n = input[i]
    if n.isValid(deq):
      discard deq.popFirst()
      deq.addLast(initSumSet(n, input[i - PREAMBLE..<i]))
    else:
      return some(n)
  result = none(int)

func findRangeForN(n: int; input: openArray[int]): Option[(int, int)] =
  var
    i, j = 0
    sum = input[0]
  while j < input.len:
    if sum < n:
      inc(j)
      sum += input[j]
    elif sum > n:
      sum -= input[i]
      inc(i)
      if j < i: j = i
    else:
      break
  result = if sum == n:
      some((i, j))
    else:
      none((int, int))

when isMainModule:
  var 
    input = parseInputFile("input/aoc09.txt")
    deq = initSumDeque(input[0..<PREAMBLE])
    invalid: int

  block Part1:
    let p1res = findInvalid(input, deq)
    if p1res.isSome():
      invalid = p1res.get()
      echo invalid
    else:
      quit "Part 1 failed"
  
  block Part2:
    let sumrangeOpt = findRangeForN(invalid, input)
    if sumrangeOpt.isSome:
      let sumrange = sumrangeOpt.get()
      let p2res = minmax(input[sumrange[0]..sumrange[1]])
      echo p2res[0] + p2res[1]
    else:
      quit "Part 2 failed"
