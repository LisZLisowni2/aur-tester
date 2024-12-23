#include "utils.h"
#include <string>
#include <cstdlib>
#include <iostream>
#include <stdexcept>

void executeCommand(const std::string& command) {
    int result = std::system(command.c_str());
    if (result != 0) {
        throw std::runtime_error("Command failed: " + command);
    }
}

void handleFlags(int& argv, char** argc, std::string& packageName, bool& verbose, bool& minimalScan, const std::string& VERSION) {
    int i = 1;
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
}