import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/message.dart';

class StreamingIndicator extends StatelessWidget {
  final List<StreamingStep> steps;

  const StreamingIndicator({
    super.key,
    required this.steps,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: steps.map((step) => _StepItem(step: step)).toList(),
    );
  }
}

class _StepItem extends StatelessWidget {
  final StreamingStep step;

  const _StepItem({required this.step});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      liveRegion: true,
      label: step.isComplete
          ? '${step.label} Complete'
          : '${step.label} In progress',
      child: AnimatedContainer(
        duration: AppTheme.animationFast,
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(AppTheme.paddingSmall),
        decoration: BoxDecoration(
          color: step.isComplete
              ? AppTheme.confidenceHighBg
              : AppTheme.sourceBackground,
          borderRadius: BorderRadius.circular(AppTheme.borderRadiusSmall),
        ),
        child: Row(
          children: [
            if (step.isComplete)
              const Icon(
                Icons.check_circle,
                color: AppTheme.success,
                size: 18,
                semanticLabel: 'Complete',
              )
            else
              const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    AppTheme.infoText,
                  ),
                  semanticsLabel: 'Loading',
                ),
              ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                step.label,
                style: TextStyle(
                  fontSize: AppTheme.fontSizeSmall,
                  color: step.isComplete
                      ? AppTheme.success
                      : AppTheme.infoText,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
