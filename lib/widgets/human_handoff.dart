import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../language_provider.dart';
import '../l10n/app_strings.dart';

class HumanHandoff extends StatelessWidget {
  final String title;
  final String message;
  final String explanation;
  final VoidCallback? onScheduleCall;
  final VoidCallback? onLiveChat;

  const HumanHandoff({
    super.key,
    required this.title,
    required this.message,
    required this.explanation,
    this.onScheduleCall,
    this.onLiveChat,
  });

  @override
  Widget build(BuildContext context) {
    final s = AppStrings(LanguageProvider.of(context).isArabic);
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            AppTheme.handoffGradientStart,
            AppTheme.handoffGradientEnd,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppTheme.borderRadiusSmall),
      ),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            const Text('👨‍💼', style: TextStyle(fontSize: 36)),
            const SizedBox(height: 10),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppTheme.infoText,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: const TextStyle(
                fontSize: AppTheme.fontSizeSmall,
                color: AppTheme.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: onScheduleCall,
                    style: OutlinedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: AppTheme.infoText,
                      side: const BorderSide(color: AppTheme.infoText, width: 2),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    icon: const Text('📞', style: TextStyle(fontSize: 14)),
                    label: Text(
                      s.scheduleCall,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: onLiveChat,
                    style: OutlinedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: AppTheme.infoText,
                      side: const BorderSide(color: AppTheme.infoText, width: 2),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    icon: const Text('💬', style: TextStyle(fontSize: 14)),
                    label: Text(
                      s.liveChatNow,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class HandoffExplanation extends StatelessWidget {
  final String title;
  final String content;

  const HandoffExplanation({
    super.key,
    required this.title,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.paddingSmall),
      decoration: BoxDecoration(
        color: AppTheme.sourceBackground,
        borderRadius: BorderRadius.circular(AppTheme.borderRadiusSmall),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text('ℹ️', style: TextStyle(fontSize: 14)),
              const SizedBox(width: 6),
              Text(
                title,
                style: const TextStyle(
                  fontSize: AppTheme.fontSizeSmall,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.infoText,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: const TextStyle(
              fontSize: AppTheme.fontSizeXSmall,
              color: AppTheme.textSecondary,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}
