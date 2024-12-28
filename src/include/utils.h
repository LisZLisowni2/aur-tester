#ifndef UTILS_H
#define UTILS_H

#include <string>

int executeCommand(const std::string& command);
void handleFlags(int& argv, char** argc, std::string& packageName, bool& verbose, bool& minimalScan, const std::string& VERSION);
void logCmd(const std::string& text);
std::string now();

#endif // UTILS_H