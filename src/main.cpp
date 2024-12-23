#include "utils.h"
#include "tester.h"
#include <iostream>
#include <cstdlib>
#define VERSION "1.0.0"

int main(int argv, char** argc) {
    if (argv < 2) {
        std::cout << "No arguments\n";
        exit(1);
    }
    bool verbose = false;
    bool minimalScan = false;
    std::string packageName = "";
    handleFlags(argv, argc, packageName, verbose, minimalScan, VERSION);
    std::cout << "Verbose: " << verbose << "\n";
    std::cout << "Minimal scan: " << minimalScan << "\n";
    std::cout << "Package name: " << packageName << "\n";
    if (packageName.length() == 0) {
        std::cout << "Package name not present\n";
        exit(2);
    }
    Tester tester = Tester(verbose, minimalScan, packageName);
    tester.test();
    return 0;
}