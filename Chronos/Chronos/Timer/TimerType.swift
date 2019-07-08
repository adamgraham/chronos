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
    case basic(_ args: TimerType.Basic?)

    /// The arguments of a `basic` timer.
    public struct Basic: TimerArgs {

        /// The amount of seconds between each `tick` event.
        public var interval: TimeInterval = 1.0
        /// The callback closure invoked each time the timer fires a `tick` event.
        public var onTick: TimerEvent.Callback?
        /// The callback closure invoked each time the timer fires a `finish` event.
        public var onFinish: TimerEvent.Callback?

        /// Initializes the arguments of a `basic` timer.
        /// - parameter interval: The amount of seconds between each `tick` event.
        /// - parameter onTick: The callback closure invoked each time the timer fires a `tick` event.
        /// - parameter onFinish: The callback closure invoked each time the timer fires a `finish` event.
        public init(interval: TimeInterval = 1.0, onTick: TimerEvent.Callback? = nil, onFinish: TimerEvent.Callback? = nil) {
            self.interval = interval
            self.onTick = onTick
            self.onFinish = onFinish
        }

        internal func apply(to timer: Timer) {
            timer.interval = self.interval
            timer.onTick = self.onTick
            timer.onFinish = self.onFinish
        }

    }

    /// A timer that runs indefinitely, keeping track of the elapsed time.
    case stopwatch(_ args: TimerType.Stopwatch?)

    /// The arguments of a `stopwatch` timer.
    public struct Stopwatch: TimerArgs {

        /// The maximum time the stopwatch is allowed to run.
        public var timeout: TimeInterval?
        /// The callback closure invoked after the stopwatch times out.
        public var onTimeout: TimerEvent.Callback?

        /// Initializes the arguments of a `stopwatch` timer.
        /// - parameter timeout: The maximum time the stopwatch is allowed to run.
        /// - parameter onTimeout: The callback closure invoked after the stopwatch times out.
        public init(timeout: TimeInterval? = nil, onTimeout: TimerEvent.Callback? = nil) {
            self.timeout = timeout
            self.onTimeout = onTimeout
        }

        internal func apply(to timer: Timer) {
            timer.duration = self.timeout
            timer.onFinish = self.onTimeout
        }

    }

    /// A timer that counts down from a set amount of time at a specific interval
    /// (often a one second interval, e.g., "3, 2, 1, Go!").
    case countdown(_ args: TimerType.Countdown)

    /// The arguments of a `countdown` timer.
    public struct Countdown: TimerArgs {

        /// The amount of seconds from which the timer counts down.
        public var count: TimeInterval
        /// The amount of seconds between each count interval.
        public var interval: TimeInterval = 1.0
        /// The callback closure invoked every count interval.
        public var onCount: TimerEvent.Callback
        /// The callback closure invoked when the count is finished.
        public var onFinish: TimerEvent.Callback?

        /// Initializes the arguments of a `countdown` timer.
        /// - parameter count: The amount of seconds from which the timer counts down.
        /// - parameter interval: The amount of seconds between each count interval.
        /// - parameter onCount: The callback closure invoked every count interval.
        /// - parameter onFinish: The callback closure invoked when the count is finished.
        public init(count: TimeInterval, interval: TimeInterval = 1.0, onCount: @escaping TimerEvent.Callback, onFinish: TimerEvent.Callback? = nil) {
            self.count = count
            self.interval = interval
            self.onCount = onCount
            self.onFinish = onFinish
        }

        internal func apply(to timer: Timer) {
            timer.duration = self.count
            timer.interval = self.interval
            timer.onTick = self.onCount
            timer.onFinish = self.onFinish
        }

    }

    /// A timer that counts up to a set amount of time at a specific interval
    /// (often a one second interval, e.g., "1, 2, 3, Go!").
    case countUp(_ args: TimerType.CountUp)

    /// The arguments of a `countUp` timer.
    public struct CountUp: TimerArgs {

        /// The amount of seconds to which the timer counts up.
        public var count: TimeInterval
        /// The amount of seconds between each count interval.
        public var interval: TimeInterval = 1.0
        /// The callback closure invoked every count interval.
        public var onCount: TimerEvent.Callback
        /// The callback closure invoked when the count is finished.
        public var onFinish: TimerEvent.Callback?

        /// Initializes the arguments of a `countUp` timer.
        /// - parameter count: The amount of seconds to which the timer counts up.
        /// - parameter interval: The amount of seconds between each count interval.
        /// - parameter onCount: The callback closure invoked every count interval.
        /// - parameter onFinish: The callback closure invoked when the count is finished.
        public init(count: TimeInterval, interval: TimeInterval = 1.0, onCount: @escaping TimerEvent.Callback, onFinish: TimerEvent.Callback? = nil) {
            self.count = count
            self.interval = interval
            self.onCount = onCount
            self.onFinish = onFinish
        }

        internal func apply(to timer: Timer) {
            timer.duration = self.count
            timer.interval = self.interval
            timer.onTick = self.onCount
            timer.onFinish = self.onFinish
        }

    }

    /// A timer that invokes a single `finish` event after a set amount of time.
    case delay(_ args: TimerType.Delay)

    /// The arguments of a `delay` timer.
    public struct Delay: TimerArgs {

        /// The amount of seconds the timer waits before finishing.
        public var delay: TimeInterval
        /// The callback closure invoked after the delay is finished.
        public var onFinish: TimerEvent.Callback

        /// Initializes the arguments of a `delay` timer.
        /// - parameter delay: The amount of seconds the timer waits before finishing.
        /// - parameter onFinish: The callback closure invoked after the delay is finished.
        public init(delay: TimeInterval, onFinish: @escaping TimerEvent.Callback) {
            self.delay = delay
            self.onFinish = onFinish
        }

        internal func apply(to timer: Timer) {
            timer.duration = self.delay
            timer.interval = self.delay
            timer.onFinish = self.onFinish
        }

    }

    /// A timer that invokes scheduled events with a given frequency pattern between a start
    /// and end timestamp.
    case schedule(_ args: TimerType.Schedule)

    /// The arguments of a `schedule` timer.
    public struct Schedule: TimerArgs {

        /// The method definition of a frequency pattern - a method that returns `true` if a given
        /// timestamp between a start and end period contains a scheduled event.
        public typealias Frequency = (_ current: Date, _ start: Date, _ end: Date) -> Bool

        /// The timestamp after which the timer starts firing events.
        public var start: Date
        /// The timestamp after which the timer stops firing events.
        public var end: Date
        /// The frequency pattern in which timer events are fired.
        public var frequency: Frequency
        /// The callback closure invoked along the frequency pattern.
        public var onSchedule: TimerEvent.Callback
        /// The callback closure invoked after all scheduled events are finished.
        public var onFinish: TimerEvent.Callback?

        /// Initializes the arguments of a `delay` timer.
        /// - parameter start: The timestamp after which the timer starts firing events.
        /// - parameter end: The timestamp after which the timer stops firing events.
        /// - parameter frequency: The frequency pattern in which timer events are fired.
        /// - parameter onSchedule: The callback closure invoked along the frequency pattern.
        /// - parameter onFinish: The callback closure invoked after all scheduled events are finished.
        public init(start: Date, end: Date, frequency: @escaping Frequency, onSchedule: @escaping TimerEvent.Callback, onFinish: TimerEvent.Callback? = nil) {
            self.start = start
            self.end = end
            self.frequency = frequency
            self.onSchedule = onSchedule
            self.onFinish = onFinish
        }

        /// Informs the timer if it should fire a `tick` based on the current timestamp.
        /// - parameter timer: The timer that is asking to be informed.
        internal func shouldTick(_ timer: Timer) -> Bool {
            let current = Date()

            guard current >= self.start else { return false }
            guard current < self.end else { return false }

            return self.frequency(current, self.start, self.end)
        }

        /// Informs the timer if it should fire a `finish` based on the current timestamp.
        /// - parameter timer: The timer that is asking to be informed.
        internal func shouldFinish(_ timer: Timer) -> Bool {
            return Date() >= self.end
        }

        internal func apply(to timer: Timer) {
            timer.customShouldTick = self.shouldTick
            timer.customShouldFinish = self.shouldFinish
            timer.onTick = self.onSchedule
            timer.onFinish = self.onFinish
        }

    }

}

// MARK: -

internal protocol TimerArgs {

    /// Applies the arguments to a timer.
    /// - parameter timer: The timer to which the arguments are applied.
    func apply(to timer: Timer)

}

internal extension TimerType {

    /// The arguments associated with the type of timer.
    var args: TimerArgs {
        switch self {
        case .basic(let args):
            return args ?? TimerType.Basic()
        case .stopwatch(let args):
            return args ?? TimerType.Stopwatch()
        case .countdown(let args):
            return args
        case .countUp(let args):
            return args
        case .delay(let args):
            return args
        case .schedule(let args):
            return args
        }
    }

}
