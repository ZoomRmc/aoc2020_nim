import sequtils, strutils, pegs, std/enumerate, tables 

const NFIELDS = 20 # pegs support max 20 matches!

type
  Field = enum
    dep_l = "departure location",
    dep_st = "departure station",
    dep_pl = "departure platform",
    dep_tr = "departure track",
    dep_d = "departure date",
    dep_t = "departure time",
    arr_l = "arrival location",
    arr_st = "arrival station",
    arr_pl = "arrival platform",
    arr_tr = "arrival track",
    cl = "class",
    dur = "duration",
    pr = "price",
    rt = "route",
    row, seat, train,
    tp = "type",
    w = "wagon",
    z = "zone"
  
  Ticket = array[NFIELDS, int]
  FieldSet = set[0..65535]
  FieldRule = object
    f: Field
    s: FieldSet
  
  State = object
    fields: seq[FieldRule]
    myTicket: Ticket
    tickets: seq[Ticket]

let 
  RulesField = """
field <- field_n field_v
field_n <- {\w+ (\s \w+)?} ':' \s
field_v <- {\d+} '-' {\d+} \s 'or' \s {\d+} '-' {\d+}""".peg
  RulesTicket = """Ticket <- {\d+} ',' ({\d+} ',')* {\d+}""".peg

proc parseTicket(s: string): Ticket =
  if s =~ RulesTicket:
    for (i, f) in matches.pairs():
      result[i] = parseInt(f)

proc parseFieldRule(s: string): FieldRule =
  if s =~ RulesField:
    result = FieldRule(
      f: parseEnum[Field](matches[0]),
      s: {matches[1].parseInt() .. matches[2].parseInt()} +
         {matches[3].parseInt() .. matches[4].parseInt()}
    )

func isFieldValidAny(n: int, fields: openArray[FieldRule]): bool =
  result = false
  for f in fields:
    if n in f.s:
      return true

func isTicketValid(t: Ticket, fields: openArray[FieldRule]): bool =
  result = true
  var possibleFields = newSeq[set[Field]](NFIELDS)
  for (fieldN, n) in t.pairs(): # each num
    for fieldRule in fields:
      if n in fieldRule.s:
        possibleFields[fieldN].incl(fieldRule.f)
    if possibleFields[fieldN] == {}:
      return false

proc parseInputFile(path: string): State =
  for (i, l) in enumerate(lines(path)): # *"We do not collect"*
    if i in 0..19:
      result.fields.add(parseFieldRule(l))
    elif i == 22:
      result.myTicket = parseTicket(l)
    elif i > 24:
      result.tickets.add(parseTicket(l))

func solveP1(input: State): int =
  for t in input.tickets:
    for f in t:
      if not isFieldValidAny(f, input.fields): result += f

func solveP2(input: State): int =
  var positions = repeat[Fieldset]({}, NFIELDS)
  for t in input.tickets:
    if t.isTicketValid(input.fields):
      for (i, n) in t.pairs():
        positions[i].incl(n)
  var possibleFields = newSeq[set[Field]](NFIELDS)
  for (i, s) in positions.pairs():
    for field in input.fields:
      if s <= field.s:
        possibleFields[i].incl(field.f)
  # Elimination
  var
    fieldMap: Table[Field, int]
  while fieldMap.len() < NFIELDS: # Cross fingers for correct input!
    var elim: Field
    for (position, s) in possibleFields.mpairs():
      if s.len() == 1:
        for f in s: elim = f
        fieldMap[elim] = position
        break
    for s in possibleFields.mitems():
      s.excl(elim)
  result = 1
  for f in dep_l..dep_t:
    result *= input.myTicket[fieldMap[f]]

when isMainModule:
  let input = parseInputFile("input/aoc16.txt")

  block Part1:
    echo solveP1(input)

  block Part2:
    echo solveP2(input)
