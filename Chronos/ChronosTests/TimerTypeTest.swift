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
    private let frequency: Chronos.Timer.Frequency = { _,_,_ in return true }

    func testBasic() {
        let type = TimerType.basic(interval: 1.0, onTick: onTick, onFinish: onFinish)
        let timer = Chronos.Timer(type)

        XCTAssertEqual(timer.interval, 1.0)
        XCTAssertNotNil(timer.onTick)
        XCTAssertNotNil(timer.onFinish)
    }

    func testCounter() {
        let type = TimerType.counter(count: 3.0, interval: 1.0, onCount: onCount, onFinish: onFinish)
        let timer = Chronos.Timer(type)

        XCTAssertEqual(timer.duration, 3.0)
        XCTAssertEqual(timer.interval, 1.0)
        XCTAssertNotNil(timer.onTick)
        XCTAssertNotNil(timer.onFinish)
    }

    func testDelay() {
        let type = TimerType.delay(duration: 10.0, onFinish: onFinish)
        let timer = Chronos.Timer(type)

        XCTAssertEqual(timer.duration, 10.0)
        XCTAssertEqual(timer.interval, 10.0)
        XCTAssertNotNil(timer.onFinish)
    }

    func testSchedule() {
        let type = TimerType.schedule(start: .distantPast, end: .distantFuture, frequency: frequency, onSchedule: onSchedule, onFinish: onFinish)
        let timer = Chronos.Timer(type)

        XCTAssertNotNil(timer.customShouldTick)
        XCTAssertNotNil(timer.customShouldFinish)
        XCTAssertNotNil(timer.onTick)
        XCTAssertNotNil(timer.onFinish)
    }

    func testScheduleShouldTick() {
        var type = TimerType.schedule(start: .distantFuture, end: .distantFuture, frequency: frequency, onSchedule: onSchedule, onFinish: onFinish)
        var timer = Chronos.Timer(type)
        XCTAssertFalse(timer.customShouldTick?(timer) ?? true)

        type = TimerType.schedule(start: .distantPast, end: .distantPast, frequency: frequency, onSchedule: onSchedule, onFinish: onFinish)
        timer = Chronos.Timer(type)
        XCTAssertFalse(timer.customShouldTick?(timer) ?? true)

        type = TimerType.schedule(start: .distantPast, end: .distantFuture, frequency: frequency, onSchedule: onSchedule, onFinish: onFinish)
        timer = Chronos.Timer(type)
        XCTAssertTrue(timer.customShouldTick?(timer) ?? false)
    }

    func testScheduleShouldFinish() {
        var type = TimerType.schedule(start: .distantPast, end: .distantFuture, frequency: frequency, onSchedule: onSchedule, onFinish: onFinish)
        var timer = Chronos.Timer(type)
        XCTAssertFalse(timer.customShouldFinish?(timer) ?? true)

        type = TimerType.schedule(start: .distantFuture, end: .distantFuture, frequency: frequency, onSchedule: onSchedule, onFinish: onFinish)
        timer = Chronos.Timer(type)
        XCTAssertFalse(timer.customShouldFinish?(timer) ?? true)

        type = TimerType.schedule(start: .distantPast, end: .distantPast, frequency: frequency, onSchedule: onSchedule, onFinish: onFinish)
        timer = Chronos.Timer(type)
        XCTAssertTrue(timer.customShouldFinish?(timer) ?? false)
    }

    func testStopwatch() {
        let type = TimerType.stopwatch(timeout: 60.0, onTimeout: onTimeout)
        let timer = Chronos.Timer(type)

        XCTAssertEqual(timer.duration, 60.0)
        XCTAssertNotNil(timer.onFinish)
    }

}
