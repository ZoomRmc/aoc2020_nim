import strutils, zero_functional

proc parseInputFile*(path: string): seq[int] =
  let f = open(path)
  result = f.lines --> map(strip).filter(it != "").map(parseInt)
