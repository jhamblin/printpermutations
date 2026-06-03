#!/usr/bin/env bash
# Test suite for the perm program.
set -euo pipefail

PERM="./perm"
PASS=0
FAIL=0

# ---- helpers ----

assert_output() {
    local label="$1" input="$2" expected="$3"
    actual=$("$PERM" "$input" 2>&1 || true)
    if [ "$actual" = "$expected" ]; then
        PASS=$((PASS + 1))
        echo "  PASS  $label"
    else
        FAIL=$((FAIL + 1))
        echo "  FAIL  $label"
        echo "        input:    '$input'"
        echo "        expected: $(echo "$expected" | head -5)"
        echo "        actual:   $(echo "$actual"   | head -5)"
    fi
}

assert_line_count() {
    local label="$1" input="$2" expected_count="$3"
    actual_count=$("$PERM" "$input" 2>/dev/null | wc -l | tr -d ' ')
    if [ "$actual_count" -eq "$expected_count" ]; then
        PASS=$((PASS + 1))
        echo "  PASS  $label"
    else
        FAIL=$((FAIL + 1))
        echo "  FAIL  $label"
        echo "        expected $expected_count lines, got $actual_count"
    fi
}

assert_all_unique() {
    local label="$1" input="$2"
    total=$("$PERM" "$input" 2>/dev/null | wc -l | tr -d ' ')
    unique=$("$PERM" "$input" 2>/dev/null | sort -u | wc -l | tr -d ' ')
    if [ "$total" -eq "$unique" ]; then
        PASS=$((PASS + 1))
        echo "  PASS  $label"
    else
        FAIL=$((FAIL + 1))
        echo "  FAIL  $label ($total total, $unique unique)"
    fi
}

assert_all_same_length() {
    local label="$1" input="$2"
    local expected_len="${#input}"
    bad=$("$PERM" "$input" 2>/dev/null | awk -v len="$expected_len" 'length != len' | wc -l | tr -d ' ')
    if [ "$bad" -eq 0 ]; then
        PASS=$((PASS + 1))
        echo "  PASS  $label"
    else
        FAIL=$((FAIL + 1))
        echo "  FAIL  $label ($bad lines with wrong length)"
    fi
}

assert_all_anagrams() {
    local label="$1" input="$2"
    sorted_in=$(echo "$input" | grep -o . | sort | tr -d '\n')
    bad=$("$PERM" "$input" 2>/dev/null | while IFS= read -r line; do
        sorted_out=$(echo "$line" | grep -o . | sort | tr -d '\n')
        if [ "$sorted_in" != "$sorted_out" ]; then echo "BAD"; fi
    done | wc -l | tr -d ' ')
    if [ "$bad" -eq 0 ]; then
        PASS=$((PASS + 1))
        echo "  PASS  $label"
    else
        FAIL=$((FAIL + 1))
        echo "  FAIL  $label ($bad non-anagram lines)"
    fi
}

# ---- tests ----

echo "Running tests..."
echo

# Empty string
assert_output "empty string produces one empty line" "" ""

# Single character
assert_output     "single char 'a'" "a" "a"
assert_line_count "single char line count" "a" 1

# Two characters - exact output
assert_output     "two chars 'ab' exact output" "ab" "$(printf 'ab\nba')"
assert_line_count "two chars line count (2! = 2)" "ab" 2

# Three characters
assert_line_count      "three chars line count (3! = 6)" "abc" 6
assert_all_unique      "three chars all unique" "abc"
assert_all_same_length "three chars all length 3" "abc"
assert_all_anagrams    "three chars all anagrams of input" "abc"

# Four characters
assert_line_count      "four chars line count (4! = 24)" "abcd" 24
assert_all_unique      "four chars all unique" "abcd"
assert_all_same_length "four chars all length 4" "abcd"
assert_all_anagrams    "four chars all anagrams of input" "abcd"

# Five characters
assert_line_count "five chars line count (5! = 120)" "abcde" 120
assert_all_unique "five chars all unique" "abcde"

# Duplicate characters - still n! positional permutations
assert_line_count      "dupes 'aab' produces 3! = 6 lines" "aab" 6
assert_all_same_length "dupes 'aab' all length 3" "aab"
assert_all_anagrams    "dupes 'aab' all anagrams" "aab"

# First output line is the original string
first=$("$PERM" "wxyz" 2>/dev/null | head -1)
if [ "$first" = "wxyz" ]; then
    PASS=$((PASS + 1))
    echo "  PASS  first permutation is the original string"
else
    FAIL=$((FAIL + 1))
    echo "  FAIL  first permutation is the original string (got '$first')"
fi

# ---- summary ----

echo
echo "Results: $PASS passed, $FAIL failed"
[ "$FAIL" -ne 0 ] && exit 1
exit 0
