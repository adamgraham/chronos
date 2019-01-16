//
//  TimerEvent.swift
//  Chronos
//
//  Created by Adam Graham on 9/23/16.
//  Copyright © 2016 Adam Graham. All rights reserved.
//

import Foundation

/// The metadata of a timer event.
public struct TimerEvent {

    /// The method signature of a "callback" closure. A callback is invoked each time a timer
    /// event is fired.
    public typealias Callback = (_ event: TimerEvent) -> Void

    /// A type of event that can be fired from a timer.
    public enum EventType {

        /// An event to signal a single interval update.
        case tick
        /// An event to signal the end of interval updates.
        case finish
        
    }

    /// The type of event.
    public let type: EventType
    /// The timestamp at the moment the event was fired.
    public let timestamp: Date
    /// The amount of seconds since the last event of the same type was fired from the timer.
    public let deltaTime: TimeInterval
    /// The total elapsed seconds of the timer that fired the event.
    public let timerLifetime: TimeInterval
    /// The number of times the same event type has been fired by the timer.
    public let timesFired: Int
    
}
