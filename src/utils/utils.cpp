#include "utils.h"
#include <string>
#include <cstdlib>
#include <iostream>
#include <stdexcept>
#include <ctime>
#include <chrono>
#include <sstream>
#include <iomanip>

int executeCommand(const std::string& command) {
    int result = std::system(command.c_str());
    if (result != 0) {
        throw std::runtime_error("Command failed: " + command);
    }
    return result;
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
        } else if (arg[0] != '-') {
            packageName = argc[i];
        } else {
            std::cout << "Unknown option";
            exit(3);
        }
        i++;
    }
}

std::string now() {
    auto timestamp = std::chrono::system_clock::now();
    auto in_time_t = std::chrono::system_clock::to_time_t(timestamp);

    std::stringstream ss;
    ss << std::put_time(std::localtime(&in_time_t), "%Y-%m-%d %H:%M:%S");
    return ss.str();
}

void logCmd(const std::string& text) {
    std::string datetime = now();
    std::cout << "[" << datetime << "] " << text << "\n";
}