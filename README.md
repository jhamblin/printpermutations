# printpermutations

An interview question: given a string, print every permutation of its characters, one per line.

## What this question evaluates

- **Recursion and backtracking** -- the candidate must decompose the problem into a self-similar subproblem (fix one position, recurse on the rest, undo).
- **In-place thinking** -- the cleanest solutions mutate the input array and restore it rather than building new strings, revealing comfort with pointer/reference manipulation.
- **Complexity awareness** -- there are n! permutations of n characters; a candidate should be able to state this and recognize that no algorithm can do better than O(n!) output.
- **Edge-case handling** -- empty strings, single characters, duplicate characters, and missing input all need consideration.
- **Language fluency** -- the reference solution is C++; watch for correct use of `std::swap`, `size_t` vs `int`, null-pointer guards on `argv`, and consistent formatting.

## Common approaches

| Approach | Idea | Trade-offs |
|---|---|---|
| **Swap-and-recurse (this repo)** | Fix position `i`, swap the character there with each later character, recurse on `i+1`, swap back. | O(n!) time, O(n) stack, in-place. Simple and efficient. |
| **Choose-and-remove** | Pick a character from the remaining set, append it to a prefix, recurse on the smaller set. | Easier to reason about but creates new strings at every level -- O(n * n!) allocations. |
| **Heap's algorithm** | Generate permutations by swapping a single pair per step using a direction array. | Minimizes swaps (exactly n! - 1) but harder to explain and implement correctly. |
| **Lexicographic / next-permutation** | Sort the input, then repeatedly find the next lexicographic permutation in-place. | Produces sorted output, avoids recursion, but the "find next" step is tricky to get right. |
| **Insert-at-each-position** | Take the first character, recursively permute the rest, insert the first character at every position in each result. | Conceptually clear but builds many intermediate lists. |

## How to assess solutions

**Strong signals**
- Correctly generates all n! orderings with no duplicates (for distinct characters).
- Can articulate why the time complexity is O(n!) and that this is unavoidable.
- Handles edge cases: empty input, single character, no-argument invocation.
- Writes clean, consistently formatted code without prompting.
- Explains the backtracking step ("swap back") and why it is necessary.

**Bonus points**
- Discusses how to handle duplicate characters (skip swaps when `letters[i] == letters[startPos]` for `i != startPos` to avoid repeated output).
- Mentions alternative approaches and their trade-offs (see table above).
- Considers iterative solutions (Heap's, next-permutation) and when they might be preferred.
- Analyzes stack depth and whether tail-call optimization applies (it doesn't here).

**Red flags**
- Cannot identify the base case or gets the recursion wrong.
- Produces duplicate or missing permutations.
- Ignores edge cases entirely (segfault on empty input, off-by-one on length).
- Cannot estimate the output size or time complexity.
- Overly complex solution that obscures the core idea.

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

## Test suite

```bash
make test
```

Builds the program if needed, then runs a shell-based test suite that checks
exact output, line counts, uniqueness, consistent length, and anagram correctness
across a range of inputs.

## Reference implementation

The included `perm.cpp` uses the swap-and-recurse approach:

1. For each index `i` from `startPos` to the end, swap `letters[startPos]` with `letters[i]`.
2. Recurse with `startPos + 1`.
3. Swap back to restore original order before the next iteration.

Time: O(n!). Space: O(n) stack depth. No heap allocation.
