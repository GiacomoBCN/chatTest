import 'package:flutter/material.dart';
import '../l10n/strings.dart';
import '../models/demo.dart';
import '../theme/falak_theme.dart';
import 'client_review.dart';
import 'marks.dart';
import 'slip.dart';

/// Progress steps only where the assistant really consults several sources.
/// A balance read or a hand-off answers straight away.
List<String>? stepsFor(S s, Scenario sc) => switch (sc) {
      Scenario.spending => s.steps2,
      Scenario.client => s.steps4,
      Scenario.balance || Scenario.loan => null,
    };

/// Each step takes its own time; the last one resolves quickly.
List<int> stepDurations(Scenario sc) => switch (sc) {
      Scenario.spending => const [900, 750, 350],
      Scenario.client => const [800, 700, 350],
      _ => const [],
    };

String questionFor(S s, Scenario sc) => switch (sc) {
      Scenario.balance => s.q1,
      Scenario.spending => s.q2,
      Scenario.loan => s.q3,
      Scenario.client => s.q4,
    };

/// Renders one assistant answer for a scenario, in the current language.
class AnswerView extends StatelessWidget {
  final ChatEntry entry;
  final VoidCallback onStop;
  const AnswerView({super.key, required this.entry, required this.onStop});

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final c = FalakColors.of(context);
    final sc = entry.scenario!;
    if (entry.stopped) {
      return Slip(sections: [
        SlipSection(
          child: Text(s.stopped,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium!
                  .copyWith(fontSize: TypeRole.label, color: c.muted)),
        ),
      ]);
    }
    if (!entry.done) {
      return Slip(sections: [
        SlipSection(child: ProgressSteps(steps: stepsFor(s, sc)!, done: entry.stepsDone)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: Space.s, vertical: Space.xs),
          child: Align(
            alignment: AlignmentDirectional.centerStart,
            child: TextButton.icon(
              onPressed: onStop,
              icon: Icon(Icons.stop_circle_outlined, size: 18, color: c.text),
              label: Text(s.stop),
              style: TextButton.styleFrom(
                foregroundColor: c.text,
                minimumSize: const Size(44, 44),
                padding: const EdgeInsets.symmetric(horizontal: Space.s),
                textStyle: labelStyle(),
              ),
            ),
          ),
        ),
      ]);
    }
    return switch (sc) {
      Scenario.balance => const _Balance(),
      Scenario.spending => const _Spending(),
      Scenario.loan => const _Loan(),
      Scenario.client => const ClientReview(),
    };
  }
}

class _Balance extends StatelessWidget {
  const _Balance();

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return Slip(sections: [
      SlipSection(child: AmountBlock(label: s.currentAccount, amount: '45,230.50')),
      SlipSection(
        child: ProvenanceLine(
          mark: const TrustMark(MarkKind.solid, size: 14),
          strong: s.markSystem,
          rest: s.balanceSource,
        ),
      ),
      SlipActions(labels: [s.viewStatement, s.downloadPdf]),
      const FeedbackLine(),
    ]);
  }
}

class _Spending extends StatelessWidget {
  const _Spending();

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final c = FalakColors.of(context);
    final t = Theme.of(context).textTheme;

    Widget legend(MarkKind k, String label, String amount, {VoidCallback? onTap}) {
      final link = onTap != null;
      final row = Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(children: [
          TrustMark(k, size: 14),
          const SizedBox(width: Space.s + 2),
          Expanded(
            child: Text(label,
                style: t.bodyMedium!.copyWith(
                    fontSize: TypeRole.label,
                    color: link ? c.ink : c.text,
                    fontWeight: link ? FontWeight.w500 : FontWeight.w400)),
          ),
          Text(ltr(amount),
              style: t.bodyMedium!.copyWith(fontSize: TypeRole.label, fontFeatures: tabular)),
          if (link) ...[
            const SizedBox(width: Space.xs),
            Icon(Icons.chevron_right, size: 18, color: c.ink),
          ],
        ]),
      );
      if (!link) return row;
      return Semantics(
        button: true,
        child: RingInkWell(onTap: onTap, borderRadius: BorderRadius.circular(8), child: row),
      );
    }

    Widget source(String text) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 3),
          child: Text(text,
              style: t.bodyMedium!.copyWith(fontSize: TypeRole.small, color: c.muted, height: 1.4)),
        );

    return Slip(sections: [
      SlipSection(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AmountBlock(
              label: s.spendingTitle,
              amount: '42,700',
              approximate: true,
              note: s.spendingRange,
            ),
            const SizedBox(height: Space.m),
            const CertaintyStrip(parts: [
              (MarkKind.solid, 38445),
              (MarkKind.hatch, 4285),
              (MarkKind.dots, 2500),
            ]),
            const SizedBox(height: Space.s),
            legend(MarkKind.solid, s.confirmed, '38,445'),
            legend(MarkKind.hatch, s.estimatedLink, '4,285',
                onTap: () => _showItems(
                    context, s.estItemsTitle, s.estItemsLead, s.estItems, MarkKind.hatch)),
            legend(MarkKind.dots, s.unsyncedLink, '2,500',
                onTap: () => _showItems(
                    context, s.atmItemsTitle, s.atmItemsLead, s.atmItems, MarkKind.dots)),
          ],
        ),
      ),
      SlipSection(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(s.sourcesTitle,
                style:
                    t.bodyMedium!.copyWith(fontSize: TypeRole.label, fontWeight: FontWeight.w500)),
            const SizedBox(height: Space.xs),
            source(s.srcTx),
            source(s.srcCards),
            source(s.srcAtm),
          ],
        ),
      ),
      WhySection(points: s.why2, warn: s.why2Warn),
      const FeedbackLine(),
    ]);
  }
}

/// The items behind an estimate, so checking it costs one tap.
void _showItems(BuildContext context, String title, String lead,
    List<(String, String, String)> items, MarkKind mark) {
  final c = FalakColors.of(context);
  showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    backgroundColor: c.surface,
    constraints: const BoxConstraints(maxWidth: 480),
    shape:
        const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
    builder: (ctx) {
      final s = S.of(ctx);
      final t = Theme.of(ctx).textTheme;
      return SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(Space.l, 0, Space.l, Space.xl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(children: [
                TrustMark(mark, size: 18),
                const SizedBox(width: Space.s),
                Semantics(
                  header: true,
                  child: Text(title,
                      style: t.titleMedium!
                          .copyWith(fontSize: TypeRole.title, fontWeight: FontWeight.w600)),
                ),
              ]),
              const SizedBox(height: Space.s),
              Text(lead,
                  style: t.bodyMedium!
                      .copyWith(fontSize: TypeRole.label, color: c.muted, height: 1.45)),
              const SizedBox(height: Space.m),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(Radii.group),
                  border: Border.all(color: c.hair),
                ),
                child: Column(children: [
                  for (var i = 0; i < items.length; i++)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: Space.m),
                      decoration: BoxDecoration(
                        border: i == 0 ? null : Border(top: BorderSide(color: c.hair)),
                      ),
                      child: Row(children: [
                        Expanded(
                          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            Text(items[i].$1,
                                style: t.bodyLarge!.copyWith(fontSize: TypeRole.body)),
                            Text(items[i].$2,
                                style: t.bodyMedium!
                                    .copyWith(fontSize: TypeRole.small, color: c.muted)),
                          ]),
                        ),
                        Text('${ltr(items[i].$3)} ${s.currency}',
                            style: t.bodyLarge!
                                .copyWith(fontSize: TypeRole.body, fontFeatures: tabular)),
                      ]),
                    ),
                ]),
              ),
            ],
          ),
        ),
      );
    },
  );
}

/// Proportional strip drawn with the same print patterns as the marks.
class CertaintyStrip extends StatelessWidget {
  final List<(MarkKind, double)> parts;
  const CertaintyStrip({super.key, required this.parts});

  @override
  Widget build(BuildContext context) {
    final c = FalakColors.of(context);
    return ExcludeSemantics(
      child: SizedBox(
        height: 14,
        child: CustomPaint(
          painter: _StripPainter(parts, c.ink, Directionality.of(context)),
          size: Size.infinite,
        ),
      ),
    );
  }
}

class _StripPainter extends CustomPainter {
  final List<(MarkKind, double)> parts;
  final Color color;
  final TextDirection dir;
  _StripPainter(this.parts, this.color, this.dir);

  @override
  void paint(Canvas canvas, Size size) {
    final total = parts.fold<double>(0, (a, p) => a + p.$2);
    final outer = RRect.fromRectAndRadius(Offset.zero & size, const Radius.circular(4));
    canvas.save();
    canvas.clipRRect(outer);
    var x = 0.0;
    final edge = Paint()
      ..color = color
      ..strokeWidth = 1;
    for (var i = 0; i < parts.length; i++) {
      final w = size.width * parts[i].$2 / total;
      final left = dir == TextDirection.rtl ? size.width - x - w : x;
      final r = Rect.fromLTWH(left, 0, w, size.height);
      paintPattern(canvas, r, parts[i].$1, color);
      if (i > 0) {
        final ex = dir == TextDirection.rtl ? r.right : r.left;
        canvas.drawLine(Offset(ex, 0), Offset(ex, size.height), edge);
      }
      x += w;
    }
    canvas.restore();
    canvas.drawRRect(
        outer.deflate(0.5),
        Paint()
          ..color = color
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1);
  }

  @override
  bool shouldRepaint(_StripPainter old) => old.color != color || old.dir != dir;
}

class _Loan extends StatelessWidget {
  const _Loan();

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final c = FalakColors.of(context);
    final t = Theme.of(context).textTheme;
    return Slip(sections: [
      SlipSection(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          ProvenanceLine(
            mark: IconMark(Icons.person_outline, color: c.ink, size: 16),
            strong: s.markPerson,
            rest: s.exLoan,
          ),
          const SizedBox(height: Space.m - 2),
          Text(s.loanAnswer, style: t.bodyLarge!.copyWith(fontSize: TypeRole.body, height: 1.5)),
        ]),
      ),
      ...handoffOptions(context),
      SlipActions(labels: [s.loanProducts, s.loanCalculator]),
      const FeedbackLine(),
    ]);
  }
}

/// The ways to reach a person: shared by the loan answer and "Talk to a person".
List<Widget> handoffOptions(BuildContext context) {
  final s = S.of(context);
  final c = FalakColors.of(context);
  final t = Theme.of(context).textTheme;

  Widget option(IconData icon, String title, String meta) => Semantics(
        button: true,
        child: RingInkWell(
          onTap: () => notInDemo(context),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: Space.l, vertical: Space.m),
            child: Row(children: [
              Icon(icon, size: 20, color: c.ink),
              const SizedBox(width: Space.m),
              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(title,
                      style: t.bodyLarge!.copyWith(
                          fontSize: TypeRole.body, fontWeight: FontWeight.w500, color: c.ink)),
                  Text(meta,
                      style: t.bodyMedium!.copyWith(fontSize: TypeRole.small, color: c.muted)),
                ]),
              ),
              Icon(Icons.chevron_right, size: 20, color: c.hairStrong),
            ]),
          ),
        ),
      );

  return [
    option(Icons.chat_bubble_outline, s.chatAdvisor, s.chatAdvisorMeta),
    option(Icons.call_outlined, s.bookCall, s.bookCallMeta),
    SlipSection(
      child: Text(s.handoffShare,
          style: t.bodyMedium!.copyWith(fontSize: TypeRole.small, color: c.muted, height: 1.45)),
    ),
  ];
}

/// Answer to "Talk to a person", available at any time from the header.
class PersonAnswer extends StatelessWidget {
  const PersonAnswer({super.key});

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final t = Theme.of(context).textTheme;
    return Slip(sections: [
      SlipSection(
        child: Text(s.personAnswer,
            style: t.bodyLarge!.copyWith(fontSize: TypeRole.body, height: 1.5)),
      ),
      ...handoffOptions(context),
    ]);
  }
}
