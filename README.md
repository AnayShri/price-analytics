# Price Analytics

A real-time price analytics component for trading applications, built in Dart. Efficiently maintains a moving average of prices for each symbol over the last 30 seconds, supporting thousands of updates per second.

## Features
- **Real-time**: Processes new price updates immediately.
- **O(1) Moving Average**: Efficient lookup and update for each symbol.
- **Memory Efficient**: Old data is automatically discarded.
- **Testable & SOLID**: Clean, modular, and enterprise-grade code structure.

## Folder Structure
```
lib/
  models/                  # Data models (e.g., PriceEntry)
  services/                # Business logic (MovingAverageService)
  interfaces/              # Service interfaces
bin/
  main.dart                # Demo entry point

test/                      # Unit tests
```

## Usage

### 1. Run the Demo
```sh
dart run bin/main.dart
```

### 2. API
- `addPrice(String symbol, double price, DateTime timestamp)`
- `double getMovingAverage(String symbol, {DateTime? now})`

### 3. Example
See `bin/main.dart` for a full example with sample data and expected outputs.

## Testing
Run all tests:
```sh
dart test
```

## Design Notes
- Each symbol uses a queue to store recent prices and a running sum for O(1) average calculation.
- Old data is expired on each update or query.
- Fully unit tested for all edge cases and requirements.


