import '../lib/services/moving_average_service.dart';

/// Entry point for running the price analytics demo.
/// Demonstrates adding price data and querying moving averages.
void main() {
  final service = MovingAverageServiceImpl();

  // Sample timestamps
  final t0 = DateTime(2022, 1, 1, 10, 0, 0);
  final t10 = t0.add(Duration(seconds: 10));
  final t35 = t0.add(Duration(seconds: 35));
  final t60 = t0.add(Duration(minutes: 1));
  final t120 = t0.add(Duration(minutes: 2));
  final t180 = t0.add(Duration(minutes: 3));

  // 1. Single Symbol, Within 30s
  service.addPrice('AAPL', 100, t0);
  service.addPrice('AAPL', 104, t10);
  print('AAPL moving average @10:00:10: ' +
      service.getMovingAverage('AAPL', now: t10).toStringAsFixed(2)); // 102.0

  // 2. Single Symbol, Expired Data
  service.addPrice('AAPL', 98, t35);
  print('AAPL moving average @10:00:35: ' +
      service.getMovingAverage('AAPL', now: t35).toStringAsFixed(2)); // 101.0

  // 3. Multiple Symbols
  service.addPrice('AAPL', 110, t60);
  service.addPrice('TSLA', 200, t60);
  print('AAPL moving average @10:01:00: ' +
      service.getMovingAverage('AAPL', now: t60).toStringAsFixed(2)); // 110.0
  print('TSLA moving average @10:01:00: ' +
      service.getMovingAverage('TSLA', now: t60).toStringAsFixed(2)); // 200.0

  // 4. Empty Data
  print('GOOG moving average (no data): ' +
      service.getMovingAverage('GOOG').toStringAsFixed(2)); // 0.0

  // 5. All Data Expired
  service.addPrice('AAPL', 120, t120);
  print('AAPL moving average @10:03:00: ' +
      service.getMovingAverage('AAPL', now: t180).toStringAsFixed(2)); // 0.0

  // 6. High Frequency Updates
  final tBase = DateTime(2022, 1, 1, 10, 5, 0);
  for (int i = 0; i < 30; i++) {
    service.addPrice('AAPL', 100.0 + i, tBase.add(Duration(seconds: i)));
  }
  final expected =
      List.generate(30, (i) => 100.0 + i).reduce((a, b) => a + b) / 30;
  print('AAPL high frequency moving average: ' +
      service
          .getMovingAverage('AAPL', now: tBase.add(Duration(seconds: 29)))
          .toStringAsFixed(2) +
      ' (expected: ' +
      expected.toStringAsFixed(2) +
      ')');
}
