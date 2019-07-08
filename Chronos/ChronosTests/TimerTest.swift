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

    func testDefaultInit() {
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
        XCTAssertNil(timer.customShouldFinish)
    }

    func testBasicInit() {
        let args = TimerType.Basic()
        let timer = Chronos.Timer(args)

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
        XCTAssertNil(timer.customShouldFinish)
    }

    func testStopwatchInit() {
        let args = TimerType.Stopwatch()
        let timer = Chronos.Timer(args)

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
        XCTAssertNil(timer.customShouldFinish)
    }

    func testCountdownInit() {
        let args = TimerType.Countdown(count: 3.0, onCount: { _ in })
        let timer = Chronos.Timer(args)

        switch timer.type {
        case .countdown:
            break
        default:
            XCTFail("wrong type")
        }

        XCTAssertEqual(timer.interval, 1.0)
        XCTAssertEqual(timer.duration, 3.0)
        XCTAssertEqual(timer.elapsedTime, 0.0)
        XCTAssertEqual(timer.elapsedTimeSinceLastTick, 0.0)
        XCTAssertEqual(timer.elapsedTimeSinceLastFinish, 0.0)
        XCTAssertNil(timer.timestampOfLastTick)
        XCTAssertNil(timer.timestampOfLastFinish)
        XCTAssertEqual(timer.timesTicked, 0)
        XCTAssertEqual(timer.timesFinished, 0)
        XCTAssertNotNil(timer.onTick)
        XCTAssertNil(timer.onFinish)
        XCTAssertNil(timer.customShouldTick)
        XCTAssertNil(timer.customShouldFinish)
    }

    func testCountUpInit() {
        let args = TimerType.CountUp(count: 3.0, onCount: { _ in })
        let timer = Chronos.Timer(args)

        switch timer.type {
        case .countUp:
            break
        default:
            XCTFail("wrong type")
        }

        XCTAssertEqual(timer.interval, 1.0)
        XCTAssertEqual(timer.duration, 3.0)
        XCTAssertEqual(timer.elapsedTime, 0.0)
        XCTAssertEqual(timer.elapsedTimeSinceLastTick, 0.0)
        XCTAssertEqual(timer.elapsedTimeSinceLastFinish, 0.0)
        XCTAssertNil(timer.timestampOfLastTick)
        XCTAssertNil(timer.timestampOfLastFinish)
        XCTAssertEqual(timer.timesTicked, 0)
        XCTAssertEqual(timer.timesFinished, 0)
        XCTAssertNotNil(timer.onTick)
        XCTAssertNil(timer.onFinish)
        XCTAssertNil(timer.customShouldTick)
        XCTAssertNil(timer.customShouldFinish)
    }

    func testDelayInit() {
        let args = TimerType.Delay(delay: 10.0, onFinish: { _ in })
        let timer = Chronos.Timer(args)

        switch timer.type {
        case .delay:
            break
        default:
            XCTFail("wrong type")
        }

        XCTAssertEqual(timer.interval, 10.0)
        XCTAssertEqual(timer.duration, 10.0)
        XCTAssertEqual(timer.elapsedTime, 0.0)
        XCTAssertEqual(timer.elapsedTimeSinceLastTick, 0.0)
        XCTAssertEqual(timer.elapsedTimeSinceLastFinish, 0.0)
        XCTAssertNil(timer.timestampOfLastTick)
        XCTAssertNil(timer.timestampOfLastFinish)
        XCTAssertEqual(timer.timesTicked, 0)
        XCTAssertEqual(timer.timesFinished, 0)
        XCTAssertNil(timer.onTick)
        XCTAssertNotNil(timer.onFinish)
        XCTAssertNil(timer.customShouldTick)
        XCTAssertNil(timer.customShouldFinish)
    }

    func testScheduleInit() {
        let args = TimerType.Schedule(start: .distantPast, end: .distantFuture, frequency: { _,_,_ in return true }, onSchedule: { _ in })
        let timer = Chronos.Timer(args)

        switch timer.type {
        case .schedule:
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
        XCTAssertNotNil(timer.onTick)
        XCTAssertNil(timer.onFinish)
        XCTAssertNotNil(timer.customShouldTick)
        XCTAssertNotNil(timer.customShouldFinish)
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
