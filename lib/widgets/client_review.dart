import 'package:flutter/material.dart';
import '../l10n/strings.dart';
import '../theme/falak_theme.dart';
import 'marks.dart';
import 'slip.dart';

enum _Read { yes, no, notSure }

enum _Decision { approve, decline }

/// Staff example: the relationship manager forms their own view first,
/// then sees the AI's suggestion and evidence, checks specific points,
/// gives a reason either way, and gets a receipt of what was logged.
class ClientReview extends StatefulWidget {
  const ClientReview({super.key});

  @override
  State<ClientReview> createState() => _ClientReviewState();
}

class _ClientReviewState extends State<ClientReview> {
  _Read? _read;
  final _checks = [false, false, false];
  _Decision? _decision;
  int? _reason;
  DateTime? _signedAt;
  final _revealKey = GlobalKey();
  final _receiptKey = GlobalKey();

  /// Bring newly revealed content into view.
  void _reveal(GlobalKey key) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final ctx = key.currentContext;
      if (ctx == null) return;
      Scrollable.ensureVisible(ctx,
          duration: Motion.enter(context), curve: Curves.easeOutCubic, alignment: 0.05);
    });
  }

  bool get _canSign {
    if (_decision == null || _reason == null) return false;
    if (_decision == _Decision.approve) return _checks.every((c) => c);
    return true;
  }

  String _readLabel(S s, _Read r) => switch (r) {
        _Read.yes => s.yes,
        _Read.no => s.no,
        _Read.notSure => s.notSure,
      };

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final c = FalakColors.of(context);
    final t = Theme.of(context).textTheme;

    Widget fact(String k, String v) => Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(k, style: t.bodySmall!.copyWith(fontSize: TypeRole.tiny, color: c.muted)),
            const SizedBox(height: 2),
            Text(v,
                style:
                    t.bodyMedium!.copyWith(fontSize: TypeRole.label, fontWeight: FontWeight.w500)),
          ]),
        );

    Widget heading(String text) => Semantics(
          header: true,
          child: Text(text,
              style: t.titleMedium!.copyWith(fontSize: TypeRole.body, fontWeight: FontWeight.w600)),
        );

    final sections = <Widget>[
      // Role band
      Container(
        color: c.staffSoft,
        padding: const EdgeInsets.symmetric(horizontal: Space.l, vertical: Space.s + 2),
        child: Row(children: [
          IconMark(Icons.badge_outlined, color: c.staff, size: 18),
          const SizedBox(width: Space.s),
          Text(s.staffView,
              style: t.bodyMedium!
                  .copyWith(fontSize: TypeRole.small, color: c.staff, fontWeight: FontWeight.w600)),
        ]),
      ),
      // The client: data only, no suggestion yet
      SlipSection(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(s.clientLabel,
              style: t.bodyMedium!.copyWith(fontSize: TypeRole.label, color: c.muted)),
          const SizedBox(height: 2),
          Text(s.clientName,
              style: t.titleMedium!.copyWith(
                  fontSize: TypeRole.title + 2, fontWeight: FontWeight.w600, height: 1.3)),
          const SizedBox(height: Space.m),
          Row(children: [fact(s.segment, s.segmentValue), fact(s.clientSince, s.clientSinceValue)]),
          const SizedBox(height: Space.m),
          Row(children: [
            fact(s.lastContact, s.lastContactValue),
            fact(s.debtToIncome, s.debtToIncomeValue)
          ]),
        ]),
      ),
    ];

    if (_read == null) {
      sections.add(SlipSection(
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          heading(s.firstReadTitle),
          const SizedBox(height: Space.xs),
          Text(s.firstReadQ, style: t.bodyMedium!.copyWith(fontSize: TypeRole.label, height: 1.45)),
          const SizedBox(height: Space.m),
          _Choice<_Read>(
            values: _Read.values,
            selected: null,
            label: (r) => _readLabel(s, r),
            onChanged: (r) {
              setState(() => _read = r);
              _reveal(_revealKey);
            },
          ),
        ]),
      ));
      return Slip(sections: sections);
    }

    // The AI suggestion, revealed after the first read
    sections.add(SlipSection(
      key: _revealKey,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(s.recommended,
            style: t.bodyMedium!.copyWith(fontSize: TypeRole.label, color: c.muted)),
        const SizedBox(height: 2),
        Text(s.rmAction,
            style: t.titleMedium!
                .copyWith(fontSize: TypeRole.title, fontWeight: FontWeight.w600, height: 1.35)),
        const SizedBox(height: Space.s),
        Text('${s.yourRead}: ${_readLabel(s, _read!)}',
            style: t.bodyMedium!.copyWith(fontSize: TypeRole.small, color: c.muted)),
      ]),
    ));
    sections.add(SlipSection(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(s.evidenceTitle,
            style: t.bodyMedium!.copyWith(fontSize: TypeRole.label, fontWeight: FontWeight.w500)),
        const SizedBox(height: Space.s),
        _Evidence(mark: MarkKind.solid, title: s.evSalary, meta: s.evSalaryMeta),
        _Evidence(mark: MarkKind.solid, title: s.evSavings, meta: s.evSavingsMeta),
        _Evidence(mark: MarkKind.dots, title: s.evMarried, meta: s.evMarriedMeta),
      ]),
    ));

    if (_signedAt != null) {
      sections.add(_receipt(context));
      return Slip(sections: sections);
    }

    final reasons = _decision == _Decision.decline ? s.declineReasons : s.approveReasons;
    sections.add(SlipSection(
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        heading(s.checksTitle),
        const SizedBox(height: Space.xs),
        for (var i = 0; i < 3; i++)
          _CheckRow(
            value: _checks[i],
            label: [s.check1, s.check2, s.check3][i],
            onChanged: (v) => setState(() => _checks[i] = v),
          ),
        const SizedBox(height: Space.m),
        heading(s.decisionTitle),
        const SizedBox(height: Space.s),
        _Choice<_Decision>(
          values: _Decision.values,
          selected: _decision,
          label: (d) => d == _Decision.approve ? s.approve : s.decline,
          accent: (d) => d == _Decision.decline ? c.danger : null,
          onChanged: (d) => setState(() {
            if (d != _decision) _reason = null;
            _decision = d;
          }),
        ),
        if (_decision != null) ...[
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
                hint:
                    Text(s.reasonHint, style: TextStyle(fontSize: TypeRole.label, color: c.muted)),
                icon: Icon(Icons.expand_more, color: c.muted),
                items: [
                  for (var i = 0; i < reasons.length; i++)
                    DropdownMenuItem(
                      value: i,
                      child: Text(reasons[i],
                          style: TextStyle(fontSize: TypeRole.label, color: c.text)),
                    ),
                ],
                onChanged: (v) => setState(() => _reason = v),
              ),
            ),
          ),
        ],
        if (_decision == _Decision.approve && !_checks.every((x) => x)) ...[
          const SizedBox(height: Space.s),
          Text(s.checksNeeded,
              style: t.bodySmall!.copyWith(fontSize: TypeRole.small, color: c.muted)),
        ],
        const SizedBox(height: Space.m),
        FilledButton(
          onPressed: _canSign
              ? () {
                  setState(() => _signedAt = DateTime.now());
                  _reveal(_receiptKey);
                }
              : null,
          style: FilledButton.styleFrom(
            backgroundColor: _decision == _Decision.decline ? c.danger : c.staff,
            foregroundColor: c.surface,
            disabledBackgroundColor: c.sunk,
            disabledForegroundColor: c.muted,
            minimumSize: const Size(0, 46),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Radii.control)),
            textStyle: labelStyle(weight: FontWeight.w600),
          ),
          child: Text(s.signOff),
        ),
        const SizedBox(height: Space.m),
        Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Icon(Icons.history, size: 16, color: c.muted),
          const SizedBox(width: Space.s),
          Expanded(
            child: Text(s.sampledNote,
                style: t.bodySmall!.copyWith(fontSize: TypeRole.tiny, color: c.muted, height: 1.4)),
          ),
        ]),
      ]),
    ));
    return Slip(sections: sections);
  }

  Widget _receipt(BuildContext context) {
    final s = S.of(context);
    final c = FalakColors.of(context);
    final t = Theme.of(context).textTheme;
    final reasons = _decision == _Decision.decline ? s.declineReasons : s.approveReasons;
    String two(int n) => n.toString().padLeft(2, '0');
    final time = '${two(_signedAt!.hour)}:${two(_signedAt!.minute)}';

    Widget row(String k, String v, {Color? color}) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            SizedBox(
              width: 120,
              child:
                  Text(k, style: t.bodyMedium!.copyWith(fontSize: TypeRole.small, color: c.muted)),
            ),
            Expanded(
              child: Text(v,
                  style: t.bodyMedium!.copyWith(
                      fontSize: TypeRole.small,
                      fontFeatures: tabular,
                      color: color,
                      fontWeight: color != null ? FontWeight.w600 : null)),
            ),
          ]),
        );

    return Semantics(
      key: _receiptKey,
      liveRegion: true,
      child: Container(
        color: c.sunk,
        padding: const EdgeInsets.fromLTRB(Space.l, 14, Space.l, Space.l),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Icon(Icons.verified_outlined, size: 18, color: c.staff),
            const SizedBox(width: Space.s),
            Semantics(
              header: true,
              child: Text(s.receiptTitle,
                  style: t.titleMedium!
                      .copyWith(fontSize: TypeRole.body, fontWeight: FontWeight.w600)),
            ),
          ]),
          const SizedBox(height: Space.s),
          row(s.rDecision, _decision == _Decision.approve ? s.rApproved : s.rDeclined,
              color: _decision == _Decision.decline ? c.danger : null),
          row(s.rReason, reasons[_reason!]),
          row(s.rFirstRead, _readLabel(s, _read!)),
          row(s.rBy, s.rByValue),
          row(s.rTime, ltr(time)),
          row(s.rModel, ltr('falak-assist 0.3 (demo)')),
          row(s.rSession, ltr('FLK-2026-1105-4521')),
        ]),
      ),
    );
  }
}

class _Evidence extends StatelessWidget {
  final MarkKind mark;
  final String title;
  final String meta;
  const _Evidence({required this.mark, required this.title, required this.meta});

  @override
  Widget build(BuildContext context) {
    final c = FalakColors.of(context);
    final t = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Padding(padding: const EdgeInsets.only(top: 3), child: TrustMark(mark, size: 14)),
        const SizedBox(width: Space.s + 2),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title, style: t.bodyMedium!.copyWith(fontSize: TypeRole.label)),
            Text(meta,
                style:
                    t.bodySmall!.copyWith(fontSize: TypeRole.small, color: c.muted, height: 1.4)),
          ]),
        ),
      ]),
    );
  }
}

class _CheckRow extends StatelessWidget {
  final bool value;
  final String label;
  final ValueChanged<bool> onChanged;
  const _CheckRow({required this.value, required this.label, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final c = FalakColors.of(context);
    final t = Theme.of(context).textTheme;
    return MergeSemantics(
      child: RingInkWell(
        borderRadius: BorderRadius.circular(Radii.control),
        onTap: () => onChanged(!value),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: Space.xs),
          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            SizedBox(
              width: 28,
              height: 28,
              child: Checkbox(
                value: value,
                activeColor: c.staff,
                onChanged: (v) => onChanged(v ?? false),
              ),
            ),
            const SizedBox(width: Space.s),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(label,
                    style: t.bodyMedium!.copyWith(fontSize: TypeRole.label, height: 1.4)),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}

/// Equal-weight options in a row; the selected one fills with the staff colour.
class _Choice<T> extends StatelessWidget {
  final List<T> values;
  final T? selected;
  final String Function(T) label;
  final ValueChanged<T> onChanged;
  final Color? Function(T)? accent; // per-option colour, e.g. red for Decline
  const _Choice({
    required this.values,
    required this.selected,
    required this.label,
    required this.onChanged,
    this.accent,
  });

  @override
  Widget build(BuildContext context) {
    final c = FalakColors.of(context);
    return Row(children: [
      for (var i = 0; i < values.length; i++) ...[
        if (i > 0) const SizedBox(width: Space.s),
        Expanded(
          child: Semantics(
            selected: values[i] == selected,
            child: OutlinedButton(
              onPressed: () => onChanged(values[i]),
              style: OutlinedButton.styleFrom(
                foregroundColor:
                    values[i] == selected ? c.surface : (accent?.call(values[i]) ?? c.text),
                backgroundColor:
                    values[i] == selected ? (accent?.call(values[i]) ?? c.staff) : null,
                minimumSize: const Size(0, 44),
                padding: const EdgeInsets.symmetric(horizontal: Space.s),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Radii.control)),
                textStyle: labelStyle(weight: FontWeight.w500),
              ).copyWith(
                side: focusSide(
                    c.text,
                    BorderSide(
                        color: values[i] == selected
                            ? (accent?.call(values[i]) ?? c.staff)
                            : (accent?.call(values[i]) ?? c.hairStrong))),
              ),
              child: Text(label(values[i]), maxLines: 1, overflow: TextOverflow.ellipsis),
            ),
          ),
        ),
      ],
    ]);
  }
}
