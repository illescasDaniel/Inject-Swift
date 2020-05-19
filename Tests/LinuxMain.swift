import XCTest

import InjectTests

var tests = [XCTestCaseEntry]()
tests += InjectTests.allTests()
XCTMain(tests)
