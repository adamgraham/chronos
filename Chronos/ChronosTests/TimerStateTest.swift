//
//  TimerStateTest.swift
//  ChronosTests
//
//  Created by Adam Graham on 2/28/19.
//  Copyright © 2019 Adam Graham. All rights reserved.
//

import XCTest

@testable import Chronos

class TimerStateTest: XCTestCase {

    func testNew() {
        XCTAssertTrue(TimerState.new.canStart)
        XCTAssertFalse(TimerState.new.canStop)
        XCTAssertFalse(TimerState.new.canReset)
    }

    func testActive() {
        XCTAssertFalse(TimerState.active.canStart)
        XCTAssertTrue(TimerState.active.canStop)
        XCTAssertTrue(TimerState.active.canReset)
    }

    func testInactive() {
        XCTAssertTrue(TimerState.inactive.canStart)
        XCTAssertFalse(TimerState.inactive.canStop)
        XCTAssertTrue(TimerState.inactive.canReset)
    }

    func testFinished() {
        XCTAssertFalse(TimerState.finished.canStart)
        XCTAssertFalse(TimerState.finished.canStop)
        XCTAssertTrue(TimerState.finished.canReset)
    }

}
