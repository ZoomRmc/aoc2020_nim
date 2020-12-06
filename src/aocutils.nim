import strutils, zero_functional

proc parseInputFile*(path: string): seq[int] =
  result = lines(path) --> map(strip).filter(it != "").map(parseInt)

iterator buffered*[T](s: openArray[T]; by: T): string {.inline.} =
  if s.len() != 0:
    var
      lo, hi = 0
    while hi < s.len():
      while lo < s.len() and s[lo] == by :
        lo += 1
      hi = lo
      if lo >= s.len(): break
      while hi < s.len() and s[hi] != by:
        hi += 1
      yield s[lo..<hi].join(" ")
      lo = hi
