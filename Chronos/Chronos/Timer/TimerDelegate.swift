//
//  TimerDelegate.swift
//  Chronos
//
//  Created by Adam Graham on 9/23/16.
//  Copyright © 2016 Adam Graham. All rights reserved.
//

/// A type to which timer events can be delegated.
public protocol TimerDelegate: class {

    /// Informs the delegate a timer was started.
    /// - parameter timer: The timer that was started.
    func didStart(timer: Timer)

    /// Informs the delegate a timer was stopped.
    /// - parameter timer: The timer that was stopped.
    func didStop(timer: Timer)

    /// Informs the delegate a timer was reset.
    /// - parameter timer: The timer that was reset.
    func didReset(timer: Timer)

    /// Informs the delegate a timer fired a `tick` event.
    /// - parameter timer: The timer that fired the event.
    /// - parameter event: The event metadata.
    func timer(_ timer: Timer, didTick event: TimerEvent)

    /// Informs the delegate a timer fired a `finish` event.
    /// - parameter timer: The timer that fired the event.
    /// - parameter event: The event metadata.
    func timer(_ timer: Timer, didFinish event: TimerEvent)
    
}
