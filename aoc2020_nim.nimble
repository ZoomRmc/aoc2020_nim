# Package

version       = "0.1.0"
author        = "ZoomRmc"
description   = "AOC 2020 in Nim"
license       = "GPL-2.0"
srcDir        = "src"

bin           = @["aoc01", "aoc02", "aoc03", "aoc04", "aoc05", "aoc06", "aoc07", "aoc08",
                  "aoc09", "aoc10", "aoc11", "aoc12", "aoc13", "aoc14", "aoc15", "aoc16",
                  "aoc17", "aoc18", "aoc19",          "aoc21", "aoc22", "aoc23", "aoc24",
                  "aoc25"]


# Dependencies

requires "nim >= 1.4.2"
requires "zero_functional >= 1.2.0"
requires "stew"

task test, "Run all tests":
  exec "nimble build"
  exec "testament r solutions.nim"