#include "tester.h"
#include "utils.h"
#include "global.h"
#include <string>
#include <iostream>
#include <stdexcept>

void Tester::runContainer() {
    logCmd("Running the docker container");
    // Test the docker is running
    int res = executeCommand("systemctl is-active --quiet docker");
    if (res != 0) {
        executeCommand("systemctl start docker");
    }

    executeCommand("docker run --rm -it --user root --name " + package + "-testing aur-tester-image:" + VERSION);
    logCmd("Container has run");
}