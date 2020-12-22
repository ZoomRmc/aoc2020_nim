import sequtils, strutils, zero_functional, tables
import nre except toSeq

type Rules = TableRef[int, string]

proc getInputRulesRE(s: string): Rules =
  result = newTable[int, string]()
  for l in s.splitLines():
    let (rn, rule) = (let split = l.split(": "); (split[0], split[1]))
    result[rn.parseInt()] = rule.replace("\"", "")

func compose(rule: string; rules: Rules): string =
  result = try:
      let 
        rn = rule.parseInt()
        exp = rules[rn].split(" ").mapIt(compose(it, rules)).join() 
      "(?:" & exp & ")"
    except:
      rule

func buildRe(rules: Rules): string =
  compose("0", rules) & "\\z"

proc calc(input: string; reg: Regex): int =
 result = input.splitLines() -->
    map(match(it, reg).isSome()).
    filter(it == true).count()

when isMainModule:
  var (rules, input) = block:
    let t = readFile("input/aoc19.txt").split("\n\n")
    (getInputRulesRE(t[0]), t[1])
 
  block Part1:
    let reg = re(buildRe(rules))
    echo calc(input, reg)
   
  block Part2:
    rules[8] = "42 +"
    rules[11] = "(?P<g> 42 (?&g)? 31 )"
    let reg = re(buildRe(rules))
    echo calc(input, reg)
