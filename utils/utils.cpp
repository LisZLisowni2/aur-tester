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