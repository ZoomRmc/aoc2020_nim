import strutils, zero_functional

proc parseInputFile*(path: string): seq[int] =
  result = lines(path) --> map(strip).filter(it != "").map(parseInt)

#TODO: rewrite to hold indexes of original container instead of copying into buf?
iterator buffered*[T](s: openArray[T]; by: T): string {.inline.} =
  var buf: seq[T]
  for a in s:
    if a != by:
      buf.add($a)
    else:
      yield buf.join(" ")
      buf.setLen(0)
  if buf.len() > 0:
    yield buf.join(" ")
