import aocutils, algorithm, tables, options

const
  TEST1 = [ 16, 10, 15, 5, 1, 11, 7, 19, 6, 12, 4 ]
  TEST2 = [ 28, 33, 18, 42, 31, 14, 46, 20, 48, 47,
            24, 23, 49, 45, 19, 38, 39, 11, 1, 32,
            25, 35, 8, 17, 7, 9, 4, 2, 34, 10, 3]
  OUTLETJ = 0
  INTERNALJ = 3
  EFFRNG = 3

func buildDifMap(s: openArray[int]): Option[CountTable[int]] =
  var
    difmap = initCountTable[int]()
    prev = OUTLETJ
  difmap.inc(3)
  for j in s:
    let dif = j - prev
    if dif > EFFRNG: return none(CountTable[int])
    difmap.inc(dif)
    prev = j
  result = if difmap.len() > 0:
      some(difmap)
    else:
      none(CountTable[int])

#TODO clean up copying to a new seq
proc countPaths(s: openArray[int]): int =
  var
    pathmap = initCountTable[int]()
    s = OUTLETJ & @s #add outlet
  let maxJ = s[^1] + INTERNALJ #add internal
  s.add(maxJ)
  pathmap[s[0]] = 1
  for id in 0..<s.len:
    var next = id + 1
    let incoming = pathmap[s[id]]
    while next < s.len and s[next] - s[id] <= EFFRNG:
      pathmap.inc(s[next], incoming)
      next.inc()
  result = pathmap[maxJ]

proc getP1Answer(input: openArray[int]): int =
  let res = buildDifMap(input)
  try:
    let difmap = res.get()
    result = difmap[1] * difmap[3]
  except:
    quit "Could not build the chain including every adapter!"

proc doTest() =
  var testData1 = @TEST1
  testData1.sort()
  var difmap = buildDifMap(testData1).get()
  doAssert (difmap[3] == 5 and difmap[1] == 7)
  
  var testData2 = @TEST2
  testData2.sort()
  difmap = buildDifMap(testData2).get()
  doAssert (difmap[3] == 10 and difmap[1] == 22)

  doAssert countPaths(testData1) == 8
  doAssert countPaths(testData2) == 19208

when isMainModule:
  doTest()
  
  var input = parseInputFile("input/aoc10.txt")
  input.sort()
  
  block Part1:
    echo getP1Answer(input)
  
  block Part2:
    echo countPaths(input)
