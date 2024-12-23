#include "utils.h"
#include "tester.h"
#include <string>
#include <iostream>
#include <stdexcept>

void Tester::installPackage() {
    executeCommand("su buildtest -c 'git clone https://aur.archlinux.org/" + package + ".git'");
    executeCommand("sha256sum " + package + "/PKGBUILD");
    try {
        executeCommand("shellcheck " + package + "/PKGBUILD > logFromFileTest.txt");
    } catch (...) {
        std::cout << "Error on shellcheck, check the logFromFileTest.txt file!\n";
        executeCommand("nano logFromFileTest.txt");
    }
    executeCommand("su buildtest -c 'cd " + package + " && makepkg -is --noconfirm'");
}