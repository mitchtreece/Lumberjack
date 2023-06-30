![Lumberjack](Assets/Banner.png)

<div align="center">

![Version](https://img.shields.io/badge/Version-1.0.0-FFE8B1.svg?style=for-the-badge&labelColor=FC8A65)
![iOS](https://img.shields.io/badge/iOS-15+-FFE8B1.svg?style=for-the-badge&labelColor=FC8A65)
![Swift](https://img.shields.io/badge/Swift-5-FFE8B1.svg?style=for-the-badge&labelColor=FC8A65)
![Xcode](https://img.shields.io/badge/Xcode-14-FFE8B1.svg?style=for-the-badge&labelColor=FC8A65)

</div>

# Lumberjack

Lightweight Swift logging library 🪵🪓

## Installation

### SPM

The easiest way to get started is by installing via Xcode. Just add Lumberjack as a Swift package & choose the modules you want.

If you're adding Lumberjack as a dependency of your own Swift package, just add a package entry to your dependencies.

```
.package(
    name: "Lumberjack",
    url: "https://github.com/mitchtreece/Lumberjack",
    .upToNextMajor(from: .init(1, 0, 0))
)
```

## Usage

Lumberjack is a lightweight Swift logging library built to help cut (🪓) down on development and (more importantly) debugging time.
Designed with customization & extensibility, Lumberjack can easily be integrated into any project / workflow.

### Get Started

TODO: Working with the default logger

### Global Logging & Configuration

TODO: Lumberjack global settings (i.e. verbosity) & loggers
changing default settings, registering shared loggers, etc

### Loggers

TODO: Creating logger instances, high-level customization,
and logging functions

### Customization

TODO: Detailed logger customization

### Message Hooks

TODO: Message hooks, and the log chain

## Contributing

Pull-requests are more than welcome. Bug fix? Feature? Open a PR and we'll get it merged in! 🎉
