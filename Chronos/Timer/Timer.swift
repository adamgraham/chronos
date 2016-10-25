//
//  Timer.swift
//  Chronos
//
//  Created by Adam Graham on 9/23/16.
//  Copyright © 2016 Adam Graham. All rights reserved.
//

/// A class to create a timer object that fires callback events at specific 
/// time intervals and durations. Timers are based in seconds.
public class Timer: NSObject {

    // MARK: Static Properties

    /// The default rate at which every timer will update. For example, a frame 
    /// rate of 30 means the timer will update 30 times per second. The higher 
    /// the number, the more precise the timer will be but at a higher 
    /// computational cost.
    static var defaultFrameRate: Foundation.TimeInterval = 30.0

    // MARK: References

    /// A weak reference to the delegate assigned to `self`.
    weak public var delegate: TimerDelegate?

    /// The native timer object that invokes scheduled intervals.
    fileprivate lazy var timer: Foundation.Timer = {
        return self.createNativeTimer()
    }()

    // MARK: State & Type Properties

    /// The current state of `self`.
    public fileprivate(set) var state = TimerState.new

    /// The type of timer of `self`.
    public let type: TimerType

    // MARK: Time Behavior Properties

    /// The rate at which `self` will update. For example, a frame rate of 30 
    /// means the timer will update 30 times per second. The higher the 
    /// number, the more precise the timer will be but at a higher computational 
    /// cost.
    public var frameRate: Foundation.TimeInterval = Timer.defaultFrameRate {
        didSet {
            recreateNativeTimer()
        }
    }

    /// An optional amount of time, in seconds, `self` will run before triggering a
    /// "tick" interval event. A nil value will invoke tick events at a fixed default 
    /// rate - see `Timer.defaultFrameRate` for more information.
    public var interval: Foundation.TimeInterval?

    /// An optional amount of time, in seconds, `self` will run before triggering a
    /// "finish" event. A nil value will run `self` indefinitely with no finish events 
    /// being invoked.
    public var duration: Foundation.TimeInterval?

    // MARK: Time Data Properties

    /// The amount of time, in seconds, `self` has been actively running. 
    ///
    /// **Note:** this value only gets set back to zero if `self` is restarted or reset.
    public fileprivate(set) var elapsedTime: Foundation.TimeInterval = 0.0

    /// The amount of time, in seconds, `self` has been actively running since 
    /// the last "tick" interval event.
    public fileprivate(set) var elapsedTimeSinceLastTick: Foundation.TimeInterval = 0.0

    /// The amount of time, in seconds, `self` has been actively running since
    /// the last "finish" event.
    public fileprivate(set) var elapsedTimeSinceLastFinish: Foundation.TimeInterval = 0.0

    /// The timestamp of the last "tick" interval event. 
    /// Used to calculate the delta time between events.
    public fileprivate(set) var timestampOfLastTick: Foundation.Date?

    /// The timestamp of the last "finish" event. 
    /// Used to calculate the delta time between events.
    public fileprivate(set) var timestampOfLastFinish: Foundation.Date?

    /// The amount of times `self` has triggered a "tick" interval event.
    ///
    /// **Note:** this value only gets set back to zero when `self` is reset. If `self` is
    /// started, stopped, or restarted, the value remains the same.
    public fileprivate(set) var timesTicked: Swift.Int = 0

    /// The amount of times `self` has triggered a "finish" event.
    ///
    /// **Note:** this value only gets set back to zero when `self` is reset. If `self` is
    /// started, stopped, or restarted, the value remains the same.
    public fileprivate(set) var timesFinished: Swift.Int = 0

    // MARK: Event Properties

    /// A callback closure invoked every time `self` triggers a "tick" interval event.
    public var onTick: TimerEvent.Callback?

    /// A callback closure invoked every time `self` triggers a "finish" event.
    public var onFinish: TimerEvent.Callback?

    // MARK: Initialization

    /**
     A required initializer to create a `Timer` of a given type.
       - Parameter type: The type of timer to create
     */
    public required init(type: TimerType) {
        self.type = type
        super.init()
        type.applyArgs(to: self)
    }

    /**
     A convenience initializer to create a basic `Timer`.
     */
    public convenience override init() {
        self.init(type: .basic(args: nil))
    }

    // MARK: Deinitialization

    deinit {
        self.timer.invalidate()
    }

    // MARK: Native Timer Creation

    /**
     A helper method to create and return a `Foundation.Timer` that
     updates based on `self.frameRate`.
     */
    private func createNativeTimer() -> Foundation.Timer {
        return Foundation.Timer.scheduledTimer(
            timeInterval: 1.0 / self.frameRate,
            target: self,
            selector: #selector(updateTime),
            userInfo: nil,
            repeats: true
        )
    }

    /**
     A helper method to invalidate the existing timer and create and assign a
     new one.
     */
    fileprivate func recreateNativeTimer() {
        self.timer.invalidate()
        self.timer = createNativeTimer()
    }

}

// MARK: - State Control

extension Timer {

    /**
     A method to set `self` as active, allowing timer events to be fired.
     
     - Returns: `true` if `self` is successfully started.
     */
    @discardableResult public func start() -> Swift.Bool {
        guard self.state.canStart else {
            return false
        }

        self.state = .active
        self.timestampOfLastTick = Foundation.Date()
        self.delegate?.didStart(timer: self)

        return true
    }

    /**
     A method to set `self` as inactive, preventing timer events from firing.
     
     - Returns: `true` if `self` is successfully stopped.
     */
    @discardableResult public func stop() -> Swift.Bool {
        guard self.state.canStop else {
            return false
        }

        self.state = .inactive
        self.delegate?.didStop(timer: self)

        return true
    }

    /**
     A method to start `self` with an elapsed time of zero.
     See also the method `self.start()`.

     - Returns: `true` if `self` is successfully restarted.
     */
    @discardableResult public func restart() -> Swift.Bool {
        guard self.state.canRestart else {
            return false
        }

        self.elapsedTime = 0.0
        self.delegate?.didRestart(timer: self)

        start()

        return true
    }

    /**
     A method to reset `self`, invalidating the timer and setting all properties 
     back to their default values.
     
     - Returns: `true` if `self` is successfully reset.
     */
    @discardableResult public func reset() -> Swift.Bool {
        guard self.state.canReset else {
            return false
        }

        self.state = .new
        self.interval = nil
        self.duration = nil
        self.elapsedTime = 0.0
        self.elapsedTimeSinceLastTick = 0.0
        self.elapsedTimeSinceLastFinish = 0.0
        self.timestampOfLastTick = nil
        self.timestampOfLastFinish = nil
        self.timesTicked = 0
        self.timesFinished = 0

        recreateNativeTimer()

        self.delegate?.didReset(timer: self)
        
        return true
    }

}

// MARK: - Timer Events

extension Timer {

    /**
     A method to update the elapsed time of `self` by the delta time of the
     previous invocation of this method. 
     
     If the elapsed time is greater than or equal to `self.interval`, a "tick" 
     interval event is fired. If the elapsed time is greater than or equal to 
     `self.duration`, a "finish" event is fired.
     */
    @objc fileprivate func updateTime() {
        let timestamp = Foundation.Date()
        let deltaTime = timestamp.timeIntervalSince(self.timestampOfLastTick ?? timestamp)

        self.elapsedTime += deltaTime
        self.elapsedTimeSinceLastTick += deltaTime
        self.elapsedTimeSinceLastFinish += deltaTime

        let interval = self.interval ?? 0.0
        if self.elapsedTimeSinceLastTick >= interval {
            tick(at: timestamp)
        }

        if let duration = self.duration, self.elapsedTimeSinceLastFinish >= duration {
            finish(at: timestamp)
        }
    }

    /**
     A method to fire a "tick" interval event.

     - Parameters:
        - timestamp: The time at which the event is fired.
     */
    fileprivate func tick(at timestamp: Foundation.Date) {
        guard self.state.canTick else {
            return
        }

        self.timestampOfLastTick = timestamp
        self.timesTicked += 1

        let event = TimerEvent(type: .tick,
                               timestamp: timestamp,
                               deltaTime: self.elapsedTimeSinceLastTick,
                               timerLifetime: self.elapsedTime,
                               timesTriggered: self.timesTicked)

        self.delegate?.didTick(event, timer: self)
        self.onTick?(event)

        self.elapsedTimeSinceLastTick = 0.0
    }

    /**
     A method to fire a "finish" event.
     
     - Parameters:
        - timestamp: The time at which the event is fired.
     */
    fileprivate func finish(at timestamp: Foundation.Date) {
        guard self.state.canFinish else {
            return
        }

        stop()

        self.state = .finished
        self.timestampOfLastFinish = timestamp
        self.timesFinished += 1

        let event = TimerEvent(type: .finish,
                               timestamp: timestamp,
                               deltaTime: self.elapsedTimeSinceLastFinish,
                               timerLifetime: self.elapsedTime,
                               timesTriggered: self.timesFinished)

        self.delegate?.didFinish(event, timer: self)
        self.onFinish?(event)

        self.elapsedTimeSinceLastFinish = 0.0
    }

}
