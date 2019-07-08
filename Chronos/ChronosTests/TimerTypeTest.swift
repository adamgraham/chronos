//
//  TimerTypeTest.swift
//  ChronosTests
//
//  Created by Adam Graham on 2/28/19.
//  Copyright © 2019 Adam Graham. All rights reserved.
//

import XCTest

@testable import Chronos

class TimerTypeTest: XCTestCase {

    private let onTick: TimerEvent.Callback = { _ in }
    private let onFinish: TimerEvent.Callback = { _ in }
    private let onTimeout: TimerEvent.Callback = { _ in }
    private let onCount: TimerEvent.Callback = { _ in }
    private let onSchedule: TimerEvent.Callback = { _ in }
    private let frequency: TimerType.Schedule.Frequency = { _,_,_ in return true }

    func testBasic() {
        let timer = Chronos.Timer()
        let args = TimerType.Basic(interval: 1.0, onTick: onTick, onFinish: onFinish)
        let type = TimerType.basic(args)
        type.args.apply(to: timer)

        XCTAssertEqual(timer.interval, args.interval)
        XCTAssertNotNil(timer.onTick)
        XCTAssertNotNil(timer.onFinish)
    }

    func testBasicNoArgs() {
        let timer = Chronos.Timer()
        let type = TimerType.basic(nil)
        type.args.apply(to: timer)

        XCTAssertEqual(timer.interval, 1.0)
        XCTAssertNil(timer.onTick)
        XCTAssertNil(timer.onFinish)
    }

    func testStopwatch() {
        let timer = Chronos.Timer()
        let args = TimerType.Stopwatch(timeout: 60.0, onTimeout: onTimeout)
        let type = TimerType.stopwatch(args)
        type.args.apply(to: timer)

        XCTAssertEqual(timer.duration, args.timeout)
        XCTAssertNotNil(timer.onFinish)
    }

    func testStopwatchNoArgs() {
        let timer = Chronos.Timer()
        let type = TimerType.stopwatch(nil)
        type.args.apply(to: timer)

        XCTAssertNil(timer.duration)
        XCTAssertNil(timer.onFinish)
    }

    func testCountdown() {
        let timer = Chronos.Timer()
        let args = TimerType.Countdown(count: 3.0, interval: 1.0, onCount: onCount, onFinish: onFinish)
        let type = TimerType.countdown(args)
        type.args.apply(to: timer)

        XCTAssertEqual(timer.duration, args.count)
        XCTAssertEqual(timer.interval, args.interval)
        XCTAssertNotNil(timer.onTick)
        XCTAssertNotNil(timer.onFinish)
    }

    func testCountUp() {
        let timer = Chronos.Timer()
        let args = TimerType.CountUp(count: 3.0, interval: 1.0, onCount: onCount, onFinish: onFinish)
        let type = TimerType.countUp(args)
        type.args.apply(to: timer)

        XCTAssertEqual(timer.duration, args.count)
        XCTAssertEqual(timer.interval, args.interval)
        XCTAssertNotNil(timer.onTick)
        XCTAssertNotNil(timer.onFinish)
    }

    func testDelay() {
        let timer = Chronos.Timer()
        let args = TimerType.Delay(delay: 30.0, onFinish: onFinish)
        let type = TimerType.delay(args)
        type.args.apply(to: timer)

        XCTAssertEqual(timer.duration, args.delay)
        XCTAssertEqual(timer.interval, args.delay)
        XCTAssertNotNil(timer.onFinish)
    }

    func testSchedule() {
        let timer = Chronos.Timer()
        let args = TimerType.Schedule(start: Date.distantPast, end: Date.distantFuture, frequency: frequency, onSchedule: onSchedule, onFinish: onFinish)
        let type = TimerType.schedule(args)
        type.args.apply(to: timer)

        XCTAssertNotNil(timer.customShouldTick)
        XCTAssertNotNil(timer.customShouldFinish)
        XCTAssertNotNil(timer.onTick)
        XCTAssertNotNil(timer.onFinish)
    }

    func testScheduleShouldTick() {
        let timer = Chronos.Timer()
        var args = TimerType.Schedule(start: Date.distantPast, end: Date.distantFuture, frequency: frequency, onSchedule: onSchedule, onFinish: onFinish)
        let type = TimerType.schedule(args)
        type.args.apply(to: timer)

        args.start = Date.distantFuture
        args.end = Date.distantFuture
        XCTAssertFalse(args.shouldTick(timer))

        args.start = Date.distantPast
        args.end = Date.distantPast
        XCTAssertFalse(args.shouldTick(timer))

        args.start = Date.distantPast
        args.end = Date.distantFuture
        XCTAssertTrue(args.shouldTick(timer))
    }

    func testScheduleShouldFinish() {
        let timer = Chronos.Timer()
        var args = TimerType.Schedule(start: Date.distantPast, end: Date.distantFuture, frequency: frequency, onSchedule: onSchedule, onFinish: onFinish)
        let type = TimerType.schedule(args)
        type.args.apply(to: timer)

        args.start = Date.distantPast
        args.end = Date.distantFuture
        XCTAssertFalse(args.shouldFinish(timer))

        args.start = Date.distantPast
        args.end = Date.distantPast
        XCTAssertTrue(args.shouldFinish(timer))
    }

}
