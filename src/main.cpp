#include "utils.h"
#include <iostream>
#include <cstdlib>
#define VERSION "1.0.0"

int main(int argv, char** argc) {
    if (argv < 1) {
        std::cout << "No arguments";
        exit(1);
    }
    bool verbose = false;
    bool minimalScan = false;
    std::string packageName = "";
    handleFlags(argv, argc, packageName, verbose, minimalScan, VERSION);
    return 0;
}