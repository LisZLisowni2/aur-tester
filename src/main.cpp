#include <iostream>
#include <cstdlib>
#define VERSION "1.0.0"

int main(int argv, char** argc) {
    if (argv < 1) {
        std::cout << "No arguments";
        exit(1);
    }
    int i = 1;
    bool verbose = false;
    bool minimalScan = false;
    std::string packageName = "";
    while (i < argv) {       
        std::string arg = argc[i];
        if (arg == "-v" || arg == "--verbose") {
            verbose = true;
        } else if (arg == "--version") {
            std::cout << "aur-tester version: " << VERSION << "\n";
            exit(0);
        } else if (arg == "-s" || arg == "--minimal-scan") {
            minimalScan = true;
        } else if (i == argv) {
            packageName = argc[i];
        } else {
            std::cout << "Unknown option";
            exit(1);
        }
        i++;
    }
    return 0;
}