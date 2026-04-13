import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/message.dart';
import '../language_provider.dart';

class UncertaintyBar extends StatelessWidget {
  final UncertaintyData data;

  const UncertaintyBar({
    super.key,
    required this.data,
  });

  String _formatAmount(double amount) {
    return 'QAR ${amount.toStringAsFixed(0).replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]},',
        )}';
  }

  @override
  Widget build(BuildContext context) {
    final isArabic = LanguageProvider.of(context).isArabic;
    return Container(
      padding: const EdgeInsets.all(AppTheme.paddingMedium),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(AppTheme.borderRadiusMedium),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            isArabic ? 'تفاصيل يقين البيانات' : 'Data Certainty Breakdown',
            style: const TextStyle(
              fontSize: AppTheme.fontSizeBody,
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          // Segmented bar
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: SizedBox(
              height: 24,
              child: Row(
                children: [
                  // Confirmed segment (solid green)
                  Expanded(
                    flex: data.confirmedPercent.round(),
                    child: Container(color: AppTheme.confidenceHigh),
                  ),
                  // Estimated segment (solid yellow)
                  Expanded(
                    flex: data.estimatedPercent.round(),
                    child: Container(color: AppTheme.confidenceMedium),
                  ),
                  // Uncertain segment (solid red)
                  Expanded(
                    flex: data.uncertainPercent.round(),
                    child: Container(color: AppTheme.confidenceLow),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          // Legend
          Row(
            children: [
              _LegendItem(
                color: AppTheme.confidenceHigh,
                label: isArabic ? 'مؤكد' : 'Confirmed',
                amount: _formatAmount(data.confirmedAmount),
                percent: '${data.confirmedPercent.round()}%',
                pattern: _LegendPattern.solid,
              ),
              const SizedBox(width: 8),
              _LegendItem(
                color: AppTheme.confidenceMedium,
                label: isArabic ? 'مقدّر' : 'Estimated',
                amount: _formatAmount(data.estimatedAmount),
                percent: '${data.estimatedPercent.round()}%',
                pattern: _LegendPattern.striped,
              ),
              const SizedBox(width: 8),
              _LegendItem(
                color: AppTheme.confidenceLow,
                label: isArabic ? 'غير محدد' : 'Uncertain',
                amount: _formatAmount(data.uncertainAmount),
                percent: '${data.uncertainPercent.round()}%',
                pattern: _LegendPattern.dotted,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

enum _LegendPattern { solid, striped, dotted }

class _LegendItem extends StatelessWidget {
  final Color color;
  final String label;
  final String amount;
  final String percent;
  final _LegendPattern pattern;

  const _LegendItem({
    required this.color,
    required this.label,
    required this.amount,
    required this.percent,
    required this.pattern,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 4),
              Flexible(
                child: Text(
                  '$label $percent',
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: TextStyle(
                    fontSize: AppTheme.fontSizeXSmall,
                    color: color,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 2),
          Text(
            amount,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            style: const TextStyle(
              fontSize: AppTheme.fontSizeXSmall,
              color: AppTheme.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class _DiagonalStripesPainter extends CustomPainter {
  final Color color;
  final bool small;

  _DiagonalStripesPainter({required this.color, this.small = false});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = small ? 2 : 4
      ..style = PaintingStyle.stroke;

    final spacing = small ? 4.0 : 8.0;
    for (double i = -size.height; i < size.width + size.height; i += spacing) {
      canvas.drawLine(
        Offset(i, size.height),
        Offset(i + size.height, 0),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _DottedPainter extends CustomPainter {
  final Color color;
  final bool small;

  _DottedPainter({required this.color, this.small = false});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final dotSize = small ? 2.0 : 3.0;
    final spacing = small ? 4.0 : 6.0;

    for (double x = spacing / 2; x < size.width; x += spacing) {
      for (double y = spacing / 2; y < size.height; y += spacing) {
        canvas.drawCircle(Offset(x, y), dotSize / 2, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
