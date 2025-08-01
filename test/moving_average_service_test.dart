import 'package:test/test.dart';
import '../lib/services/moving_average_service.dart';

void main() {
  group('MovingAverageService', () {
    final base = DateTime(2025, 1, 1, 10, 0, 0);

    test('Single Symbol, Within 30s', () {
      final service = MovingAverageServiceImpl();
      service.addPrice('AAPL', 100, base);
      service.addPrice('AAPL', 104, base.add(Duration(seconds: 10)));
      expect(
          service.getMovingAverage('AAPL',
              now: base.add(Duration(seconds: 10))),
          102.0);
    });

    test('Single Symbol, Expired Data', () {
      final service = MovingAverageServiceImpl();
      service.addPrice('AAPL', 100, base);
      service.addPrice('AAPL', 104, base.add(Duration(seconds: 10)));
      service.addPrice('AAPL', 98, base.add(Duration(seconds: 35)));
      expect(
          service.getMovingAverage('AAPL',
              now: base.add(Duration(seconds: 35))),
          101.0);
    });

    test('Multiple Symbols', () {
      final service = MovingAverageServiceImpl();
      service.addPrice('AAPL', 110, base.add(Duration(minutes: 1)));
      service.addPrice('TSLA', 200, base.add(Duration(minutes: 1)));
      expect(
          service.getMovingAverage('AAPL', now: base.add(Duration(minutes: 1))),
          110.0);
      expect(
          service.getMovingAverage('TSLA', now: base.add(Duration(minutes: 1))),
          200.0);
    });

    test('Empty Data', () {
      final service = MovingAverageServiceImpl();
      expect(service.getMovingAverage('GOOG'), 0.0);
    });

    test('All Data Expired', () {
      final service = MovingAverageServiceImpl();
      service.addPrice('AAPL', 120, base.add(Duration(minutes: 2)));
      expect(
          service.getMovingAverage('AAPL', now: base.add(Duration(minutes: 3))),
          0.0);
    });

    test('High Frequency Updates', () {
      final service = MovingAverageServiceImpl();
      final symbol = 'AAPL';
      for (int i = 0; i < 30; i++) {
        service.addPrice(symbol, 100.0 + i, base.add(Duration(seconds: i)));
      }
      final expected =
          List.generate(30, (i) => 100.0 + i).reduce((a, b) => a + b) / 30;
      expect(
          service.getMovingAverage(symbol,
              now: base.add(Duration(seconds: 29))),
          expected);
    });
  });
}
