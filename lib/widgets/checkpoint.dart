import 'package:flutter/material.dart';
import '../l10n/strings.dart';
import '../theme/falak_theme.dart';

/// The relationship manager's sign-off on an AI suggestion.
class Checkpoint extends StatefulWidget {
  const Checkpoint({super.key});

  @override
  State<Checkpoint> createState() => _CheckpointState();
}

class _CheckpointState extends State<Checkpoint> {
  bool _reviewed = false;
  int? _reason;

  void _toast(String msg) {
    showToast(context, msg);
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final c = FalakColors.of(context);
    final t = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Semantics(
          header: true,
          child: Text(s.checkpointTitle,
              style: t.titleMedium!.copyWith(fontSize: TypeRole.body, fontWeight: FontWeight.w600)),
        ),
        const SizedBox(height: Space.s),
        MergeSemantics(
          child: RingInkWell(
            borderRadius: BorderRadius.circular(Radii.control),
            onTap: () => setState(() => _reviewed = !_reviewed),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: Space.xs),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 28,
                    height: 28,
                    child: Checkbox(
                      value: _reviewed,
                      activeColor: c.staff,
                      onChanged: (v) => setState(() => _reviewed = v ?? false),
                    ),
                  ),
                  const SizedBox(width: Space.s),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 3),
                      child: Text(s.attestation,
                          style: t.bodyMedium!.copyWith(fontSize: TypeRole.label, height: 1.45)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: Space.m),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: Space.m),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Radii.control),
            border: Border.all(color: c.hairStrong),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<int>(
              value: _reason,
              isExpanded: true,
              dropdownColor: c.surface,
              borderRadius: BorderRadius.circular(Radii.control),
              hint: Text(s.declineReasonHint,
                  style: TextStyle(fontSize: TypeRole.label, color: c.muted)),
              icon: Icon(Icons.expand_more, color: c.muted),
              items: [
                for (var i = 0; i < s.declineReasons.length; i++)
                  DropdownMenuItem(
                    value: i,
                    child: Text(s.declineReasons[i],
                        style: TextStyle(fontSize: TypeRole.label, color: c.text)),
                  ),
              ],
              onChanged: (v) => setState(() => _reason = v),
            ),
          ),
        ),
        const SizedBox(height: Space.m),
        Row(
          children: [
            Expanded(
              child: FilledButton(
                onPressed: _reviewed ? () => _toast(s.approvedToast) : null,
                style: FilledButton.styleFrom(
                  backgroundColor: c.staff,
                  foregroundColor: c.surface,
                  disabledBackgroundColor: c.sunk,
                  disabledForegroundColor: c.muted,
                  minimumSize: const Size(0, 46),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Radii.control)),
                  textStyle: labelStyle(weight: FontWeight.w600),
                ),
                child: Text(s.approve),
              ),
            ),
            const SizedBox(width: Space.s + 2),
            Expanded(
              child: OutlinedButton(
                onPressed: () => _toast(s.declinedToast),
                style: OutlinedButton.styleFrom(
                  foregroundColor: c.text,
                  minimumSize: const Size(0, 46),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Radii.control)),
                  textStyle: labelStyle(weight: FontWeight.w600),
                ).copyWith(side: focusSide(c.text, BorderSide(color: c.hairStrong))),
                child: Text(s.decline),
              ),
            ),
          ],
        ),
        const SizedBox(height: Space.m),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.history, size: 16, color: c.muted),
            const SizedBox(width: Space.s),
            Expanded(
              child: Text(s.auditNote,
                  style:
                      t.bodySmall!.copyWith(fontSize: TypeRole.tiny, color: c.muted, height: 1.4)),
            ),
          ],
        ),
      ],
    );
  }
}
