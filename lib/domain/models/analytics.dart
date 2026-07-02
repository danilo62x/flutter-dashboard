/// Share of sales attributed to an acquisition channel.
class ChannelShare {
  const ChannelShare({
    required this.name,
    required this.share,
    required this.iconKey,
  });

  final String name;

  /// Fraction of total sales (0..1).
  final double share;
  final String iconKey;
}

/// A best-selling product with a progress bar relative to the top seller.
class ProductStat {
  const ProductStat({
    required this.name,
    required this.units,
    required this.revenue,
    required this.progress,
  });

  final String name;
  final int units;

  /// Pre-formatted revenue, e.g. `R$ 18,4k`.
  final String revenue;

  /// Normalized bar length (0..1).
  final double progress;
}
