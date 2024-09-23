#include <iostream>
#include <unistd.h>
#include <limits.h>

int main()
{
    char cwd[PATH_MAX]; // Buffer to hold the current working directory
    if (getcwd(cwd, sizeof(cwd)) != nullptr)
    {
        std::cout << "Current working directory: " << cwd << std::endl;
    }
    else
    {
        perror("getcwd() error");
    }
    return 0;
}
