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

proc minmax*[T](x: openArray[T]): (T, T) =
  result = (x[0], x[0])
  for i in 1..high(x):
    if x[i] < result[0]: result[0] = x[i]
    if result[1] < x[i]: result[1] = x[i]

iterator neighboursSafe*(w, h: int; cell: (int, int)): (int, int) {.closure.} =
  var n: seq[(int,int)]
  let (x, y) = cell
  if x > 0:
    if y > 0: n.add((x-1, y-1))
    n.add((x-1, y))
    if y < h-1: n.add((x-1, y+1))
  if y > 0: n.add((x, y-1))
  if x < w-1:
    if y > 0: n.add((x+1, y-1))
    n.add((x+1, y))
    if y < h-1: n.add((x+1, y+1))
  if y < h-1: n.add((x, y+1))
  for pt in n:
    yield pt

iterator neighboursUnsafe*(cell: (int, int)): (int, int) {.closure.} =
  let 
    (x, y) = cell
    n = [ (x-1, y-1), (x, y-1), (x+1, y-1),
          (x-1, y),             (x, y+1),
          (x-1, y+1), (x, y+1), (x+1, y+1) ]
  for pt in n:
    yield pt

proc printMatrix*[T](m: openArray[seq[T]]) =
  for r in m:
    for c in r:
      stdout.write $c
    echo ""
