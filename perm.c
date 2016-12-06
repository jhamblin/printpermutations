#include <cstring>
#include <iostream>
#include <utility>

void PrintPermutations(char* letters, int startPos)
{
    if (startPos == strlen(letters))
    {
	std::cout << letters << '\n';
	return;
    }
		 
    for (size_t i = startPos; i < strlen(letters); ++i)
    {
	std::swap(letters[startPos], letters[i]);
        PrintPermutations(letters, startPos + 1);
	std::swap(letters[i], letters[startPos]);
    }
}

int main(int argc, char** argv)
{
    PrintPermutations(argv[1], 0);
    return 0;
}

