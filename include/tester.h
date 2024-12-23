#ifndef TESTER_H
#define TESTER_H

#include <string>

class Tester {
private:
    bool verbose;
    bool minimalScan;
    std::string package;
public:
    Tester(bool _verbose, bool _minimalScan, std::string _package);
    void test();
    void runContainer();
    void updateSystem();
    void installPackage();
    void differenceFile();
    void scanForMalware();
    void scanForRootkit();
};

#endif