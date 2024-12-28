#include "utils.h"
#include "tester.h"
#include <string>
#include <iostream>
#include <stdexcept>

void Tester::makeCopySystem(const std::string& name) {
    executeCommand("find /usr /opt /lib /lib64 /var /etc -type f > /tmp/" + name + ".txt");
    executeCommand("sort /tmp/" + name + ".txt > /tmp/" + name + ".sort");
}