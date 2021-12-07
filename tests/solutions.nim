import std/[osproc, os]

template exec(s: static string): string =
  osproc.execProcess(
    when defined(windows):
      s.changeFileExt("exe")
    else:
      s
  )

doAssert exec("./aoc01") == "1005459\n92643264\n"
doAssert exec("./aoc02") == "393\n690\n"
doAssert exec("./aoc03") == "85\n3952146825\n"
doAssert exec("./aoc04") == "210\n131\n"
doAssert exec("./aoc05") == "965\n524\n"
doAssert exec("./aoc06") == "6714\n3435\n"
doAssert exec("./aoc07") == "161\n30899\n"
doAssert exec("./aoc08") == "1501\n509\n"
doAssert exec("./aoc09") == "373803594\n51152360\n"
doAssert exec("./aoc10") == "2201\n169255295254528\n"
doAssert exec("./aoc11") == "2453\n2159\n"
doAssert exec("./aoc12") == "1457\n106860\n"
doAssert exec("./aoc13") == "3464\n760171380521445\n"
doAssert exec("./aoc14") == "17934269678453\n3440662844064\n"
doAssert exec("./aoc15") == "403\n6823\n"
doAssert exec("./aoc16") == "22057\n1093427331937\n"
doAssert exec("./aoc17") == "263\n1680\n"
doAssert exec("./aoc18") == "13976444272545\n88500956630893\n"
doAssert exec("./aoc19") == "195\n309\n"

doAssert exec("./aoc21") == "2826\npbhthx,sqdsxhb,dgvqv,csnfnl,dnlsjr,xzb,lkdg,rsvlb\n"
doAssert exec("./aoc22") == "30197\n34031\n"
doAssert exec("./aoc23") == "25468379\n474747880250\n"
doAssert exec("./aoc24") == "254\n3697\n"
doAssert exec("./aoc25") == "5025281\n"
