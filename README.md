# aoc2020_nim
AOC 2020 in Nim

## General notes
What I'm trying to stick to while writing the solutions, in order of importance:
 - Intelligible implementation logic, clear data flow
 - Brevity must not hurt readability
 - Short, self-sustaining functions with evident behaviour, hopefully as "strict" as reasonable
 - Keep the solutions for both parts of the task separated (one should work in case the other was removed from the code), extract repeating computations to functions/templates
 - Use the more suitable data structures available (it's tempting and boring to solve *everything* with Hash Tables)
 - Explore standard library before jumping to external libs

## Notes on specific days
**Spoilers below!**

### Day 7:
I don't like recursive solutions, but this task is not worth growing a forest over.
Part 2: On the first run I expectedly forgot multiplication. Please, nod to your screen if you did too.

### Day 6:
The second time the input is presented as a bunch of lines separated by a blank one: time to write an iterator for `aocutils`. Nim doesn't allow to attach to native `lines` iter, so the easiest thing is to resort to collecting in an intermediate sequence. Nasty.

zero-functional maps and folds (as well as std's `mapIt` and such) feel a bit clumsy with their 'a's and 'it's instead of just taking closures, thus again have to insert `block`s inside fold() parens.

### Day 5:
In Part 2 we know the numbers are continuous except one, so `xor` it is.

### Day 4:
Initial solution for the Part 1 used parsing named enums, storing them in an `IntSet` and comparing the set with the full one, but I knew from the start I'll need to parse it all in the Part 2. PEGs to the resque, although, [docs](https://nim-lang.org/docs/pegs.html) are on the speccy side and rather sparse, so had to do lots of experimenting.

### Day 3:
[zero_functional](https://github.com/zero-functional/zero-functional) turned out not ergonomic *enough* here, so had to use `countup` and indexing, instead of iterating over items and enumerating pre- and post- filter.
