//
//  TimerState.swift
//  Chronos
//
//  Created by Adam Graham on 9/23/16.
//  Copyright © 2016 Adam Graham. All rights reserved.
//

/// The state of a timer.
public enum TimerState {

    /// The state of a timer that is brand new or has just been reset.
    case new
    /// The state of a timer that has been started and is actively running.
    case active
    /// The state of a timer that has been stopped and is not running.
    case inactive
    /// The state of a timer that has reached its duration and is now finished.
    case finished

}

// MARK: - State Machine Helpers

extension TimerState {

    /// Returns `true` if a timer can be started -
    /// must currently be in a `new` or `inactive` state.
    internal var canStart: Bool {
        switch self {
        case .new, .inactive:
            return true
        default:
            return false
        }
    }

    /// Returns `true` if a timer can be stopped -
    /// must currently be in an `active` state.
    internal var canStop: Bool {
        switch self {
        case .active:
            return true
        default:
            return false
        }
    }

    /// Returns `true` if a timer can be reset -
    /// must *not* be in a `new` state.
    internal var canReset: Bool {
        switch self {
        case .new:
            return false
        default:
            return true
        }
    }

}
