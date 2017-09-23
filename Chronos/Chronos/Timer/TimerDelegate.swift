//
//  TimerDelegate.swift
//  Chronos
//
//  Created by Adam Graham on 9/23/16.
//  Copyright © 2016 Adam Graham. All rights reserved.
//

/// A protocol to inform a `Timer`'s delegate of state changes and events.
public protocol TimerDelegate: class {

    /**
     A method to inform the delegate a timer was started.
     
     - Parameters:
        - timer: The `Timer` on which the state change occured.
     */
    func didStart(timer: Timer)

    /**
     A method to inform the delegate a timer was stopped.

     - Parameters:
        - timer: The `Timer` on which the state change occured.
     */
    func didStop(timer: Timer)

    /**
     A method to inform the delegate a timer was reset.

     - Parameters:
        - timer: The `Timer` on which the state change occured.
     */
    func didReset(timer: Timer)

    /**
     A method to inform the delegate a timer invoked a "tick" interval event.

     - Parameters:
        - event: The data at the time of the "tick" event invocation.
        - timer: The `Timer` on which the event occured.
     */
    func timer(_ timer: Timer, didTick event: TimerEvent)

    /**
     A method to inform the delegate a timer invoked a "finish" event.

     - Parameters:
        - event: The data at the time of the "finish" event invocation.
        - timer: The `Timer` on which the event occured.
     */
    func timer(_ timer: Timer, didFinish event: TimerEvent)
    
}
