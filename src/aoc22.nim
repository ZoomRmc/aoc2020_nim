import zero_functional, deques, strutils, sets

func calcScore(deck: Deque[int]): int =
  for (i, c) in deck.pairs():
    result += c * (deck.len() - i)

proc addPair(deck: var Deque[int]; cx, cy: int) {.inline.} =
  deck.addLast(cx)
  deck.addLast(cy)

proc solveP1(p1, p2: var Deque[int]): int =
  while (p1.len() > 0) and (p2.len > 0):
    let 
      c1 = p1.popFirst()
      c2 = p2.popFirst()
    if c1 > c2:
      p1.addPair(c1, c2)
    else:
      p2.addPair(c2, c1)
  result = if p1.len > p2.len:
      calcScore(p1)
    else:
      calcScore(p2)

func `[]`[T, U, V](s: Deque[T], x: HSlice[U, V]): Deque[T] =
  let L = x.b - x.a + 1
  result = initDeque[T](L)
  for i in 0..<L: result.addLast(s[i + x.a])

## Using calcScore for hashing proved applicable and drastically speeds up computation
#proc hash[T](d: Deque[T]): Hash =
#  var h: Hash = 0
#  for x in d:
#    h = h !& hash(x)
#  result = !$h

func max(d: Deque[int]): int =
  result = int.low()
  for i in d:
    result = max(result, i)

proc game(p1, p2: var Deque[int]): bool =
  var history = initHashSet[(int, int)]()
  while true:
    if (p2.len == 0) or history.containsOrIncl( (calcScore(p1), calcScore(p2)) ):
      return true
    if p1.len == 0:
      return false
    let 
      c1 = p1.popFirst()
      c2 = p2.popFirst()
    var p1won = if (c1 <= p1.len) and (c2 <= p2.len):
        var (newdeck1, newdeck2) = (p1[0..<c1], p2[0..<c2])
        (newdeck1.max() > newdeck2.max()) or game(newdeck1, newdeck2)
      else:
        c1 > c2
    if p1won:
      p1.addPair(c1, c2)
    else:
      p2.addPair(c2, c1)

proc solveP2(p1, p2: var Deque[int]): int =
  result = if game(p1, p2):
      calcScore(p1)
    else:
      calcScore(p2)

when isMainModule:
  let (p1, p2) = block:
    let f = readFile("input/aoc22.txt").split("\n\n")
    func parse(f: string): seq[int] = f.strip().splitLines() --> drop(1).map(parseInt)
    (parse(f[0]).toDeque(), parse(f[1]).toDeque())
  
  block Part1:
    var (p1, p2) = (p1, p2)
    echo solveP1(p1, p2)

  block Part2:
    var (p1, p2) = (p1, p2)
    echo solveP2(p1, p2) 
