//
//  TimerTest.swift
//  ChronosTests
//
//  Created by Adam Graham on 2/28/19.
//  Copyright © 2019 Adam Graham. All rights reserved.
//

import XCTest

@testable import Chronos

class TimerTest: XCTestCase {

    // MARK: Initialization Tests

    func testRequiredInit() {
        let type = TimerType.stopwatch(nil)
        let timer = Chronos.Timer(type)

        switch timer.type {
        case .stopwatch:
            break
        default:
            XCTFail("wrong type")
        }

        XCTAssertNil(timer.interval)
        XCTAssertNil(timer.duration)
        XCTAssertEqual(timer.elapsedTime, 0.0)
        XCTAssertEqual(timer.elapsedTimeSinceLastTick, 0.0)
        XCTAssertEqual(timer.elapsedTimeSinceLastFinish, 0.0)
        XCTAssertNil(timer.timestampOfLastTick)
        XCTAssertNil(timer.timestampOfLastFinish)
        XCTAssertEqual(timer.timesTicked, 0)
        XCTAssertEqual(timer.timesFinished, 0)
        XCTAssertNil(timer.onTick)
        XCTAssertNil(timer.onFinish)
        XCTAssertNil(timer.customShouldTick)
        XCTAssertNil(timer.customShouldTick)
    }

    func testConvenienceInit() {
        let timer = Chronos.Timer()

        switch timer.type {
        case .basic:
            break
        default:
            XCTFail("wrong type")
        }

        XCTAssertEqual(timer.interval, 1.0)
        XCTAssertNil(timer.duration)
        XCTAssertEqual(timer.elapsedTime, 0.0)
        XCTAssertEqual(timer.elapsedTimeSinceLastTick, 0.0)
        XCTAssertEqual(timer.elapsedTimeSinceLastFinish, 0.0)
        XCTAssertNil(timer.timestampOfLastTick)
        XCTAssertNil(timer.timestampOfLastFinish)
        XCTAssertEqual(timer.timesTicked, 0)
        XCTAssertEqual(timer.timesFinished, 0)
        XCTAssertNil(timer.onTick)
        XCTAssertNil(timer.onFinish)
        XCTAssertNil(timer.customShouldTick)
        XCTAssertNil(timer.customShouldTick)
    }

    // MARK: State Control Tests

    func testStart() {
        let timer = Chronos.Timer()
        XCTAssertEqual(timer.state, .new)
        XCTAssertTrue(timer.start())
        XCTAssertEqual(timer.state, .active)
        XCTAssertFalse(timer.start())
        XCTAssertEqual(timer.state, .active)
    }

    func testStop() {
        let timer = Chronos.Timer()
        XCTAssertEqual(timer.state, .new)
        XCTAssertFalse(timer.stop())
        XCTAssertEqual(timer.state, .new)
        XCTAssertTrue(timer.start())
        XCTAssertEqual(timer.state, .active)
        XCTAssertTrue(timer.stop())
        XCTAssertEqual(timer.state, .inactive)
        XCTAssertFalse(timer.stop())
        XCTAssertEqual(timer.state, .inactive)
    }

    func testReset() {
        let timer = Chronos.Timer()
        XCTAssertEqual(timer.state, .new)
        XCTAssertFalse(timer.reset())
        XCTAssertEqual(timer.state, .new)
        XCTAssertTrue(timer.start())
        XCTAssertEqual(timer.state, .active)
        XCTAssertTrue(timer.stop())
        XCTAssertEqual(timer.state, .inactive)
        XCTAssertTrue(timer.reset())
        XCTAssertEqual(timer.state, .new)
        XCTAssertFalse(timer.reset())
        XCTAssertEqual(timer.state, .new)
    }

    // MARK: Timer Event Tests

    func testTick() {
        let timer = Chronos.Timer()
        let tick = expectation(description: "tick")
        timer.onTick = { _ in tick.fulfill() }
        timer.interval = 1.0
        timer.start()
        wait(for: [tick], timeout: 3.0)

        XCTAssertEqual(timer.state, .active)
        XCTAssertGreaterThan(timer.elapsedTime, 0.0)
        XCTAssertEqual(timer.elapsedTimeSinceLastTick, 0.0)
        XCTAssertNotNil(timer.timestampOfLastTick)
        XCTAssertGreaterThan(timer.timesTicked, 0)
    }

    func testFinish() {
        let timer = Chronos.Timer()
        let finish = expectation(description: "finish")
        timer.onFinish = { _ in finish.fulfill() }
        timer.duration = 1.0
        timer.start()
        wait(for: [finish], timeout: 3.0)

        XCTAssertEqual(timer.state, .finished)
        XCTAssertGreaterThan(timer.elapsedTime, 0.0)
        XCTAssertEqual(timer.elapsedTimeSinceLastFinish, 0.0)
        XCTAssertNotNil(timer.timestampOfLastFinish)
        XCTAssertGreaterThan(timer.timesFinished, 0)
    }

}
