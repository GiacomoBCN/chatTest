import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/message.dart';

class ConfidenceIndicator extends StatefulWidget {
  final int confidencePercent;
  final ConfidenceLevel level;

  const ConfidenceIndicator({
    super.key,
    required this.confidencePercent,
    required this.level,
  });

  @override
  State<ConfidenceIndicator> createState() => _ConfidenceIndicatorState();
}

class _ConfidenceIndicatorState extends State<ConfidenceIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: AppTheme.animationSlow,
      vsync: this,
    );
    _animation = Tween<double>(
      begin: 0,
      end: widget.confidencePercent / 100,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    ));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Color get _accentColor {
    switch (widget.level) {
      case ConfidenceLevel.high:
        return AppTheme.confidenceHigh;
      case ConfidenceLevel.medium:
        return AppTheme.confidenceMedium;
      case ConfidenceLevel.low:
        return AppTheme.confidenceLow;
    }
  }

  Color get _textColor => AppTheme.textPrimary;

  Color get _backgroundColor {
    switch (widget.level) {
      case ConfidenceLevel.high:
        return AppTheme.confidenceHighBg;
      case ConfidenceLevel.medium:
        return AppTheme.confidenceMediumBg;
      case ConfidenceLevel.low:
        return AppTheme.confidenceLowBg;
    }
  }

  String get _label {
    switch (widget.level) {
      case ConfidenceLevel.high:
        return '✓ High Confidence - Direct database query, real-time data';
      case ConfidenceLevel.medium:
        return '⚠️ Medium Confidence - Some data points estimated';
      case ConfidenceLevel.low:
        return '⚠️ Low Confidence - Significant uncertainty detected';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Confidence score ${widget.confidencePercent} percent. ${_label}',
      child: Container(
        padding: const EdgeInsets.all(AppTheme.paddingSmall),
        decoration: BoxDecoration(
          color: _backgroundColor,
          borderRadius: BorderRadius.circular(AppTheme.borderRadiusSmall),
          border: Border(
            left: BorderSide(
              color: _accentColor,
              width: 4,
            ),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'CONFIDENCE SCORE',
                  style: TextStyle(
                    fontSize: AppTheme.fontSizeXSmall,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                    color: _textColor,
                  ),
                ),
                Row(
                  children: [
                    // Traffic light indicator
                    _TrafficLight(level: widget.level),
                    const SizedBox(width: 8),
                    // Percentage display
                    Text(
                      '${widget.confidencePercent}%',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: _textColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 10),
            // Progress bar
            ClipRRect(
              borderRadius: BorderRadius.circular(3),
              child: AnimatedBuilder(
                animation: _animation,
                builder: (context, child) {
                  return SizedBox(
                    height: 6,
                    child: Stack(
                      children: [
                        Container(
                          width: double.infinity,
                          color: const Color(0xFFe9ecef),
                        ),
                        FractionallySizedBox(
                          widthFactor: _animation.value,
                          child: Container(color: _accentColor),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 8),
            // Contextual text
            Text(
              _label,
              style: TextStyle(
                fontSize: AppTheme.fontSizeXSmall,
                color: _textColor.withOpacity(0.9),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TrafficLight extends StatelessWidget {
  final ConfidenceLevel level;

  const _TrafficLight({required this.level});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _TrafficDot(
          isActive: level == ConfidenceLevel.low,
          color: AppTheme.confidenceLow,
        ),
        const SizedBox(width: 4),
        _TrafficDot(
          isActive: level == ConfidenceLevel.medium,
          color: AppTheme.confidenceMedium,
        ),
        const SizedBox(width: 4),
        _TrafficDot(
          isActive: level == ConfidenceLevel.high,
          color: AppTheme.confidenceHigh,
        ),
      ],
    );
  }
}

class _TrafficDot extends StatelessWidget {
  final bool isActive;
  final Color color;

  const _TrafficDot({
    required this.isActive,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 12,
      height: 12,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isActive ? color : const Color(0xFFdee2e6),
        boxShadow: isActive
            ? [
                BoxShadow(
                  color: color.withOpacity(0.6),
                  blurRadius: 8,
                  spreadRadius: 0,
                ),
              ]
            : null,
      ),
    );
  }
}
