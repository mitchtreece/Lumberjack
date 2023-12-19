![Lumberjack](Assets/Banner.png)

<div align="center">

![Version](https://img.shields.io/badge/Version-1.4.1-FFE8B1.svg?style=for-the-badge&labelColor=FC8A65)
![iOS](https://img.shields.io/badge/iOS-15+-FFE8B1.svg?style=for-the-badge&labelColor=FC8A65)
![Swift](https://img.shields.io/badge/Swift-5-FFE8B1.svg?style=for-the-badge&labelColor=FC8A65)
![Xcode](https://img.shields.io/badge/Xcode-15-FFE8B1.svg?style=for-the-badge&labelColor=FC8A65)

</div>

# Lumberjack

Lightweight Swift logging library 🪵🪓

## Installation

### SPM

The easiest way to get started is by installing via Xcode. Just add Lumberjack as a Swift package & choose the modules you want.

If you're adding Lumberjack as a dependency of your own Swift package, just add a package entry to your dependencies.

```swift
.package(
    name: "Lumberjack",
    url: "https://github.com/mitchtreece/Lumberjack",
    .upToNextMajor(from: .init(1, 0, 0))
)
```

## Usage

Lumberjack is a lightweight Swift logging library built to help cut (🪓) down on development and (more importantly) debugging time.
Designed with customization & extensibility, Lumberjack can easily be integrated into any project / workflow.

### Getting Started

The easiest way to get started with Lumberjack, is by using the default logger. By default, all global logging functions use this target. The following are all equivalent:

```swift
// Global

DEBUG("Hello, world!")

// Logger

Logger
    .default
    .debug("Hello, world!")

// Lumberjack

Lumberjack
    .defaultLogger
    .debug("Hello, world!")

// Result

"⚪️ [DEBUG] 15:06:37.099 Demo.AppDelegate::46 >> Hello, world!"
```

Lumberjack provides several global log-level functions, 
as-well-as equivalent logger instance counterparts:

```swift
LOG(...)    → logger.log(...)
PROXY(...)  → logger.proxy(...)
TRACE(...)  → logger.trace(...)
DEBUG(...)  → logger.debug(...)
INFO(...)   → logger.info(...)
NOTICE(...) → logger.notice(...)
WARN(...)   → logger.warning(...)
ERROR(...)  → logger.error(...)
FATAL(...)  → logger.fatal(...)
```

Each one of these functions optionally takes in several arguments that can override / augment the output of logged messages. More on that later! 🙌🏼

### Global Settings & Configuration

The top-level `Lumberjack` object houses several global settings, as-well-as easy access to the default logger, custom loggers, associated configuration settings, & message publishers.

```swift
Lumberjack
    .verbosityOverride = .just(.error)

Lumberjack
    .defaultLogger
    .configuration
    .timestampFormat = "yyyy-MM-dd"

Lumberjack
    .anyMessagePublisher
    .sink { print($0.body(formatted: false)) }
    .store(in: &self.bag)
```

You're also not limited to just one "default" logger. Custom loggers can also be created:

```swift
let logger = Logger(id: "custom")

logger
    .configuration
    .symbol = .just("😎")

// -- or --

let logger = Logger(id: "custom") { make in
    make.symbol = .just("😎")
}
```

... and globally registered:

```swift
Lumberjack
    .register(logger)

// -- or --

Lumberjack.buildAndRegister(loggerWithId: "custom") { make in
    make.symbol = .just("😎")
}
```

... and accessed:

```swift
let logger = Logger
    .with(id: "custom")

// -- or --

let logger = Lumberjack
    .logger(id: "custom")
```

### Loggers

As shown above, logger instances can be created as-needed. However, sometimes you don't need a logger to be globally registered. For example, you might want a logger tied to a specific view / view-controller in your project.

```swift
import UIKit
import Lumberjack

class CustomViewController: UIViewController {

    private var logger: Logger!

    override func viewDidLoad() {

        super.viewDidLoad()

        self.logger = Logger { make in

            make.verbosity = .full
            make.symbol = .just("📱")
            make.category = "CustomView"
            make.components = .simple

        }

    }

    override func viewWillAppear(_ animated: Bool) {

        super.viewWillAppear(animated)

        self.logger
            .debug("view will appear!")

    }

}
```

#### Customization

Loggers can be customized in several different ways. At their core, they use a component-based system to determine what kind of info gets logged to the console. For example, the default message component set consists of the following:

```swift
[     
    .level(
        .symbol,
        spacing: .trailing(1)
    ),
    .level(
        .name,
        spacing: .trailing(1)
    ),
    .category(spacing: .trailing(1)),
    .timestamp(spacing: .trailing(1)),
    .module(),
    .text("."),
    .file(),
    .text("::"),
    .line(spacing: .trailing(1)),
    .text("➡️"),
    .message(spacing: .leading(1))
]
```

This results in the following format:

```
{symbol} [{level}] <{category}> {timestamp} {module}.{file}::{line} ➡️ {message}
```

... and example message:

```swift
"⚪️ [DEBUG] <Example> 15:06:37.099 Demo.AppDelegate::46 >> Hello, world!"
```

The individual component values are determined based on the logger's configuration, as-well-as any passed in logging function overrides.

```swift
let logger = Logger { make in

    make.symbol = .just("📱")
    make.category = "Example"

}

logger
    .debug("no overrides") 
    
// => "📱 [DEBUG] <Example> 15:06:37.099 Demo.AppDelegate::46 >> no overrides"

logger.info(
    "some overrides", 
    symbol: "⭐️",
    category: "Star"
)

// => "⭐️ [INFO] <Star> 15:06:37.099 Demo.AppDelegate::46 >> some overrides"

```

### Message Hooks

Besides logging to the console, sometimes you might need to do additional work with messages (i.e. uploading to a server, writing to disk, etc) - or prevent them from being logged at all. That's where the message hook system comes into play! A hook that persists messages to disk might look something like this:

```swift
import Lumberjack

struct SaveMessageHook: MessageHook {

    func hook(message: Message, 
              from logger: Logger) -> MessageHookResult {

        save(message)
        return .next

    }

    private func save(_ message: Message) {

        let url = FileManager
            .default
            .urls(
                for: .documentDirectory, 
                in: .userDomainMask
            )
            .first!
            .appendingPathComponent("\(message.id).txt")

        do {

            try message
                .body(formatted: true)
                .write(
                    to: url, 
                    atomically: true, 
                    encoding: .utf8
                )

        }
        catch {
            print("Error writing message to disk: \(error)")
        }

    }

}
```

A message hook simply receives a message, does whatever tasks it needs to with it, then returns a result indicating if the message should be passed on to downstream hooks, or stop and prevent the message from being logged.

Lumberjack's internal logging system is even implemented using a message hook similiar to the following:

```swift
import Lumberjack

struct PrintMessageHook: MessageHook {

    func hook(message: Message, 
              from logger: Logger) -> MessageHookResult {

        if shouldPrint(message) {

            print(message.body(formatted: true))
            return .next

        }

        return .stop

    }

    private func shouldPrint(_ message: Message) -> Bool {
        ...
    }

}
```

## Contributing

Pull-requests are more than welcome. Bug fix? Feature? Open a PR and we'll get it merged in! 🎉
