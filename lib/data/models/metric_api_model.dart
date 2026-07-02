import 'package:dashboard/domain/models/metric.dart';

/// Raw API model for a KPI with manual JSON (de)serialization.
class MetricApiModel {
  const MetricApiModel({
    required this.label,
    required this.value,
    required this.delta,
    required this.icon,
  });

  final String label;
  final String value;
  final int delta;
  final String icon;

  factory MetricApiModel.fromJson(Map<String, dynamic> json) => MetricApiModel(
        label: (json['label'] ?? '') as String,
        value: (json['value'] ?? '') as String,
        delta: (json['delta'] ?? 0) as int,
        icon: (json['icon'] ?? 'insights') as String,
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        'label': label,
        'value': value,
        'delta': delta,
        'icon': icon,
      };

  /// Transform the transport model into the clean domain model.
  Metric toDomain() =>
      Metric(label: label, value: value, deltaPercent: delta, iconKey: icon);
}
