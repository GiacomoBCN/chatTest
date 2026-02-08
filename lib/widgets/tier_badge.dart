import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/message.dart';

class TierBadge extends StatelessWidget {
  final TierLevel tier;
  final String? customLabel;

  const TierBadge({
    super.key,
    required this.tier,
    this.customLabel,
  });

  Color get _backgroundColor {
    switch (tier) {
      case TierLevel.tier1:
        return AppTheme.tier1Bg;
      case TierLevel.tier2:
        return AppTheme.tier2Bg;
      case TierLevel.tier3:
        return AppTheme.tier3Bg;
    }
  }

  Color get _textColor {
    switch (tier) {
      case TierLevel.tier1:
        return AppTheme.tier1Text;
      case TierLevel.tier2:
        return AppTheme.tier2Text;
      case TierLevel.tier3:
        return AppTheme.tier3Text;
    }
  }

  String get _label {
    if (customLabel != null) return customLabel!;
    switch (tier) {
      case TierLevel.tier1:
        return 'Tier 1: Factual Query';
      case TierLevel.tier2:
        return 'Tier 2: Interpretive Analysis';
      case TierLevel.tier3:
        return 'Tier 3: Advisory Query - Human Handoff Required';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: _backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        _label,
        style: TextStyle(
          fontSize: AppTheme.fontSizeTiny,
          fontWeight: FontWeight.w600,
          color: _textColor,
        ),
      ),
    );
  }
}
