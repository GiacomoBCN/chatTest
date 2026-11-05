import 'package:flutter/material.dart';
import '../l10n/strings.dart';
import '../models/demo.dart';
import '../theme/falak_theme.dart';
import 'checkpoint.dart';
import 'marks.dart';
import 'slip.dart';

List<String> stepsFor(S s, Scenario sc) => switch (sc) {
      Scenario.balance => s.steps1,
      Scenario.spending => s.steps2,
      Scenario.loan => s.steps3,
      Scenario.client => s.steps4,
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
  const AnswerView({super.key, required this.entry});

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final sc = entry.scenario!;
    if (!entry.done) {
      return Slip(sections: [
        SlipSection(child: ProgressSteps(steps: stepsFor(s, sc), done: entry.stepsDone)),
      ]);
    }
    return switch (sc) {
      Scenario.balance => const _Balance(),
      Scenario.spending => const _Spending(),
      Scenario.loan => const _Loan(),
      Scenario.client => const _Client(),
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

    Widget legend(MarkKind k, String label, String amount, {bool link = false}) {
      final text = Text(label,
          style: t.bodyMedium!.copyWith(
              fontSize: TypeRole.label,
              color: link ? c.ink : c.text,
              fontWeight: link ? FontWeight.w500 : FontWeight.w400));
      return InkWell(
        onTap: link ? () => notInDemo(context) : null,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Row(children: [
            TrustMark(k, size: 14),
            const SizedBox(width: Space.s + 2),
            Expanded(child: text),
            Text(ltr(amount),
                style: t.bodyMedium!.copyWith(fontSize: TypeRole.label, fontFeatures: tabular)),
          ]),
        ),
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
            legend(MarkKind.hatch, s.estimatedLink, '4,285', link: true),
            legend(MarkKind.dots, s.unsyncedLink, '2,500', link: true),
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
      SlipActions(labels: [s.reportIssue]),
    ]);
  }
}

/// Proportional strip drawn with the same print patterns as the marks.
class CertaintyStrip extends StatelessWidget {
  final List<(MarkKind, double)> parts;
  const CertaintyStrip({super.key, required this.parts});

  @override
  Widget build(BuildContext context) {
    final c = FalakColors.of(context);
    return ExcludeSemantics(
      child: Directionality(
        textDirection: Directionality.of(context),
        child: SizedBox(
          height: 14,
          child: CustomPaint(
            painter: _StripPainter(parts, c.ink, Directionality.of(context)),
            size: Size.infinite,
          ),
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

    Widget option(IconData icon, String title, String meta) => InkWell(
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
        );

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
      option(Icons.chat_bubble_outline, s.chatAdvisor, s.chatAdvisorMeta),
      option(Icons.call_outlined, s.bookCall, s.bookCallMeta),
      SlipSection(
        child: Text(s.handoffShare,
            style: t.bodyMedium!.copyWith(fontSize: TypeRole.small, color: c.muted, height: 1.45)),
      ),
      SlipActions(labels: [s.loanProducts, s.loanCalculator]),
    ]);
  }
}

class _Client extends StatelessWidget {
  const _Client();

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

    return Slip(sections: [
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
      SlipSection(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(s.recommended,
              style: t.bodyMedium!.copyWith(fontSize: TypeRole.label, color: c.muted)),
          const SizedBox(height: 2),
          Text(s.rmAction,
              style: t.titleMedium!.copyWith(
                  fontSize: TypeRole.title + 2, fontWeight: FontWeight.w600, height: 1.3)),
        ]),
      ),
      SlipSection(
        child: Column(children: [
          Row(children: [fact(s.segment, s.segmentValue), fact(s.clientSince, s.clientSinceValue)]),
          const SizedBox(height: Space.m),
          Row(children: [fact(s.lastContact, s.lastContactValue), fact(s.risk, s.riskValue)]),
        ]),
      ),
      WhySection(points: s.why4),
      const SlipSection(child: Checkpoint()),
    ]);
  }
}
