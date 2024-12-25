#include "tester.h"
#include "utils.h"
#include "installPackage.cpp"
#include "scanMalware.cpp"
#include "scanRootkit.cpp"
#include <string>
#include <iostream>
#include <stdexcept>

Tester::Tester(bool _verbose, bool _minimalScan, std::string _package) {
    logCmd("Testing started");
    verbose = _verbose;
    minimalScan = _minimalScan;
    package = _package;
};

Tester::~Tester() {
    logCmd("Testing finished");
}

void Tester::test() {
    installPackage();
    // differenceFile();
    // scanForMalware();
    // scanForRootkit();
}