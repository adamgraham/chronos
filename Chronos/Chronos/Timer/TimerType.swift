//
//  TimerType.swift
//  Chronos
//
//  Created by Adam Graham on 9/27/16.
//  Copyright © 2016 Adam Graham. All rights reserved.
//

/// An enum to describe a type of timer. 
public enum TimerType {

    // MARK: Basic

    /// A case to denote a generic timer that is controlled manually.
    case basic(args: TimerType.Basic?)

    /// A struct to represent the arguments of a `basic` timer.
    public struct Basic: TimerArgs {

        /// The amount of time, in seconds, between each "tick" interval event.
        public var interval: CFTimeInterval = 1.0
        /// A callback closure invoked every time the timer triggers a "tick" interval event.
        public var onTick: TimerEvent.Callback? = nil
        /// A callback closure invoked every time the timer triggers a "finish" event.
        public var onFinish: TimerEvent.Callback? = nil

        internal func apply(to timer: Timer) {
            timer.interval = self.interval
            timer.onTick = self.onTick
            timer.onFinish = self.onFinish
        }

    }

    // MARK: Stopwatch

    /// A case to denote a timer that runs indefinitely, keeping track of the
    /// elapsed time.
    case stopwatch(args: TimerType.Stopwatch?)

    /// A struct to represent the arguments of a `TimerType.stopwatch` timer.
    public struct Stopwatch: TimerArgs {

        /// The maximum time allowed for which the stopwatch can run.
        public var timeout: CFTimeInterval? = nil
        /// A callback closure invoked after the stopwatch times out.
        public var onTimeout: TimerEvent.Callback? = nil

        internal func apply(to timer: Timer) {
            timer.duration = self.timeout
            timer.onFinish = self.onTimeout
        }

    }

    // MARK: Countdown

    /// A case to denote a timer that counts down from a set amount of time at
    /// a specific interval (often a 1 second interval e.g. "3, 2, 1, Go!").
    case countdown(args: TimerType.Countdown)

    /// A struct to represent the arguments of a `TimerType.countdown` timer.
    public struct Countdown: TimerArgs {

        /// The amount of time, in seconds, from which the timer counts down.
        public var count: CFTimeInterval
        /// The amount of time, in seconds, between each count interval.
        public var interval: CFTimeInterval = 1.0
        /// A callback closure invoked every count interval.
        public var onCount: TimerEvent.Callback
        /// A callback closure invoked when the countdown is finished.
        public var onFinish: TimerEvent.Callback?

        internal func apply(to timer: Timer) {
            timer.duration = self.count
            timer.interval = self.interval
            timer.onTick = self.onCount
            timer.onFinish = self.onFinish
        }

    }

    // MARK: Count Up

    /// A case to denote a timer that counts up to a set amount of time at
    /// a specific interval (often a 1 second interval e.g. "1, 2, 3, Go!").
    case countUp(args: TimerType.CountUp)

    /// A struct to represent the arguments of a `TimerType.countUp` timer.
    public struct CountUp: TimerArgs {

        /// The amount of time, in seconds, to which the timer counts up.
        public var count: CFTimeInterval
        /// The amount of time, in seconds, between each count interval.
        public var interval: CFTimeInterval = 1.0
        /// A callback closure invoked every count interval.
        public var onCount: TimerEvent.Callback
        /// A callback closure invoked when the count up is finished.
        public var onFinish: TimerEvent.Callback?

        internal func apply(to timer: Timer) {
            timer.duration = self.count
            timer.interval = self.interval
            timer.onTick = self.onCount
            timer.onFinish = self.onFinish
        }

    }

    // MARK: Delay

    /// A case to denote a timer that invokes a single "finish" event after a set
    /// amount of time.
    case delay(args: TimerType.Delay)

    /// A struct to represent the arguments of a `TimerType.delay` timer.
    public struct Delay: TimerArgs {

        /// The amount of time, in seconds, the timer waits before finishing.
        public var delay: CFTimeInterval
        /// A callback closure invoked after the delay is finished.
        public var onFinish: TimerEvent.Callback

        internal func apply(to timer: Timer) {
            timer.duration = self.delay
            timer.interval = self.delay
            timer.onFinish = self.onFinish
        }

    }

    // MARK: Schedule

    /// A case to denote a timer that invokes scheduled events with a given
    /// frequency pattern between a start and end date/time.
    case schedule(args: TimerType.Schedule)

    /// A struct to represent the arguments of a `TimerType.schedule` timer.
    public struct Schedule: TimerArgs {

        /// A typealias to represent a frequency pattern that returns `true` if the
        /// current date/time contains an event.
        public typealias Frequency = (_ current: Date, _ start: Date, _ end: Date) -> Bool

        /// The date/time after which the timer starts firing events.
        public var start: Date
        /// The date/time after which the timer stops firing events.
        public var end: Date
        /// The frequency pattern in which timer events are fired.
        public var frequency: Frequency
        /// A callback closure invoked along the frequency pattern.
        public var onSchedule: TimerEvent.Callback
        /// A callback closure invoked after all scheduled events are finished.
        public var onFinish: TimerEvent.Callback?
        
        /// A custom behavioral method that tells a timer if it should trigger a
        /// "tick" interval event.
        internal func shouldTick(_ timer: Timer) -> Bool {
            let current = Date()
            guard current >= self.start else {
                return false
            }

            return self.frequency(current, self.start, self.end)
        }

        /// A custom behavioral method that tells a timer if it should trigger a
        /// "finish" event.
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

// MARK: - TimerArgs

internal protocol TimerArgs {

    /**
     An internal helper method to apply the arguments of `self` to a timer.

     - Parameters:
         - timer: The timer to which arguments will be applied.
     */
    func apply(to timer: Timer)

}

internal extension TimerType {

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
