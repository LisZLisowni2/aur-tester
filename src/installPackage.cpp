#include "utils.h"
#include "tester.h"
#include "makeCopy.cpp"
#include <string>
#include <iostream>
#include <stdexcept>

void Tester::installPackage() {
    if (minimalScan) {
        logCmd("Copy of system before installation");
        makeCopySystem("before");
    }
    logCmd("Install the package");
    executeCommand("su buildtest -c 'git clone https://aur.archlinux.org/" + package + ".git'");
    executeCommand("sha256sum " + package + "/PKGBUILD");
    try {
        executeCommand("shellcheck " + package + "/PKGBUILD > logFromFileTest.txt");
    } catch (...) {
        std::cout << "Error on shellcheck, check the logFromFileTest.txt file!\n";
        executeCommand("less logFromFileTest.txt");
    }
    executeCommand("su buildtest -c 'cd " + package + " && makepkg -is --noconfirm'");
    if (minimalScan) {
        logCmd("Copy of system after installation");
        makeCopySystem("after");
        logCmd("Different before and after installation");
        executeCommand("diff --speed-large-files /tmp/before.sort /tmp/after.sort > /tmp/changed.txt");
    }
}