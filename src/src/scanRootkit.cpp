#include "utils.h"
#include "tester.h"
#include <string>
#include <iostream>
#include <stdexcept>

void Tester::scanForRootkit() {
    logCmd("Update the rkhunter database");
    try {
        executeCommand("rkhunter --update");
    } catch (...) {
        logCmd("Update the rkhunter database failed, continuing...");
    }
    logCmd("Apply the update");
    executeCommand("rkhunter --propupd");
    logCmd("Scan for rootkits");
    executeCommand("rkhunter --check --enable rootkits --rwo");
}