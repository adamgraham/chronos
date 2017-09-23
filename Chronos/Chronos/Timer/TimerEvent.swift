//
//  TimerEvent.swift
//  Chronos
//
//  Created by Adam Graham on 9/23/16.
//  Copyright © 2016 Adam Graham. All rights reserved.
//

/// A struct to contain the data of a timer event.
public struct TimerEvent {

    /// A typealias for a closure invoked upon a timer event.
    public typealias Callback = (_ event: TimerEvent) -> Void

    /// An enum to describe a type of timer event.
    public enum EventType {

        /// A case to denote an event of a timer interval update.
        case tick
        /// A case to denote an event of the end of interval updates of a timer.
        case finish
        
    }

    /// The type of event of `self`.
    let type: TimerEvent.EventType
    /// The time and date that `self` was triggered.
    let timestamp: Date
    /// The amount of time, in seconds, since the last event of the same type of
    /// the timer that triggered `self`.
    let deltaTime: TimeInterval
    /// The elapsed time, in seconds, of the timer that triggered `self`.
    let timerLifetime: TimeInterval
    /// The number of times this same event has been triggered by the timer
    /// that triggered `self`.
    let timesTriggered: Int

    /**
     A helper method to determine if `self` is of a given type.
     
     - Parameters:
        - type: The event type to compare with `self`'s type.
     
     - Returns: `true` if `self` is of the event type `type`.
     */
    public func isOfType(_ type: TimerEvent.EventType) -> Bool {
        return self.type == type
    }
    
}
