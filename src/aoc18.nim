import std/pegs, zero_functional
from std/strutils import parseInt

let tok = """
Exp <- Val (\s* Op \s* Val)*
Val <- Num / '(' Exp ')'
Num <- [0-9]+
Op <- '*'/'+'
  """.peg

proc parseFirst(input: string): int =
  type Op = enum Add, Mul
  var
    stack: seq[(int, Op)] = @[]
    (acc, op) = (0, Add)
  let eval = tok.eventParser:
    pkNonTerminal:
      enter: # This replaces recursion
        if p.nt.name == "Exp":
          stack.add((acc, op))
          (acc, op) = (0, Add)
      leave:
        if length > 0:
          case p.nt.name
          of "Exp":
            let n = acc
            (acc, op) = stack.pop()
            acc = case op
              of Add: acc + n
              of Mul: acc * n
          of "Num":
            let n = s.substr(start, start + length - 1).parseInt()
            acc = case op
              of Add: acc + n
              of Mul: acc * n
          of "Op":
            op = if s[start] == '+': Add else: Mul
  discard eval(input)
  result = acc

proc parseSecond(input: string): int =
  var
    stack: seq[(int,int)] = @[]
    (acc, mul) = (0, 1)
  let eval = tok.eventParser:
    pkNonTerminal:
      enter: # This replaces recursion
        if p.nt.name == "Exp":
          stack.add((acc, mul))
          (acc, mul) = (0, 1)
      leave:
        if length > 0:
          case p.nt.name
          of "Exp":
            let val = acc
            (acc, mul) = stack.pop()
            acc.inc(val * mul)
          of "Num":
            let n = s.substr(start, start + length - 1).parseInt()
            acc.inc(n * mul)
          of "Op":
            if s[start] == '*':
              (acc, mul) = (0, acc)
  discard eval(input)
  result = acc

proc doTest() =
  doAssert "2 * 3 + (4 * 5)".parseFirst == 26
  doAssert "5 + (8 * 3 + 9 + 3 * 4 * 3)".parseFirst == 437
  doAssert "5 * 9 * (7 * 3 * 3 + 9 * 3 + (8 + 6 * 4))".parseFirst == 12240
  doAssert "((2 + 4 * 9) * (6 + 9 * 8 + 6) + 6) + 2 + 4 * 2".parseFirst == 13632

  doAssert "1 + (2 * 3) + (4 * (5 + 6))".parseSecond == 51
  doAssert "2 * 3 + (4 * 5)".parseSecond == 46
  doAssert "5 + (8 * 3 + 9 + 3 * 4 * 3)".parseSecond == 1445
  doAssert "5 * 9 * (7 * 3 * 3 + 9 * 3 + (8 + 6 * 4))".parseSecond == 669060
  doAssert "((2 + 4 * 9) * (6 + 9 * 8 + 6) + 6) + 2 + 4 * 2".parseSecond == 23340

when isMainModule:
  doTest()
  let (p1, p2) = lines("input/aoc18.txt") --> map((it.parseFirst, it.parseSecond))
    .reduce((it.accu[0] + it.elem[0], it.accu[1] + it.elem[1]))
  echo p1, "\n", p2
