import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../language_provider.dart';
import '../l10n/app_strings.dart';

class AccountabilityCheckpoint extends StatefulWidget {
  final VoidCallback? onApprove;
  final VoidCallback? onDecline;

  const AccountabilityCheckpoint({
    super.key,
    this.onApprove,
    this.onDecline,
  });

  @override
  State<AccountabilityCheckpoint> createState() =>
      _AccountabilityCheckpointState();
}

class _AccountabilityCheckpointState extends State<AccountabilityCheckpoint> {
  bool _isChecked = false;
  String? _selectedDeclineReason;

  @override
  Widget build(BuildContext context) {
    final s = AppStrings(LanguageProvider.of(context).isArabic);
    final declineReasons = s.isArabic
        ? [
            'اختر السبب...',
            'بيانات العميل غير كافية',
            'يلزم تقييم المخاطر',
            'يلزم موافقة المدير',
            'العميل غير مؤهل',
            'أخرى',
          ]
        : [
            'Select reason...',
            'Insufficient customer data',
            'Risk assessment required',
            'Manager approval needed',
            'Customer not eligible',
            'Other',
          ];
    return Container(
      padding: const EdgeInsets.all(AppTheme.paddingMedium),
      decoration: BoxDecoration(
        color: AppTheme.checkpointBackground,
        borderRadius: BorderRadius.circular(AppTheme.borderRadiusMedium),
        border: Border.all(color: AppTheme.warning.withOpacity(0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text('⚖️', style: TextStyle(fontSize: 20)),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  s.accountabilityCheckpoint,
                  style: const TextStyle(
                    fontSize: AppTheme.fontSizeTitle,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textPrimary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Checkbox
          InkWell(
            onTap: () {
              setState(() {
                _isChecked = !_isChecked;
              });
            },
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 24,
                  height: 24,
                  child: Checkbox(
                    value: _isChecked,
                    onChanged: (value) {
                      setState(() {
                        _isChecked = value ?? false;
                      });
                    },
                    activeColor: AppTheme.primaryBurgundy,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    s.isArabic
                        ? 'لقد راجعت بيانات العميل وتوصية الذكاء الاصطناعي. أؤكد أن هذا الإجراء يتوافق مع سياسات البنك ومصالح العميل.'
                        : 'I have reviewed the customer data and ML recommendation. I confirm this action aligns with bank policies and customer best interests.',
                    style: const TextStyle(
                      fontSize: AppTheme.fontSizeBody,
                      color: AppTheme.textPrimary,
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Decline reason dropdown
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(AppTheme.borderRadiusSmall),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _selectedDeclineReason ?? declineReasons[0],
                isExpanded: true,
                icon: const Icon(Icons.keyboard_arrow_down),
                items: declineReasons.map((reason) {
                  return DropdownMenuItem<String>(
                    value: reason,
                    child: Text(
                      reason,
                      style: TextStyle(
                        fontSize: AppTheme.fontSizeBody,
                        color: reason == declineReasons[0]
                            ? AppTheme.textSecondary
                            : AppTheme.textPrimary,
                      ),
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedDeclineReason = value;
                  });
                },
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Action buttons
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: _isChecked ? widget.onApprove : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        _isChecked ? AppTheme.success : Colors.grey[300],
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.check, size: 18),
                      const SizedBox(width: 6),
                      Flexible(
                        child: Text(
                          s.approveAndSchedule,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton(
                  onPressed: widget.onDecline,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppTheme.danger,
                    side: const BorderSide(color: AppTheme.danger),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.close, size: 18),
                      const SizedBox(width: 6),
                      Flexible(
                        child: Text(
                          s.decline,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Audit trail note
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.5),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.history,
                  size: 14,
                  color: AppTheme.textSecondary,
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    '${s.isArabic ? 'سيتم تسجيل قرارك لأغراض التدقيق. رقم الجلسة:' : 'Your decision will be logged for audit purposes. Session ID:'} CBQ-2026-0208-4521',
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppTheme.textSecondary,
                    ),
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
