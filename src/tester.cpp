#include "tester.h"
#include <string>
#include <iostream>
#include <stdexcept>

Tester::Tester(bool _verbose, bool _minimalScan, std::string _package) {
    verbose = _verbose;
    minimalScan = _minimalScan;
    package = _package;
};

Tester::~Tester() {
    std::cout << "Testing finished" << "\n";
}

void Tester::test() {
    std::cout << "Testing\n";
    // installPackage();
    // differenceFile();
    // scanForMalware();
    // scanForRootkit();
}