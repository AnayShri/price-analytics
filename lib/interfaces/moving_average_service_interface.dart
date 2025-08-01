abstract class MovingAverageService {
  void addPrice(String symbol, double price, DateTime timestamp);
  double getMovingAverage(String symbol, {DateTime? now});
}
