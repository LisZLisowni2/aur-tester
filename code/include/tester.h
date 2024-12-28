#ifndef TESTER_H
#define TESTER_H
#pragma once

#include <string>

class Tester {
private:
    bool verbose;
    bool minimalScan;
    std::string package;
    inline void makeCopySystem(const std::string& name);
    inline void difference(const std::string& name1, const std::string& name2, const std::string& output);
    inline void installPackage();
    inline void scanForMalware();
    inline void scanForRootkit();
public:
    Tester(bool _verbose, bool _minimalScan, std::string _package);
    ~Tester();
    void test();
};

#endif