//
//  TimerState.swift
//  Chronos
//
//  Created by Adam Graham on 9/23/16.
//  Copyright © 2016 Adam Graham. All rights reserved.
//

/// An enum to describe the state of a timer.
public enum TimerState {

    /// A case to denote a timer is brand new or freshly reset.
    case new
    /// A case to denote a timer is running.
    case active
    /// A case to denote a timer is not running.
    case inactive
    /// A case to denote a timer has finished running.
    case finished

}

// MARK: - State Machine Helpers

extension TimerState {

    /// The ability for a timer to be started, based on the state of `self`.
    /// Returns `true` if `self` is `new` or `inactive`.
    internal var canStart: Bool {
        switch self {
        case .new, .inactive:
            return true
        default:
            return false
        }
    }

    /// The ability for a timer to be stopped, based on the state of `self`.
    /// Returns `true` if `self` is `active`.
    internal var canStop: Bool {
        switch self {
        case .active:
            return true
        default:
            return false
        }
    }

    /// The ability for a timer to be reset, based on the state of `self`.
    /// Always returns `true`.
    internal var canReset: Bool {
        return true
    }

}
