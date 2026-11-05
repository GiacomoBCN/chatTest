import 'package:flutter/material.dart';
import '../l10n/strings.dart';
import '../models/demo.dart';
import '../theme/falak_theme.dart';
import 'marks.dart';

/// The demo's table of contents: what each example shows, and the way to run it.
class ExampleIndex extends StatelessWidget {
  final ValueChanged<Scenario> onRun;
  final Scenario? active;
  final bool enabled;
  final bool showIntro;

  const ExampleIndex({
    super.key,
    required this.onRun,
    this.active,
    this.enabled = true,
    this.showIntro = true,
  });

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final c = FalakColors.of(context);
    final t = Theme.of(context).textTheme;

    Widget groupLabel(String text) => Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(Space.xs, Space.l, Space.xs, Space.s),
          child: Text(text,
              style: t.bodyMedium!
                  .copyWith(fontSize: TypeRole.small, color: c.muted, fontWeight: FontWeight.w500)),
        );

    Widget row(Scenario sc, Widget mark, String title, String desc, {bool first = false}) =>
        _IndexRow(
          mark: mark,
          title: title,
          desc: desc,
          selected: active == sc,
          enabled: enabled,
          first: first,
          onTap: () => onRun(sc),
        );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (showIntro) ...[
          Semantics(
            header: true,
            child: Text(s.indexTitle,
                style: t.titleMedium!
                    .copyWith(fontSize: TypeRole.title, fontWeight: FontWeight.w600, height: 1.3)),
          ),
          const SizedBox(height: Space.xs + 2),
          Text(s.indexLead,
              style:
                  t.bodyMedium!.copyWith(fontSize: TypeRole.label, color: c.muted, height: 1.45)),
          const SizedBox(height: Space.xs),
        ],
        groupLabel(s.forCustomers),
        _Group(children: [
          row(Scenario.balance, const TrustMark(MarkKind.solid), s.exBalance, s.exBalanceDesc,
              first: true),
          row(Scenario.spending, const TrustMark(MarkKind.hatch), s.exSpending, s.exSpendingDesc),
          row(Scenario.loan, IconMark(Icons.person_outline, color: c.ink), s.exLoan, s.exLoanDesc),
        ]),
        groupLabel(s.forStaff),
        _Group(children: [
          row(Scenario.client, IconMark(Icons.check, color: c.staff), s.exClient, s.exClientDesc,
              first: true),
        ]),
        const SizedBox(height: Space.l),
        Text(s.indexFine,
            style: t.bodySmall!.copyWith(fontSize: TypeRole.tiny, color: c.muted, height: 1.4)),
      ],
    );
  }
}

class _Group extends StatelessWidget {
  final List<Widget> children;
  const _Group({required this.children});

  @override
  Widget build(BuildContext context) {
    final c = FalakColors.of(context);
    return Container(
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: BorderRadius.circular(Radii.group),
        border: Border.all(color: c.hair),
      ),
      clipBehavior: Clip.antiAlias,
      child: Material(
        type: MaterialType.transparency,
        child: Column(children: children),
      ),
    );
  }
}

class _IndexRow extends StatelessWidget {
  final Widget mark;
  final String title;
  final String desc;
  final bool selected;
  final bool enabled;
  final bool first;
  final VoidCallback onTap;

  const _IndexRow({
    required this.mark,
    required this.title,
    required this.desc,
    required this.selected,
    required this.enabled,
    required this.first,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final c = FalakColors.of(context);
    final t = Theme.of(context).textTheme;
    return Semantics(
      button: true,
      enabled: enabled,
      selected: selected,
      label: '$title. $desc',
      excludeSemantics: true,
      child: InkWell(
        onTap: enabled ? onTap : null,
        hoverColor: c.sunk,
        focusColor: c.ink.withOpacity(0.12),
        child: Container(
          decoration: BoxDecoration(
            color: selected ? c.sunk : null,
            border: first ? null : Border(top: BorderSide(color: c.hair)),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
          child: Opacity(
            opacity: enabled ? 1 : 0.55,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(padding: const EdgeInsets.only(top: 1), child: mark),
                const SizedBox(width: Space.m),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title,
                          style: t.bodyLarge!
                              .copyWith(fontSize: TypeRole.body, fontWeight: FontWeight.w500)),
                      const SizedBox(height: 1),
                      Text(desc,
                          style: t.bodyMedium!
                              .copyWith(fontSize: TypeRole.small, color: c.muted, height: 1.4)),
                    ],
                  ),
                ),
                const SizedBox(width: Space.s),
                Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: Icon(Icons.play_arrow_rounded,
                      size: 18, color: selected ? c.ink : c.hairStrong),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
