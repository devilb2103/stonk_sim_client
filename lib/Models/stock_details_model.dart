class StockDetails {
  final String companyName;
  final String ticker;
  final String currentPrice;
  final String priceChange;
  final String priceChangeP;
  final String openingPrice;
  final String previousClosingPrice;
  final String volume;
  final String dailyRange;

  StockDetails({
    required this.companyName,
    required this.ticker,
    required this.currentPrice,
    required this.priceChange,
    required this.priceChangeP,
    required this.openingPrice,
    required this.previousClosingPrice,
    required this.volume,
    required this.dailyRange,
  });
}
