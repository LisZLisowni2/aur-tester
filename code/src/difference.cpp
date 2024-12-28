#include "utils.h"
#include "tester.h"
#include <string>
#include <set>
#include <iostream>
#include <fstream>
#include <stdexcept>
#include <iterator>

void Tester::difference(const std::string& name1, const std::string& name2, const std::string& output) {
    std::ifstream beforeFile(name1);
    std::ifstream afterFile(name2); 
    std::ofstream outputFile(output);
    if (!beforeFile.is_open() || !afterFile.is_open()) {
        std::cerr << "Error: Unable to open input files.\n";
        return;
    }
    if (!outputFile.is_open()) {
        std::cerr << "Error: Unable to open output file.\n";
        return;
    }

    std::set<std::string> beforeSet;
    std::set<std::string> afterSet;
    std::string line;

    while (std::getline(beforeFile, line)) {
        beforeSet.insert(line);
    }
    while (std::getline(afterFile, line)) {
        afterSet.insert(line);
    }
    for (const auto& entry : afterSet) {
        if (beforeSet.find(entry) == beforeSet.end()) {
            outputFile << entry << "\n";
        }
    }
    for (const auto& entry : beforeSet) {
        if (afterSet.find(entry) == afterSet.end()) {
            outputFile << entry << "\n";
        }
    }
    beforeFile.close();
    afterFile.close();
    outputFile.close();
}