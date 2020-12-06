import zero_functional, pegs

const 
  RULE1 = """
    Passport <- (Val Val Val Val Val Val Val Val) / (Req Req Req Req Req Req Req)
    Val <- Req / (\s* 'cid:' \w*)
    Req <- \s* Field ':' \#? \w*
    Field <- 'pid' / 'byr' / 'iyr' / 'eyr' / 'hgt' / 'hcl' / 'ecl'
  """

  RULE2 = """
    Passport <- (Val Val Val Val Val Val Val Val) / (Req Req Req Req Req Req Req)
    Req <- \s* Field
    Val <- \s* (Field / cid)
    Field <- ecl / iyr / byr / eyr / hgt / hcl / pid
    
    cid <- 'cid:' \d+
    pid <- 'pid:' \d\d\d\d\d\d\d\d\d
    byr <- 'byr:' BYear
    iyr <- 'iyr:' IYear
    eyr <- 'eyr:' EYear
    hgt <- 'hgt:' Height
    hcl <- 'hcl:' HColour
    ecl <- 'ecl:' EyeColour

    Byear <- ('19' [2-9] \d) / ('200' [0-2])
    IYear <- '20' (('1' \d) / '20')
    EYear <- ('202' \d) / '2030'

    Height <- Hcm / Hin
      Hcm <- '1' (([5-8] \d) / ('9' [0-3])) 'cm'
      Hin <- ('59' / ('6' \d) / ('7' [0-6])) 'in'
    
    EyeColour <- 'amb' / 'blu' / 'brn' / 'gry' / 'grn' / 'hzl' / 'oth'
    HColour <- \# H H H H H H
      H <- [a-fA-F0-9]
"""
proc validatePass(pass: string, rule: string): bool =
  if pass =~ peg(rule):
    return true
  result = false

#later rewritten as an iterator in aocutils
proc readInput(path: string): seq[string] =
  var buf: string
  for line in open(path).lines():
    if line != "":
      buf.add(line & ' ')
    else:
      result.add(buf)
      buf = ""
  if buf.len() > 0: # EOF
    result.add(buf)

when isMainModule:
  let input = readInput("input/aoc04.txt")
  block Part1:
    echo input --> map(validatePass(it, RULE1).ord()).sum()
  block Part2:
    echo input --> map(validatePass(it, RULE2).ord()).sum()
