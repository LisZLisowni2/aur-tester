#ifndef UTILS_H
#define UTILS_H

#include <string>

void executeCommand(const std::string& command);
void handleFlags(int& argv, char** argc, std::string& packageName, bool& verbose, bool& minimalScan, const std::string& VERSION);

#endif // UTILS_H