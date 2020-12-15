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

### Day 15:
[Van Eck sequence](https://oeis.org/A181391), nothing fancy, though I opted for a mutating iterator here. Could be sped-up with a sequence instead of a table, but the speed of a naïve solution is still reasonable.

A sequence can be used in two ways:
    - As a substitute for a table: Max N in a sequence is never > round it appeared last, so length of the sequence equal to the number of rounds can store all possible values.
    - Sequential memory, which requires scanning it backwards, but mostly not far, so it's still fast.

Haven't tried to compare the speed of these approaches yet.

### Day 14:
This took me more time than I was comfortable with, since the solution required a bit of parsing and then a lot of monitoring for off-by-one, bit order and logical bitwise operation correctness. The main idea for permutation in Part 2 is keeping the indexes of "floating" bits, incrementing a number `i` up to 2^(number of floating bits) and setting each floating bit to a corresponding bit of `i`. 

This is probably the first time I ended up with the amount of boilerplate code which is a bit larger than justified by complexity of the task.

### Day 13:
When you see only prime numbers in input and test data you know there's a twist. Tried to come up with a solution without looking for any existing algos, so no CRT here. Accumulation and growing an increment (`jump` in the code) is certainly good enough for the task and almost instant.

### Day 12:
Pretty pleased with my solution, enum ordering + modulo arithmetic fit nicely, wonder if it's the intended way to approach the task. Writing the solution was too smooth: coded in the rotation around a point before reading it's always around `0,0`. Again, Eric went easy on us, so only quarter-turn angles = no trigonometry involved. Left out 2 approaches to CCW turns, not sure which one is better.

### Day 11:
Just counting indexes. Tedious and not much rewarding. Nim's std doesn't help much with anything 2D, so wrote a couple of iterators for `aocutils.nim` just in case. General technique of surrounding the matrix with empty cells could simplify working the edges/corners, but not necessary this time.

Spent more time separating code into logical chunks, but can't say the resulting template and surrounding functions are a work of art. Pretty *meh* task overall, at least printing matrix to stdout looks cool.

### Day 10:
It's tempting to just throw a bunch of resources to brute-force it, and, surprisingly, that's what a lot of people did, not too successfully. A couple of minutes with pen and paper pays off.

### Day 9:
Basic algo, no surprises, double-ended queue and a bunch of `IntSet`s. Thank heavens we search for a *contiguous* set in P2.

### Day 8:
Surprisingly not hard, as the "program" runs sequentially without any branching, so simple counting works for loop detection. Dumb backtracking and flipping `jmp`s and `nop`s.

### Day 7:
I don't like recursive solutions, but this task is not worth growing a forest over.
Part 2: On the first run I expectedly forgot multiplication. Please, nod to your screen if you did too.

### Day 6:
The second time the input is presented as a bunch of lines separated by a blank one: time to write an iterator for `aocutils`. Nim doesn't allow to attach to native `lines` iter, so the easiest thing is to resort to collecting in an intermediate sequence. Nasty.

zero-functional maps and folds (as well as std's `mapIt` and such) feel a bit clumsy with their 'a's and 'it's instead of just taking closures, thus again have to insert `block`s inside fold() parens.

### Day 5:
In Part 2 we know the numbers are continuous except one, so `xor` it is.

### Day 4:
Initial solution for the Part 1 used parsing named enums, storing them in an `IntSet` and comparing the set with the full one, but I knew from the start I'll need to parse it all in the Part 2. PEGs to the rescue, although, [docs](https://nim-lang.org/docs/pegs.html) are on the speccy side and rather sparse, so had to do lots of experimenting.

### Day 3:
[zero_functional](https://github.com/zero-functional/zero-functional) turned out not ergonomic *enough* here, so had to use `countup` and indexing, instead of iterating over items and enumerating pre- and post- filter.
