import 'dart:collection';
import '../models/price_entry.dart';
import '../interfaces/moving_average_service_interface.dart';

/* Service to maintain a real-time moving average of prices for each symbol over a 30-second window.
 Efficient for high-frequency updates and memory usage. 
 Each symbol uses a queue to store recent prices and a running sum for O(1) moving average calculation. 
 Old data is automatically expired. */

class MovingAverageServiceImpl implements MovingAverageService {
  static const Duration window = Duration(seconds: 30);
  final Map<String, Queue<PriceEntry>> _symbolQueues = {};
  final Map<String, double> _symbolSums = {};

  /* Add a new price update for a symbol at a given timestamp.
  [symbol]: The symbol (e.g., 'AAPL').
  [price]: The price value.
  [timestamp]: The time the price was received. */

  @override
  void addPrice(String symbol, double price, DateTime timestamp) {
    final queue = _symbolQueues.putIfAbsent(symbol, () => Queue<PriceEntry>());
    _symbolSums.putIfAbsent(symbol, () => 0.0);
    // Remove expired entries
    _removeOldEntries(symbol, timestamp);
    queue.addLast(PriceEntry(price, timestamp));
    _symbolSums[symbol] = _symbolSums[symbol]! + price;
  }

  /* Get the moving average for a symbol over the last 30 seconds.
   [symbol]: The symbol to query.
   [now]: The reference time for the moving window (defaults to current time).
   Returns 0.0 if no valid data exists. */

  @override
  double getMovingAverage(String symbol, {DateTime? now}) {
    final queue = _symbolQueues[symbol];
    if (queue == null || queue.isEmpty) return 0.0;
    final currentTime = now ?? DateTime.now();
    _removeOldEntries(symbol, currentTime);
    if (queue.isEmpty) return 0.0;
    return _symbolSums[symbol]! / queue.length;
  }

  /* Remove all price entries for [symbol] that are older than the 30-second window.
   Updates the running sum accordingly. */

  void _removeOldEntries(String symbol, DateTime now) {
    final queue = _symbolQueues[symbol];
    if (queue == null || queue.isEmpty) return;
    while (queue.isNotEmpty && now.difference(queue.first.timestamp) > window) {
      final expired = queue.removeFirst();
      _symbolSums[symbol] = _symbolSums[symbol]! - expired.price;
    }
    if (queue.isEmpty) {
      _symbolSums[symbol] = 0.0;
    }
  }
}
