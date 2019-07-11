//
//  TimerType.swift
//  Chronos
//
//  Created by Adam Graham on 9/27/16.
//  Copyright © 2016 Adam Graham. All rights reserved.
//

import Foundation

/// A type of timer.
public enum TimerType {

    /// A generic timer that is controlled manually.
    /// - `interval`: The amount of seconds between each `tick` event.
    /// - `onTick`: The callback closure invoked each time the timer fires a `tick` event.
    /// - `onFinish`: The callback closure invoked each time the timer fires a `finish` event.
    case basic(interval: TimeInterval?, onTick: TimerEvent.Callback?, onFinish: TimerEvent.Callback?)

    /// A timer that counts to/from a set amount of time at a specific interval
    /// (often a one second interval, e.g., "3, 2, 1, Go!").
    /// - `count`: The amount of seconds to/from which the timer counts.
    /// - `interval`: The amount of seconds between each count interval.
    /// - `onCount`: The callback closure invoked every count interval.
    /// - `onFinish`: The callback closure invoked when the count is finished.
    case counter(count: TimeInterval, interval: TimeInterval, onCount: TimerEvent.Callback, onFinish: TimerEvent.Callback?)

    /// A timer that invokes a single `finish` event after a set amount of time.
    /// - `delay`: The amount of seconds the timer waits before finishing.
    /// - `onFinish`: The callback closure invoked after the delay is finished.
    case delay(duration: TimeInterval, onFinish: TimerEvent.Callback)

    /// A timer that invokes scheduled events with a frequency pattern between a start and
    /// end period.
    /// - `start`: The timestamp after which the timer starts firing events.
    /// - `end`: The timestamp after which the timer stops firing events.
    /// - `frequency`: The frequency pattern in which timer events are fired.
    /// - `onSchedule`: The callback closure invoked along the frequency pattern.
    /// - `onFinish`: The callback closure invoked after all scheduled events are finished.
    case schedule(start: Date, end: Date, frequency: Timer.Frequency, onSchedule: TimerEvent.Callback, onFinish: TimerEvent.Callback?)

    /// A timer that runs indefinitely, keeping track of the elapsed time.
    /// - `timeout`: The maximum time the stopwatch is allowed to run.
    /// - `onTimeout`: The callback closure invoked after the stopwatch times out.
    case stopwatch(timeout: TimeInterval?, onTimeout: TimerEvent.Callback?)

}

internal extension TimerType {

    /// Applies the associated values of the timer type to a timer object.
    /// - parameter timer: The timer to which the values are applied.
    func apply(to timer: Timer) {
        switch self {
        case let .basic(interval, onTick, onFinish):
            timer.interval = interval
            timer.onTick = onTick
            timer.onFinish = onFinish
        case let .counter(count, interval, onCount, onFinish):
            timer.duration = count
            timer.interval = interval
            timer.onTick = onCount
            timer.onFinish = onFinish
        case let .delay(duration, onFinish):
            timer.duration = duration
            timer.interval = duration
            timer.onFinish = onFinish
        case let .schedule(start, end, frequency, onSchedule, onFinish):
            timer.customShouldTick = shouldTick(start, end, frequency)
            timer.customShouldFinish = shouldFinish(end)
            timer.onTick = onSchedule
            timer.onFinish = onFinish
        case let .stopwatch(timeout, onTimeout):
            timer.duration = timeout
            timer.onFinish = onTimeout
        }
    }

    /// Informs the timer if it should fire a `tick` based on the current timestamp.
    private func shouldTick(_ start: Date, _ end: Date, _ frequency: @escaping Timer.Frequency) -> ((Timer) -> Bool) {
        return { _ in
            let current = Date()

            guard current >= start else { return false }
            guard current < end else { return false }

            return frequency(current, start, end)
        }
    }

    /// Informs the timer if it should fire a `finish` based on the current timestamp.
    private func shouldFinish(_ end: Date) -> ((Timer) -> Bool) {
        return { _ in
            Date() >= end
        }
    }

}
