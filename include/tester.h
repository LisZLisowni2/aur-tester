#ifndef TESTER_H
#define TESTER_H

#include <string>

class Tester {
private:
    bool verbose;
    bool minimalScan;
    std::string package;
    inline void installPackage();
    inline void differenceFile();
    inline void scanForMalware();
    inline void scanForRootkit();
public:
    Tester(bool _verbose, bool _minimalScan, std::string _package);
    ~Tester();
    void test();
};

#endif