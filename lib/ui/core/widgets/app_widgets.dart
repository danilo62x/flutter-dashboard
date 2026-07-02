import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import 'package:dashboard/core/theme.dart';
import 'package:dashboard/domain/models/customer.dart';
import 'package:dashboard/domain/models/metric.dart';
import 'package:dashboard/domain/models/order.dart';

/// Shared BRL currency formatter.
final NumberFormat kCurrency = NumberFormat.currency(
  locale: 'pt_BR',
  symbol: 'R\$ ',
  decimalDigits: 2,
);

String brl(double value) => kCurrency.format(value);

/// Uppercase initials for an avatar (max two letters), no network image needed.
String initialsFor(String name) {
  final parts =
      name.trim().split(RegExp(r'\s+')).where((p) => p.isNotEmpty).toList();
  if (parts.isEmpty) return '?';
  if (parts.length == 1) {
    final p = parts.first;
    return (p.length >= 2 ? p.substring(0, 2) : p).toUpperCase();
  }
  return (parts.first[0] + parts.last[0]).toUpperCase();
}

/// Maps a stable domain icon key to a Material icon (keeps the domain layer
/// free of Flutter imports).
IconData iconForKey(String key) {
  switch (key) {
    case 'payments':
      return Icons.payments_outlined;
    case 'shopping_bag':
      return Icons.shopping_bag_outlined;
    case 'group':
      return Icons.group_outlined;
    case 'trending_up':
      return Icons.trending_up_rounded;
    case 'receipt':
      return Icons.receipt_long_outlined;
    case 'visibility':
      return Icons.visibility_outlined;
    case 'refund':
      return Icons.replay_circle_filled_outlined;
    case 'inventory':
      return Icons.inventory_2_outlined;
    case 'storefront':
      return Icons.storefront_outlined;
    case 'smartphone':
      return Icons.smartphone_outlined;
    case 'store':
      return Icons.store_mall_directory_outlined;
    case 'public':
      return Icons.public_outlined;
    default:
      return Icons.insights_outlined;
  }
}

/// Rounded, softly bordered surface used across every screen.
class AppCard extends StatelessWidget {
  const AppCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(18),
    this.onTap,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final decoration = BoxDecoration(
      color: scheme.surfaceContainerLow,
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: scheme.outlineVariant.withValues(alpha: 0.5)),
    );

    if (onTap == null) {
      return Container(
        decoration: decoration,
        // A transparent Material gives inner ListTiles an ancestor to paint
        // their ink on, above this container's decoration.
        child: Material(
          type: MaterialType.transparency,
          child: Padding(padding: padding, child: child),
        ),
      );
    }
    return Material(
      color: Colors.transparent,
      child: Ink(
        decoration: decoration,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Padding(padding: padding, child: child),
        ),
      ),
    );
  }
}

/// Row with a bold section title and an optional trailing action label.
class SectionHeader extends StatelessWidget {
  const SectionHeader({super.key, required this.title, this.action, this.onAction});

  final String title;
  final String? action;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: text.titleMedium?.copyWith(fontWeight: FontWeight.w800)),
        if (action != null)
          GestureDetector(
            onTap: onAction,
            child: Text(
              action!,
              style: text.labelLarge
                  ?.copyWith(color: scheme.primary, fontWeight: FontWeight.w600),
            ),
          ),
      ],
    );
  }
}

/// Compact KPI card: tonal icon, big value, label and a signed delta.
class MetricCard extends StatelessWidget {
  const MetricCard({super.key, required this.metric});

  final Metric metric;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    final deltaColor = metric.isPositive ? AppTheme.positive : AppTheme.negative;
    final sign = metric.isPositive ? '+' : '';

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: scheme.primaryContainer,
              shape: BoxShape.circle,
            ),
            child: Icon(
              iconForKey(metric.iconKey),
              color: scheme.onPrimaryContainer,
              size: 22,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            metric.value,
            style: text.headlineSmall?.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 2),
          Text(
            metric.label,
            style: text.bodyMedium?.copyWith(color: scheme.onSurfaceVariant),
          ),
          const SizedBox(height: 10),
          _DeltaBadge(delta: metric.deltaPercent, color: deltaColor, sign: sign),
        ],
      ),
    );
  }
}

class _DeltaBadge extends StatelessWidget {
  const _DeltaBadge({required this.delta, required this.color, required this.sign});

  final int delta;
  final Color color;
  final String sign;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final isPositive = delta >= 0;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          isPositive ? Icons.arrow_upward_rounded : Icons.arrow_downward_rounded,
          size: 14,
          color: color,
        ),
        const SizedBox(width: 2),
        Text(
          '$sign$delta%',
          style: text.labelMedium?.copyWith(color: color, fontWeight: FontWeight.w700),
        ),
      ],
    );
  }
}

/// Signed percentage delta with an arrow (reusable outside of [MetricCard]).
class DeltaLabel extends StatelessWidget {
  const DeltaLabel({super.key, required this.delta});

  final int delta;

  @override
  Widget build(BuildContext context) {
    final color = delta >= 0 ? AppTheme.positive : AppTheme.negative;
    return _DeltaBadge(delta: delta, color: color, sign: delta >= 0 ? '+' : '');
  }
}

/// Small tonal pill describing an order's fulfilment state.
class StatusChip extends StatelessWidget {
  const StatusChip({super.key, required this.status});

  final OrderStatus status;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final (label, color) = switch (status) {
      OrderStatus.paid => ('Pago', AppTheme.positive),
      OrderStatus.pending => ('Pendente', AppTheme.warning),
      OrderStatus.shipped => ('Enviado', AppTheme.info),
      OrderStatus.cancelled => ('Cancelado', AppTheme.negative),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: text.labelSmall?.copyWith(color: color, fontWeight: FontWeight.w700),
      ),
    );
  }
}

/// Tonal pill describing a customer's segment.
class SegmentChip extends StatelessWidget {
  const SegmentChip({super.key, required this.segment});

  final CustomerSegment segment;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final (label, color) = switch (segment) {
      CustomerSegment.vip => ('VIP', const Color(0xFF9333EA)),
      CustomerSegment.active => ('Ativo', AppTheme.info),
      CustomerSegment.newcomer => ('Novo', AppTheme.positive),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: text.labelSmall?.copyWith(color: color, fontWeight: FontWeight.w700),
      ),
    );
  }
}

/// Circular avatar with the person's initials (no network image).
class InitialsAvatar extends StatelessWidget {
  const InitialsAvatar({
    super.key,
    required this.name,
    this.radius = 22,
    this.background,
    this.foreground,
  });

  final String name;
  final double radius;
  final Color? background;
  final Color? foreground;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    return CircleAvatar(
      radius: radius,
      backgroundColor: background ?? scheme.secondaryContainer,
      child: Text(
        initialsFor(name),
        style: text.titleSmall?.copyWith(
          fontSize: radius * 0.62,
          color: foreground ?? scheme.onSecondaryContainer,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

/// Rounded icon button with an optional unread dot.
class IconBadgeButton extends StatelessWidget {
  const IconBadgeButton({
    super.key,
    required this.icon,
    required this.onTap,
    this.showDot = false,
  });

  final IconData icon;
  final VoidCallback onTap;
  final bool showDot;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        width: 46,
        height: 46,
        decoration: BoxDecoration(
          color: scheme.surfaceContainerHighest.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Icon(icon, color: scheme.onSurface, size: 24),
            if (showDot)
              Positioned(
                top: 12,
                right: 13,
                child: Container(
                  width: 9,
                  height: 9,
                  decoration: BoxDecoration(
                    color: scheme.error,
                    shape: BoxShape.circle,
                    border: Border.all(color: scheme.surface, width: 1.5),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// Styled search field used on list screens.
class SearchField extends StatelessWidget {
  const SearchField({
    super.key,
    required this.hint,
    this.controller,
    this.onChanged,
  });

  final String hint;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return TextField(
      controller: controller,
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: Icon(Icons.search_rounded, color: scheme.onSurfaceVariant),
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(vertical: 14),
      ),
    );
  }
}

/// Bar chart made of rounded [Container]s (no external chart package).
class BarChartBars extends StatelessWidget {
  const BarChartBars({
    super.key,
    required this.values,
    required this.labels,
    this.height = 148,
    this.highlightPeak = true,
  });

  final List<double> values;
  final List<String> labels;
  final double height;
  final bool highlightPeak;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;

    var peak = 0;
    for (var i = 1; i < values.length; i++) {
      if (values[i] > values[peak]) peak = i;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(
          height: height,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              for (var i = 0; i < values.length; i++)
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: Container(
                      height: 16 + values[i] * (height - 26),
                      decoration: BoxDecoration(
                        color: highlightPeak && i == peak
                            ? scheme.primary
                            : scheme.primary.withValues(alpha: 0.22),
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(8),
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            for (final label in labels)
              Expanded(
                child: Center(
                  child: Text(
                    label,
                    style: text.bodySmall?.copyWith(color: scheme.onSurfaceVariant),
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }
}

/// Smooth line chart drawn with [CustomPaint] (gradient fill + dots).
class LineChart extends StatelessWidget {
  const LineChart({
    super.key,
    required this.values,
    this.color,
    this.height = 170,
    this.showDots = true,
  });

  final List<double> values;
  final Color? color;
  final double height;
  final bool showDots;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final line = color ?? scheme.primary;
    return SizedBox(
      height: height,
      width: double.infinity,
      child: CustomPaint(
        painter: _LineChartPainter(
          values: values,
          line: line,
          fill: line.withValues(alpha: 0.14),
          grid: scheme.outlineVariant.withValues(alpha: 0.4),
          dotFill: scheme.surface,
          showDots: showDots,
        ),
      ),
    );
  }
}

class _LineChartPainter extends CustomPainter {
  _LineChartPainter({
    required this.values,
    required this.line,
    required this.fill,
    required this.grid,
    required this.dotFill,
    required this.showDots,
  });

  final List<double> values;
  final Color line;
  final Color fill;
  final Color grid;
  final Color dotFill;
  final bool showDots;

  @override
  void paint(Canvas canvas, Size size) {
    if (values.isEmpty) return;
    const pad = 8.0;
    final w = size.width;
    final h = size.height - pad * 2;

    final gridPaint = Paint()
      ..color = grid
      ..strokeWidth = 1;
    for (var i = 0; i <= 3; i++) {
      final y = pad + h * i / 3;
      canvas.drawLine(Offset(0, y), Offset(w, y), gridPaint);
    }

    final dx = values.length > 1 ? w / (values.length - 1) : w;
    Offset pointAt(int i) =>
        Offset(i * dx, pad + h * (1 - values[i].clamp(0.0, 1.0)));

    final linePath = Path();
    final fillPath = Path()..moveTo(0, size.height - pad);
    for (var i = 0; i < values.length; i++) {
      final p = pointAt(i);
      if (i == 0) {
        linePath.moveTo(p.dx, p.dy);
      } else {
        linePath.lineTo(p.dx, p.dy);
      }
      fillPath.lineTo(p.dx, p.dy);
    }
    fillPath
      ..lineTo((values.length - 1) * dx, size.height - pad)
      ..close();

    canvas.drawPath(fillPath, Paint()..color = fill);
    canvas.drawPath(
      linePath,
      Paint()
        ..color = line
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3
        ..strokeJoin = StrokeJoin.round
        ..strokeCap = StrokeCap.round,
    );

    if (showDots) {
      for (var i = 0; i < values.length; i++) {
        final p = pointAt(i);
        canvas.drawCircle(p, 4.5, Paint()..color = line);
        canvas.drawCircle(p, 2.2, Paint()..color = dotFill);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _LineChartPainter old) =>
      old.values != values || old.line != line;
}

/// Tiny trend line for report cards.
class Sparkline extends StatelessWidget {
  const Sparkline({
    super.key,
    required this.values,
    required this.color,
    this.height = 42,
  });

  final List<double> values;
  final Color color;
  final double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: double.infinity,
      child: CustomPaint(
        painter: _SparklinePainter(values: values, color: color),
      ),
    );
  }
}

class _SparklinePainter extends CustomPainter {
  _SparklinePainter({required this.values, required this.color});

  final List<double> values;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    if (values.isEmpty) return;
    const pad = 3.0;
    final w = size.width;
    final h = size.height - pad * 2;
    final dx = values.length > 1 ? w / (values.length - 1) : w;
    Offset pointAt(int i) =>
        Offset(i * dx, pad + h * (1 - values[i].clamp(0.0, 1.0)));

    final linePath = Path();
    final fillPath = Path()..moveTo(0, size.height);
    for (var i = 0; i < values.length; i++) {
      final p = pointAt(i);
      if (i == 0) {
        linePath.moveTo(p.dx, p.dy);
      } else {
        linePath.lineTo(p.dx, p.dy);
      }
      fillPath.lineTo(p.dx, p.dy);
    }
    fillPath
      ..lineTo((values.length - 1) * dx, size.height)
      ..close();

    canvas.drawPath(fillPath, Paint()..color = color.withValues(alpha: 0.14));
    canvas.drawPath(
      linePath,
      Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.4
        ..strokeJoin = StrokeJoin.round
        ..strokeCap = StrokeCap.round,
    );
  }

  @override
  bool shouldRepaint(covariant _SparklinePainter old) =>
      old.values != values || old.color != color;
}

/// One slice of a [DonutChart].
class DonutSegment {
  const DonutSegment(this.value, this.color);
  final double value;
  final Color color;
}

/// Donut/ring chart drawn with [CustomPaint], with a centered caption.
class DonutChart extends StatelessWidget {
  const DonutChart({
    super.key,
    required this.segments,
    this.size = 132,
    this.stroke = 20,
    this.centerValue,
    this.centerLabel,
  });

  final List<DonutSegment> segments;
  final double size;
  final double stroke;
  final String? centerValue;
  final String? centerLabel;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            size: Size(size, size),
            painter: _DonutPainter(
              segments: segments,
              stroke: stroke,
              track: scheme.surfaceContainerHighest.withValues(alpha: 0.6),
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (centerValue != null)
                Text(
                  centerValue!,
                  style: text.titleLarge?.copyWith(fontWeight: FontWeight.w800),
                ),
              if (centerLabel != null)
                Text(
                  centerLabel!,
                  style: text.bodySmall?.copyWith(color: scheme.onSurfaceVariant),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DonutPainter extends CustomPainter {
  _DonutPainter({
    required this.segments,
    required this.stroke,
    required this.track,
  });

  final List<DonutSegment> segments;
  final double stroke;
  final Color track;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(
      stroke / 2,
      stroke / 2,
      size.width - stroke,
      size.height - stroke,
    );
    final total = segments.fold<double>(0, (s, e) => s + e.value);
    if (total <= 0) return;

    canvas.drawArc(
      rect,
      0,
      2 * math.pi,
      false,
      Paint()
        ..color = track
        ..style = PaintingStyle.stroke
        ..strokeWidth = stroke,
    );

    const gap = 0.06;
    var start = -math.pi / 2;
    for (final seg in segments) {
      final sweep = 2 * math.pi * (seg.value / total);
      canvas.drawArc(
        rect,
        start + gap / 2,
        math.max(0, sweep - gap),
        false,
        Paint()
          ..color = seg.color
          ..style = PaintingStyle.stroke
          ..strokeWidth = stroke
          ..strokeCap = StrokeCap.round,
      );
      start += sweep;
    }
  }

  @override
  bool shouldRepaint(covariant _DonutPainter old) => old.segments != segments;
}

/// List row for an order (avatar, customer, id/date, amount + status).
class OrderTile extends StatelessWidget {
  const OrderTile({
    super.key,
    required this.order,
    this.onTap,
    this.showChevron = false,
  });

  final Order order;
  final VoidCallback? onTap;
  final bool showChevron;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        child: Row(
          children: [
            InitialsAvatar(name: order.customer),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    order.customer,
                    style: text.titleSmall?.copyWith(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '#${order.id} · ${order.date}',
                    style: text.bodySmall?.copyWith(color: scheme.onSurfaceVariant),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  brl(order.amount),
                  style: text.titleSmall?.copyWith(fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 4),
                StatusChip(status: order.status),
              ],
            ),
            if (showChevron) ...[
              const SizedBox(width: 4),
              Icon(Icons.chevron_right_rounded, color: scheme.onSurfaceVariant),
            ],
          ],
        ),
      ),
    );
  }
}

/// List row for a customer (avatar, name, city, orders/total, segment).
class CustomerTile extends StatelessWidget {
  const CustomerTile({super.key, required this.customer, this.onTap});

  final Customer customer;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        child: Row(
          children: [
            InitialsAvatar(name: customer.name, radius: 24),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          customer.name,
                          overflow: TextOverflow.ellipsis,
                          style: text.titleSmall?.copyWith(fontWeight: FontWeight.w700),
                        ),
                      ),
                      const SizedBox(width: 8),
                      SegmentChip(segment: customer.segment),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${customer.city} · ${customer.orders} pedidos',
                    style: text.bodySmall?.copyWith(color: scheme.onSurfaceVariant),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Text(
              brl(customer.totalSpent),
              style: text.titleSmall?.copyWith(fontWeight: FontWeight.w800),
            ),
          ],
        ),
      ),
    );
  }
}

/// Bottom navigation shared by the five primary tabs. Taps drive go_router.
class AppBottomNav extends StatelessWidget {
  const AppBottomNav({super.key, required this.currentIndex});

  final int currentIndex;

  static const List<String> _routes = <String>[
    '/',
    '/orders',
    '/customers',
    '/reports',
    '/settings',
  ];

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: (i) {
        if (i != currentIndex) context.go(_routes[i]);
      },
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined),
          activeIcon: Icon(Icons.home_rounded),
          label: 'Início',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.receipt_long_outlined),
          activeIcon: Icon(Icons.receipt_long_rounded),
          label: 'Pedidos',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.group_outlined),
          activeIcon: Icon(Icons.group_rounded),
          label: 'Clientes',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.insert_chart_outlined_rounded),
          activeIcon: Icon(Icons.insert_chart_rounded),
          label: 'Relatórios',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_outline),
          activeIcon: Icon(Icons.person_rounded),
          label: 'Perfil',
        ),
      ],
    );
  }
}
