#include "utils.h"
#include "tester.h"
#include "makeCopy.cpp"
#include "difference.cpp"
#include <string>
#include <iostream>
#include <stdexcept>

void Tester::scanForRootkit() {
    logCmd("Update the rkhunter database");
    executeCommand("rkhunter --update");
    executeCommand("rkhunter --propupd");
    executeCommand("rkhunter --check --enable rootkits --rwo");
}