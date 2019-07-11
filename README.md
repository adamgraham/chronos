# Chronos
> An iOS utility framework to create different types of timers.

For detailed usage and documentation, please visit the [Chronos Reference](https://adamgraham.github.io/chronos/).

## Requirements

- iOS 10.0+
- Swift 5.0+
- Xcode 10.2+

## Usage

Chronos provides a simple but powerful `Chronos.Timer` class that provides more control and flexibility than the native `Foundation.Timer`. The timer object can be created from the following types:

- `basic` - a generic timer that is controlled manually
- `counter` - a timer that counts to/from a set amount of time at a specific interval
- `delay` - a timer that invokes a single completion event after a set amount of time
- `schedule` - a timer that invokes scheduled events between a start and end period using a frequency pattern 
- `stopwatch` - a timer that runs indefinitely, keeping track of the elapsed time

### Examples

``` swift
Timer()
Timer.Basic()
Timer.Basic(interval: 1.0)
Timer.Basic(interval: 1.0, onTick: { ... })
Timer.Basic(interval: 1.0, onTick: { ... }, onFinish: { ... })

Timer.Counter(count: 3.0, onCount: { ... })
Timer.Counter(count: 3.0, interval: 1.0, onCount: { ... })
Timer.Counter(count: 3.0, interval: 1.0, onCount: { ... }, onFinish: { ... })

Timer.Delay(duration: 10.0, onFinish: { ... })

Timer.Schedule(start: .distantPast, end: .distantFuture, frequency: { ... return true }, onSchedule: { ... })
Timer.Schedule(start: .distantPast, end: .distantFuture, frequency: { ... return true }, onSchedule: { ... }, onFinish: { ... })

Timer.Stopwatch()
Timer.Stopwatch(timeout: 60.0)
Timer.Stopwatch(timeout: 60.0, onTimeout: { ... })
```

## License
```
MIT License

Copyright (c) 2016 Adam Graham

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```
