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
    inline void runContainer();
    inline void updateSystem();
    inline void installPackage();
    inline void differenceFile();
    inline void scanForMalware();
    inline void scanForRootkit();
};

#endif