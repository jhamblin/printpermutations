# printpermutations

A command-line tool that prints every permutation of a given string, one per line.
It uses a recursive in-place swap algorithm to generate all n! orderings without extra allocation.

## Build

```bash
make
```

Compiles `perm.cpp` into an executable called `perm`.

## Usage

```bash
./perm <string>
```

**Examples**

```
$ ./perm ab
ab
ba

$ ./perm abc
abc
acb
bac
bca
cba
cab
```

Output is always n! lines for an n-character input.

## Tests

```bash
make test
```

Builds the program if needed, then runs a shell-based test suite that checks
exact output, line counts, uniqueness, consistent length, and anagram correctness
across a range of inputs.

## How it works

`PrintPermutations(letters, startPos)` fixes one position at a time:

1. For each index `i` from `startPos` to the end, swap `letters[startPos]` with `letters[i]`.
2. Recurse with `startPos + 1`.
3. Swap back to restore original order before the next iteration.

Time: O(n!). Space: O(n) stack depth.
