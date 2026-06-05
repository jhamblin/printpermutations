CXX      ?= g++
CXXFLAGS ?= -Wall -Wextra -std=c++17
TARGET    = perm
SRC       = perm.cpp

.PHONY: all clean test

all: $(TARGET)

$(TARGET): $(SRC)
	$(CXX) $(CXXFLAGS) -o $@ $<

test: $(TARGET)
	@./tests/run_tests.sh

clean:
	rm -f $(TARGET)
