import strutils, strscans, tables, sequtils, stew/results

const TestPrg = "nop +0\nacc +1\njmp +4\nacc +3\njmp -3\nacc -99\nacc +1\njmp -4\nacc +6"

type
  Instruction = enum nop acc jmp
  Operation = tuple[inst: Instruction, val: int]
  Program = seq[Operation]

proc parseInstruction(s: string; inst: var Instruction; _: int): int =
  result = try:
      inst = parseEnum[Instruction](s[0..2])
      3
    except:
      0

func parseProgram(input: sink seq[string]): Program =
  for s in input:
    var op: Operation
    if scanf(s, "${parseInstruction} $i", op.inst, op.val):
      result.add( op )

proc computeOp(rax, idx: var int; op: Operation) {.inline.} =
  case op.inst:
    of acc:
      rax += op.val
      idx += 1
    of jmp: idx += op.val
    else: idx += 1

func computeUntilEnd(program: openArray[Operation]): Result[int, int] =
  var
    rax, i: int
    counter: CountTable[int]
  while i < program.len():
    if counter[i] > 0:
      return err(rax)
    else:
      counter.inc(i)
      computeOp(rax, i, program[i])
  result = ok(rax)

proc flipInst(inst: var Instruction) {.inline.} =
  inst = case inst:
    of jmp: nop
    of nop: jmp
    else: inst

proc eliminateLoop(program: var Program): int =
  #TODO: extract from here and computeUntilEnd to template?
  var
    rax, i: int
    stack: seq[int]
    counter: CountTable[int]
  while counter[i] != 1:
    counter.inc(i)
    let op = program[i]
    if op.inst in {jmp, nop}:
      stack.add(i)
    computeOp(rax, i, op)

  var res = Result[int, int].err(0)
  while res.isErr() and stack.len > 0:
    let flipId = stack.pop()
    program[flipId].inst.flipInst()
    res = computeUntilEnd(program)
    program[flipId].inst.flipInst()
  result = res.get()

proc doTest() =
  var prg = parseProgram(toSeq(TestPrg.splitLines()))
  doAssert computeUntilEnd(prg).error() == 5
  doAssert eliminateLoop(prg) == 8

when isMainModule:
  doTest()
  var prg = parseProgram(toSeq(lines("input/aoc08.txt")))

  block Part1:
    echo computeUntilEnd(prg).error()
  
  block Part2:
    echo eliminateLoop(prg)
