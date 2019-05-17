//
//  Timer.swift
//  Chronos
//
//  Created by Adam Graham on 9/23/16.
//  Copyright © 2016 Adam Graham. All rights reserved.
//

import Foundation

/// A timer that schedules and fires intervaled events.
public class Timer: NSObject {

    // MARK: References

    /// A reference to the object listening to the timer events.
    public weak var delegate: TimerDelegate?

    /// The native timer that invokes "tick" events based on display vsync.
    private lazy var timer: CADisplayLink = {
        let displayLink = CADisplayLink(target: self, selector: #selector(updateTime))
        displayLink.add(to: .main, forMode: RunLoop.Mode.default)
        return displayLink
    }()

    // MARK: State & Type Properties

    /// The state of the timer.
    public private(set) var state = TimerState.new

    /// The type of timer.
    public let type: TimerType

    // MARK: Time Behavior Properties

    /// The amount of seconds the timer will run before firing a "tick" event. A nil value will
    /// prevent these events from being fired, if not necessary. The timer will still run if not set.
    public var interval: TimeInterval?

    /// The amount of seconds the timer will run before firing a "finish" event. A nil value will
    /// prevent these events from being fired, if not necessary. The timer will run indefinitely if
    /// not set.
    public var duration: TimeInterval?

    // MARK: Time Data Properties

    /// The total amount of seconds the timer has been running.
    ///
    /// This value is only set back to zero when the timer is restarted or reset.
    public private(set) var elapsedTime: TimeInterval = 0.0

    /// The amount of seconds the timer has been running since the last `tick` event was fired.
    public private(set) var elapsedTimeSinceLastTick: TimeInterval = 0.0

    /// The amount of seconds the timer has been running since the last `finish` event was fired.
    public private(set) var elapsedTimeSinceLastFinish: TimeInterval = 0.0

    /// The timestamp of the last `tick` event, used to calculate the delta time between events.
    public private(set) var timestampOfLastTick: Date?

    /// The timestamp of the last `finish` event, used to calculate the delta time between events.
    public private(set) var timestampOfLastFinish: Date?

    /// The amount of times the timer has fired a `tick` event.
    ///
    /// This value is only set back to zero when the timer is reset.
    public private(set) var timesTicked: Int = 0

    /// The amount of times the timer has fired a `finish` event.
    ///
    /// This value is only set back to zero when the timer is reset.
    public private(set) var timesFinished: Int = 0

    // MARK: Event Properties

    /// The callback closure invoked each time a `tick` event is fired.
    public var onTick: TimerEvent.Callback?

    /// The callback closure invoked each time a `finish` event is fired.
    public var onFinish: TimerEvent.Callback?

    /// A custom closure to ask if the timer should fire a `tick` event.
    internal var customShouldTick: ((Timer) -> Bool)?

    /// A custom closure to ask if the timer should fire a `finish` event.
    internal var customShouldFinish: ((Timer) -> Bool)?

    // MARK: Initialization

    /// Creates a timer of a given type.
    /// - parameter type: The type of timer to create.
    public required init(type: TimerType) {
        self.type = type
        super.init()
        type.args.apply(to: self)
    }

    /// Creates a `basic` timer.
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

    /// Starts the timer, allowing events to be fired and elapsed time to be tracked.
    /// - returns: `true` if the timer was successfully started.
    @discardableResult public func start() -> Bool {
        guard self.state.canStart else {
            return false
        }

        self.state = .active
        self.timer.isPaused = false
        self.delegate?.didStart(timer: self)

        return true
    }

    /// Stops the timer, preventing events from firing and pausing the elapsed time.
    /// - returns: `true` if the timer was successfully stopped.
    @discardableResult public func stop() -> Bool {
        guard self.state.canStop else {
            return false
        }

        self.state = .inactive
        self.timer.isPaused = true
        self.delegate?.didStop(timer: self)

        return true
    }

    /// Resets the timer to a new state, setting all data properties back to zero, e.g., elapsed
    /// time, event counters, etc. The timer will need to be started again before new events are
    /// fired and data is gathered.
    /// - returns: `true` if the timer was successfully reset.
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
        }
        return false
    }

    private static func shouldFinish(_ timer: Timer) -> Bool {
        if let duration = timer.duration, timer.elapsedTimeSinceLastFinish >= duration {
            return true
        }
        return false
    }

    private func tick(at timestamp: Date) {
        self.timestampOfLastTick = timestamp
        self.timesTicked += 1

        let event = TimerEvent(type: .tick,
                               timestamp: timestamp,
                               deltaTime: self.elapsedTimeSinceLastTick,
                               timerLifetime: self.elapsedTime,
                               timesFired: self.timesTicked)

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
                               timesFired: self.timesFinished)

        self.delegate?.timer(self, didFinish: event)
        self.onFinish?(event)

        self.elapsedTimeSinceLastFinish = 0.0
    }

}
