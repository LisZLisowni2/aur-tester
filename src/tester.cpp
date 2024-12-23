#include "tester.h"
#include <string>
#include <iostream>
#include <stdexcept>

Tester::Tester(bool _verbose, bool _minimalScan, std::string _package) {
    verbose = _verbose;
    minimalScan = _minimalScan;
    package = _package;
};

void Tester::test() {
    runContainer();
    updateSystem();
    installPackage();
    differenceFile();
    scanForMalware();
    scanForRootkit();
}