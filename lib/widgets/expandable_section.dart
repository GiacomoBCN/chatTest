import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/message.dart';
import '../language_provider.dart';

class ExpandableSection extends StatefulWidget {
  final String title;
  final MLReasoning reasoning;

  const ExpandableSection({
    super.key,
    required this.title,
    required this.reasoning,
  });

  @override
  State<ExpandableSection> createState() => _ExpandableSectionState();
}

class _ExpandableSectionState extends State<ExpandableSection>
    with SingleTickerProviderStateMixin {
  bool _isExpanded = false;
  late AnimationController _controller;
  late Animation<double> _rotationAnimation;
  late Animation<double> _expandAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: AppTheme.animationFast,
      vsync: this,
    );
    _rotationAnimation = Tween<double>(
      begin: 0,
      end: 0.25, // 90 degrees
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
    _expandAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggle() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isArabic = LanguageProvider.of(context).isArabic;
    final displayTitle = (widget.title == 'Show ML reasoning' && isArabic)
        ? 'عرض استدلال الذكاء الاصطناعي'
        : widget.title;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header - clickable
        InkWell(
          onTap: _toggle,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              children: [
                RotationTransition(
                  turns: _rotationAnimation,
                  child: const Text(
                    '▶',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppTheme.primaryBurgundy,
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  displayTitle,
                  style: const TextStyle(
                    fontSize: AppTheme.fontSizeSmall,
                    fontWeight: FontWeight.w500,
                    color: AppTheme.primaryBurgundy,
                  ),
                ),
              ],
            ),
          ),
        ),
        // Content
        SizeTransition(
          sizeFactor: _expandAnimation,
          child: Container(
            margin: const EdgeInsets.only(top: 8),
            padding: const EdgeInsets.all(AppTheme.paddingSmall),
            decoration: BoxDecoration(
              color: const Color(0xFFF8F9FA),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: widget.reasoning.points.map((point) {
                final isWarning = point.contains('⚠') ||
                    point.toLowerCase().contains('partial') ||
                    point.toLowerCase().contains('incomplete');
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isWarning ? '⚠' : '✓',
                        style: TextStyle(
                          fontSize: 12,
                          color: isWarning
                              ? AppTheme.warning
                              : AppTheme.success,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          point.replaceAll('⚠', '').replaceAll('✓', '').trim(),
                          style: const TextStyle(
                            fontSize: AppTheme.fontSizeXSmall,
                            color: AppTheme.textSecondary,
                            height: 1.4,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }
}
