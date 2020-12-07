import pegs, tables, strutils, zero_functional

const RULES = """
Rule <- {Bag} \s 'bags contain' ((\s {Num} \s {Bag} \s 'bag' 's'? (',' / '.'))+ / None)
Num <- \d+
None <- \s 'no other bags.'
Bag <- \w+\s\w+
"""

type Fits = seq[(string, int)]

func parseMatches(matches: openArray[string]): Fits =
  var idx = 1
  while idx < matches.len() and matches[idx] != "":
    result.add( (matches[idx+1], matches[idx].parseInt()) )
    idx += 2

func canHold(bag, aim: string; table: TableRef): bool =
  for b, f in table[bag].items():
    if b == aim or canHold(b, aim, table):
      return true
    else:
      result = false      

func countHeld(bag: string; table: TableRef): int =
  for b, f in table[bag].items():
    result += f + f * countHeld(b, table)

when isMainModule:
  var table = newTable[string, Fits]()
  for l in lines("input/aoc07.txt"):
    if l =~ peg(RULES):
      let bag = matches[0]
      table[bag] = parseMatches(matches)
  
  block Part1:
    echo table.keys() --> map(canHold(it, "shiny gold", table).ord()).sum()
  
  block Part2:
    echo countHeld("shiny gold", table)
