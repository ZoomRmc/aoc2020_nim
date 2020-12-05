import aocutils, intsets, algorithm, options

const SOUGHT = 2020

func first(input: openArray[int]): Option[int] =
  var numSet = initIntSet()
  for n in input:
    let dif = SOUGHT - n
    if numSet.contains(dif):
      #echo(n, " ", dif)
      return some(n * dif)
    else:
      numSet.incl(n)
  result = none(int)

proc second(input: var openArray[int]): Option[int] =
  sort(input)
  for ia in 0..<input.len() - 2:
    let dif = SOUGHT - input[ia]
    var 
      ib = ia + 1
      ic = input.len() - 1
      sum: int
    while ib < ic and input[ib] < dif:
      sum = input[ib]+input[ic]
      if sum < dif:
        ib.inc()
      elif sum > dif:
        ic.dec()
      else:
        return some(input[ia]*input[ib]*input[ic])
  result = none(int)

when isMainModule:
  var input = parseInputFile("input/aoc01.txt")
  template printResult(f: Option[int]) =
    echo if f.isSome():
      $f.get()
    else:
      "Didn't find the required numbers"
  
  first(input).printResult()
  second(input).printResult()
