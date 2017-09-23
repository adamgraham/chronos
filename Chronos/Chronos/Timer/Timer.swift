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

    // MARK: References

    /// A weak reference to the delegate assigned to `self`.
    weak public var delegate: TimerDelegate?

    /// The native timer object that invokes scheduled intervals.
    private lazy var timer: CADisplayLink = {
        let displayLink = CADisplayLink(target: self, selector: #selector(updateTime))
        displayLink.add(to: .main, forMode: .defaultRunLoopMode)
        return displayLink
    }()

    // MARK: State & Type Properties

    /// The current state of `self`.
    public private(set) var state = TimerState.new

    /// The type of timer of `self`.
    public let type: TimerType

    // MARK: Time Behavior Properties

    /// An optional amount of time, in seconds, `self` will run before triggering a
    /// "tick" interval event. A nil value will invoke tick events at a fixed default 
    /// rate - see `Timer.defaultFrameRate` for more information.
    public var interval: CFTimeInterval?

    /// An optional amount of time, in seconds, `self` will run before triggering a
    /// "finish" event. A nil value will run `self` indefinitely with no finish events 
    /// being invoked.
    public var duration: CFTimeInterval?

    /// The arguments passed to `self` upon creation.
    internal var args: TimerArgs?

    // MARK: Time Data Properties

    /// The amount of time, in seconds, `self` has been actively running. 
    ///
    /// **Note:** this value only gets set back to zero if `self` is restarted or reset.
    public private(set) var elapsedTime: CFTimeInterval = 0.0

    /// The amount of time, in seconds, `self` has been actively running since 
    /// the last "tick" interval event.
    public private(set) var elapsedTimeSinceLastTick: CFTimeInterval = 0.0

    /// The amount of time, in seconds, `self` has been actively running since
    /// the last "finish" event.
    public private(set) var elapsedTimeSinceLastFinish: CFTimeInterval = 0.0

    /// The timestamp of the last "tick" interval event. 
    /// Used to calculate the delta time between events.
    public private(set) var timestampOfLastTick: Date?

    /// The timestamp of the last "finish" event. 
    /// Used to calculate the delta time between events.
    public private(set) var timestampOfLastFinish: Date?

    /// The amount of times `self` has triggered a "tick" interval event.
    ///
    /// **Note:** this value only gets set back to zero when `self` is reset. If `self` is
    /// started, stopped, or restarted, the value remains the same.
    public private(set) var timesTicked: Int = 0

    /// The amount of times `self` has triggered a "finish" event.
    ///
    /// **Note:** this value only gets set back to zero when `self` is reset. If `self` is
    /// started, stopped, or restarted, the value remains the same.
    public private(set) var timesFinished: Int = 0

    // MARK: Event Properties

    /// A callback closure invoked every time `self` triggers a "tick" interval event.
    public var onTick: TimerEvent.Callback?

    /// A callback closure invoked every time `self` triggers a "finish" event.
    public var onFinish: TimerEvent.Callback?

    /// A custom closure used to ask if the timer should trigger a "tick" interval event.
    internal var customShouldTick: ((Timer) -> Bool)?

    /// A custom closure used to ask if the timer should trigger a "finish" event.
    internal var customShouldFinish: ((Timer) -> Bool)?

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

}

// MARK: - State Control

extension Timer {

    /**
     A method to set `self` as active, allowing timer events to be fired.

     - Returns: `true` if `self` is successfully started.
     */
    @discardableResult public func start() -> Bool {
        guard self.state.canStart else {
            return false
        }

        self.state = .active
        self.timer.isPaused = false
        self.delegate?.didStart(timer: self)

        return true
    }

    /**
     A method to set `self` as inactive, preventing timer events from firing.
     
     - Returns: `true` if `self` is successfully stopped.
     */
    @discardableResult public func stop() -> Bool {
        guard self.state.canStop else {
            return false
        }

        self.state = .inactive
        self.timer.isPaused = true
        self.delegate?.didStop(timer: self)

        return true
    }

    /**
     A method to reset `self`, invalidating the timer and setting all properties 
     back to their default values.
     
     - Returns: `true` if `self` is successfully reset.
     */
    @discardableResult public func reset() -> Bool {
        guard self.state.canReset else {
            return false
        }

        self.state = .new
        self.elapsedTime = 0.0
        self.elapsedTimeSinceLastTick = 0.0
        self.elapsedTimeSinceLastFinish = 0.0
        self.timestampOfLastTick = nil
        self.timestampOfLastFinish = nil
        self.timesTicked = 0
        self.timesFinished = 0
        self.timer.isPaused = true

        self.delegate?.didReset(timer: self)
        
        return true
    }

}

// MARK: - Timer Events

extension Timer {

    @objc private func updateTime(displaylink: CADisplayLink) {
        let timestamp = Date()
        let deltaTime = displaylink.targetTimestamp - displaylink.timestamp

        self.elapsedTime += deltaTime
        self.elapsedTimeSinceLastTick += deltaTime
        self.elapsedTimeSinceLastFinish += deltaTime

        if (self.customShouldTick ?? Timer.shouldTick)(self) {
            tick(at: timestamp)
        }

        if (self.customShouldTick ?? Timer.shouldFinish)(self) {
            finish(at: timestamp)
        }
    }

    private static func shouldTick(_ timer: Timer) -> Bool {
        if let interval = timer.interval, timer.elapsedTimeSinceLastTick >= interval {
            return true
        } else {
            return false
        }
    }

    private static func shouldFinish(_ timer: Timer) -> Bool {
        if let duration = timer.duration, timer.elapsedTimeSinceLastFinish >= duration {
            return true
        } else {
            return false
        }
    }

    private func tick(at timestamp: Date) {
        self.timestampOfLastTick = timestamp
        self.timesTicked += 1

        let event = TimerEvent(type: .tick,
                               timestamp: timestamp,
                               deltaTime: self.elapsedTimeSinceLastTick,
                               timerLifetime: self.elapsedTime,
                               timesTriggered: self.timesTicked)

        self.delegate?.timer(self, didTick: event)
        self.onTick?(event)

        self.elapsedTimeSinceLastTick = 0.0
    }

    private func finish(at timestamp: Date) {
        stop()

        self.state = .finished
        self.timer.isPaused = true
        self.timestampOfLastFinish = timestamp
        self.timesFinished += 1

        let event = TimerEvent(type: .finish,
                               timestamp: timestamp,
                               deltaTime: self.elapsedTimeSinceLastFinish,
                               timerLifetime: self.elapsedTime,
                               timesTriggered: self.timesFinished)

        self.delegate?.timer(self, didFinish: event)
        self.onFinish?(event)

        self.elapsedTimeSinceLastFinish = 0.0
    }

}
