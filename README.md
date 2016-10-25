# Chronos
> A Swift iOS Time & Date utility framework by [Adam Graham](http://adamgraham.io).

### Description

Chronos (work in progress) provides utility classes and extensions for handling time and dates. Primarily, the framework provides a simple but powerful `Chronos.Timer` class that provides more control and flexibility than the native iOS `Foundation.Timer`. The timer object can be created from the following supported types:

- `.basic` - a generic timer that is controlled manually
- `.countdown` - a timer that counts down from a set amount of time at a specific interval
- `.countUp` - a timer that counts up to a set amount of time at a specific interval
- `.delay` - a timer that invokes a single completion event after a set amount of time
- `.stopwatch` - a timer that runs indefinitely, keeping track of the elapsed time between lapped intervals
- `.schedule` - a timer that invokes scheduled events at specific dates/times and a given frequency pattern

On top of the timer class, Chronos provides miscellaneous helper extensions for handling common date and time logic. *This section of the framework is still in development. Any suggestions/requests are more than welcome.*

### License
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
