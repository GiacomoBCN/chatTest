import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/message.dart';
import '../language_provider.dart';
import '../l10n/app_strings.dart';

class SourceAttribution extends StatelessWidget {
  final List<SourceInfo> sources;

  const SourceAttribution({
    super.key,
    required this.sources,
  });

  @override
  Widget build(BuildContext context) {
    final s = AppStrings(LanguageProvider.of(context).isArabic);
    return Container(
      padding: const EdgeInsets.all(AppTheme.paddingMedium),
      decoration: BoxDecoration(
        color: AppTheme.sourceBackground,
        borderRadius: BorderRadius.circular(AppTheme.borderRadiusMedium),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text('📄', style: TextStyle(fontSize: 16)),
              const SizedBox(width: 8),
              Text(
                s.dataSources,
                style: const TextStyle(
                  fontSize: AppTheme.fontSizeBody,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...sources.map((source) => _SourceItem(source: source)),
        ],
      ),
    );
  }
}

class _SourceItem extends StatelessWidget {
  final SourceInfo source;

  const _SourceItem({required this.source});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                  onTap: source.url != null ? () {} : null,
                  child: Row(
                    children: [
                      Flexible(
                        child: Text(
                          source.name,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: TextStyle(
                            fontSize: AppTheme.fontSizeBody,
                            color: source.url != null
                                ? Colors.blue[700]
                                : AppTheme.textPrimary,
                            decoration: source.url != null
                                ? TextDecoration.underline
                                : TextDecoration.none,
                          ),
                        ),
                      ),
                      if (source.url != null) ...[
                        const SizedBox(width: 4),
                        Icon(
                          Icons.arrow_outward,
                          size: 14,
                          color: Colors.blue[700],
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  source.metadata,
                  style: const TextStyle(
                    fontSize: AppTheme.fontSizeSmall,
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
