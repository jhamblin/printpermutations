#include <cstring>
#include <iostream>
#include <utility>

void PrintPermutations(char* letters, size_t startPos)
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
    if (argc < 2)
    {
        std::cerr << "Usage: " << argv[0] << " <string>\n";
        return 1;
    }
    PrintPermutations(argv[1], 0);
    return 0;
}
