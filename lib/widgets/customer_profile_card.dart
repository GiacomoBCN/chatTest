import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/message.dart';

class CustomerProfileCard extends StatelessWidget {
  final CustomerProfile profile;

  const CustomerProfileCard({
    super.key,
    required this.profile,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.paddingMedium),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppTheme.borderRadiusMedium),
        border: Border.all(color: Colors.grey[200]!),
        boxShadow: AppTheme.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppTheme.primaryBurgundy.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.person,
                  color: AppTheme.primaryBurgundy,
                  size: 28,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      profile.name,
                      style: const TextStyle(
                        fontSize: AppTheme.fontSizeTitle,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    Text(
                      profile.segment,
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
          const SizedBox(height: 16),
          const Divider(),
          const SizedBox(height: 12),
          // Grid layout for profile details
          Row(
            children: [
              Expanded(
                child: _ProfileItem(
                  icon: Icons.calendar_month,
                  label: 'Relationship',
                  value: profile.relationship,
                ),
              ),
              Expanded(
                child: _ProfileItem(
                  icon: Icons.access_time,
                  label: 'Last Contact',
                  value: profile.lastContact,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _ProfileItem(
                  icon: Icons.trending_up,
                  label: 'Potential Value',
                  value: profile.potentialValue,
                  valueColor: AppTheme.success,
                ),
              ),
              Expanded(
                child: _ProfileItem(
                  icon: Icons.shield,
                  label: 'Risk Score',
                  value: profile.riskScore,
                  valueColor: _getRiskColor(profile.riskScore),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _getRiskColor(String riskScore) {
    if (riskScore.toLowerCase().contains('low')) {
      return AppTheme.success;
    } else if (riskScore.toLowerCase().contains('medium')) {
      return AppTheme.warning;
    }
    return AppTheme.danger;
  }
}

class _ProfileItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color? valueColor;

  const _ProfileItem({
    required this.icon,
    required this.label,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          size: 16,
          color: AppTheme.textSecondary,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 11,
                  color: AppTheme.textSecondary,
                ),
              ),
              Text(
                value,
                style: TextStyle(
                  fontSize: AppTheme.fontSizeSmall,
                  fontWeight: FontWeight.w600,
                  color: valueColor ?? AppTheme.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
