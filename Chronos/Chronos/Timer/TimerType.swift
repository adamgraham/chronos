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
    case basic(args: TimerType.Basic.Args?)

    /// A namespace class to represent a `TimerType.basic` timer.
    public class Basic {

        // Prevent instantiation
        private init() {}

        /// A struct to represent the arguments of a `TimerType.basic` timer.
        public struct Args: TimerArgs {

            /// A callback closure invoked every time the timer triggers a "tick" interval event.
            public var onTick: TimerEvent.Callback?
            /// A callback closure invoked every time the timer triggers a "finish" event.
            public var onFinish: TimerEvent.Callback?
            
        }

    }

    // MARK: Countdown

    /// A case to denote a timer that counts down from a set amount of time at
    /// a specific interval (often a 1 second interval e.g. "3, 2, 1, Go!").
    case countdown(args: TimerType.Countdown.Args)

    /// A namespace class to represent a `TimerType.countdown` timer.
    public class Countdown {

        // Prevent instantiation
        private init() {}

        /// A struct to represent the arguments of a `TimerType.countdown` timer.
        public struct Args: TimerArgs {

            /// The amount of time, in seconds, from which the timer counts down.
            public var count: CFTimeInterval
            /// The amount of time, in seconds, between each count interval.
            public var interval: CFTimeInterval = 1.0
            /// A callback closure invoked every count interval.
            public var onCount: TimerEvent.Callback
            /// A callback closure invoked when the countdown is finished.
            public var onFinish: TimerEvent.Callback?

        }

    }

    // MARK: Count Up

    /// A case to denote a timer that counts up to a set amount of time at
    /// a specific interval (often a 1 second interval e.g. "1, 2, 3, Go!").
    case countUp(args: TimerType.CountUp.Args)

    /// A namespace class to represent a `TimerType.countUp` timer.
    public class CountUp {

        // Prevent instantiation
        private init() {}

        /// A struct to represent the arguments of a `TimerType.countUp` timer.
        public struct Args: TimerArgs {

            /// The amount of time, in seconds, to which the timer counts up.
            public var count: CFTimeInterval
            /// The amount of time, in seconds, between each count interval.
            public var interval: CFTimeInterval = 1.0
            /// A callback closure invoked every count interval.
            public var onCount: TimerEvent.Callback
            /// A callback closure invoked when the count up is finished.
            public var onFinish: TimerEvent.Callback?
            
        }
        
    }

    // MARK: Delay

    /// A case to denote a timer that invokes a single "finish" event after a set
    /// amount of time.
    case delay(args: TimerType.Delay.Args)

    /// A namespace class to represent a `TimerType.delay` timer.
    public class Delay {

        // Prevent instantiation
        private init() {}

        /// A struct to represent the arguments of a `TimerType.delay` timer.
        public struct Args: TimerArgs {

            /// The amount of time, in seconds, the timer waits before finishing.
            public var delay: CFTimeInterval
            /// A callback closure invoked after the delay is finished.
            public var onFinish: TimerEvent.Callback
            
        }

    }

    // MARK: Stopwatch

    /// A case to denote a timer that runs indefinitely, keeping track of the
    /// elapsed time between lapped intervals.
    case stopwatch(args: TimerType.Stopwatch.Args)

    /// A namespace class to represent a `TimerType.stopwatch` timer.
    public class Stopwatch {

        // Prevent instantiation
        private init() {}

        /// A struct to represent the arguments of a `TimerType.stopwatch` timer.
        public struct Args: TimerArgs {

            // TODO:
            
        }

    }

    // MARK: Schedule

    /// A case to denote a timer that invokes scheduled events with a given
    /// frequency pattern between a start and end date/time.
    case schedule(args: TimerType.Schedule.Args)

    /// A namespace class to represent a `TimerType.schedule` timer.
    public class Schedule {

        // Prevent instantiation
        private init() {}

        /// A struct to represent the arguments of a `TimerType.schedule` timer.
        public struct Args: TimerArgs {

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

        }

        /// A typealias to represent a frequency pattern that returns `true` if the
        /// current date/time contains an event.
        public typealias Frequency = (_ current: Date, _ start: Date, _ end: Date) -> Bool

        /// A custom behavioral method that tells a timer if it should trigger a
        /// "tick" interval event.
        internal static func shouldTick(_ timer: Timer) -> Bool {
            guard let args = timer.args as? TimerType.Schedule.Args else {
                return false
            }

            let current = Date()
            guard current >= args.start else {
                return false
            }

            return args.frequency(current, args.start, args.end)
        }

        /// A custom behavioral method that tells a timer if it should trigger a
        /// "finish" event.
        internal static func shouldFinish(_ timer: Timer) -> Bool {
            guard let args = timer.args as? TimerType.Schedule.Args else {
                return false
            }

            return Date() >= args.end
        }
        
    }

}

// MARK: - Helpers

extension TimerType {

    /**
     An internal helper method to apply the arguments of `self` to a timer.

     - Parameters:
        - timer: The timer to which arguments will be applied.
     */
    internal func applyArgs(to timer: Timer) {
        switch self {
        case let .basic(args):
            timer.args = args
            timer.onTick = args?.onTick
            timer.onFinish = args?.onFinish

        case let .countdown(args):
            timer.args = args
            timer.duration = args.count
            timer.interval = args.interval
            timer.onTick = args.onCount
            timer.onFinish = args.onFinish

        case let .countUp(args):
            timer.args = args
            timer.duration = args.count
            timer.interval = args.interval
            timer.onTick = args.onCount
            timer.onFinish = args.onFinish

        case let .delay(args):
            timer.args = args
            timer.duration = args.delay
            timer.interval = args.delay
            timer.onFinish = args.onFinish

        case let .stopwatch(args):
            timer.args = args
            // TODO

        case let .schedule(args):
            timer.args = args
            timer.customShouldTick = TimerType.Schedule.shouldTick
            timer.customShouldFinish = TimerType.Schedule.shouldFinish
            timer.onTick = args.onSchedule
            timer.onFinish = args.onFinish
        }
    }

}

// MARK: - TimerArgs

internal protocol TimerArgs {

}
