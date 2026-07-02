/// Clean domain model for a report card with a mini trend series.
class Report {
  const Report({
    required this.title,
    required this.value,
    required this.subtitle,
    required this.deltaPercent,
    required this.iconKey,
    required this.spark,
  });

  final String title;

  /// Pre-formatted display value, e.g. `R$ 128,4k`.
  final String value;
  final String subtitle;

  /// Signed variation vs. the previous period.
  final int deltaPercent;
  final String iconKey;

  /// Normalized sparkline points (0..1).
  final List<double> spark;

  bool get isPositive => deltaPercent >= 0;
}

/// One row of the summary table shown on the reports screen.
class ReportRow {
  const ReportRow({
    required this.label,
    required this.current,
    required this.previous,
    required this.deltaPercent,
  });

  final String label;
  final String current;
  final String previous;
  final int deltaPercent;

  bool get isPositive => deltaPercent >= 0;
}
