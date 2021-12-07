import sequtils, strutils, sets, tables, zero_functional

type
  Foods = object
    ings: seq[string]
    algs: seq[string]
  Ingredients = object
    allergens: OrderedTable[string, string]
    regular: CountTable[string]

func separate(data: openArray[Foods]): Ingredients =
  var potential: Table[string, HashSet[string]]
  for food in data:
    for ingredient in food.ings:
      result.regular.inc(ingredient)
    let ingSet = food.ings.toHashSet()
    for allergen in food.algs:
      if potential.hasKeyOrPut(allergen, ingSet):
        potential[allergen] = intersection(potential[allergen], ingSet)
  while potential.len > 0:
    var prune: seq[string]
    for (allergen, potSet) in potential.mpairs():
      if potSet.len() > 1:
        for (determined, alName) in result.allergens.pairs():
          if determined != allergen:
            potSet.excl(alName)
      elif potSet.len() == 1:
        result.allergens[allergen] = potSet.pop()
      else: prune.add(allergen)
    for empty in prune:
      potential.del(empty)
  result.allergens.sort(system.cmp) # necessary for solveP2!
  for alName in result.allergens.values():
    result.regular.del(alName)

func solveP1(ingredients: Ingredients): int =
  ingredients.regular.values() --> sum()

func solveP2(ingredients: Ingredients): string =
  # table must be sorted on earlier stage!
  result = toSeq(ingredients.allergens.values()).join(",")

func parseInputLine(s: string): Foods =
  let
    split = s.split("(contains ")
    ings = split[0].split() --> filter(it != "")
    algs = split[1].split(Whitespace + {',', ')'}) --> filter(it != "")
  result = Foods(ings: ings, algs: algs)

when isMainModule:
  let
    input = lines("input/aoc21.txt") --> map(parseInputLine)
    ingredients = separate(input)
  
  block Part1:
    echo solveP1(ingredients)

  block Part2:
    echo solveP2(ingredients)
