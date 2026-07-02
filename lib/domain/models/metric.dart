/// Clean domain model for a dashboard KPI, consumed by the UI layer.
class Metric {
  const Metric({
    required this.label,
    required this.value,
    required this.deltaPercent,
    required this.iconKey,
  });

  final String label;

  /// Pre-formatted display value (e.g. `R$ 48,2k`, `1.284`, `3,4%`).
  final String value;

  /// Signed variation vs. the previous period. Positive means growth.
  final int deltaPercent;

  /// Stable identifier mapped to a Material icon in the UI layer.
  final String iconKey;

  bool get isPositive => deltaPercent >= 0;
}
