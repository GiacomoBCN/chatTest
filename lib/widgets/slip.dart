import 'package:flutter/material.dart';
import '../l10n/strings.dart';
import '../theme/falak_theme.dart';
import 'marks.dart';

/// An answer slip: one surface, sections divided by hairlines. No nested cards.
class Slip extends StatelessWidget {
  final List<Widget> sections;
  const Slip({super.key, required this.sections});

  @override
  Widget build(BuildContext context) {
    final c = FalakColors.of(context);
    final children = <Widget>[];
    for (var i = 0; i < sections.length; i++) {
      if (i > 0) children.add(Divider(height: 1, thickness: 1, color: c.hair));
      children.add(sections[i]);
    }
    return Container(
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: BorderRadius.circular(Radii.slip),
        border: Border.all(color: c.hair),
      ),
      clipBehavior: Clip.antiAlias,
      child: Material(
        type: MaterialType.transparency,
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: children),
      ),
    );
  }
}

class SlipSection extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  const SlipSection({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.symmetric(horizontal: Space.l, vertical: 14),
  });

  @override
  Widget build(BuildContext context) => Padding(padding: padding, child: child);
}

/// Label + large amount. The amount stays left-to-right inside Arabic text.
class AmountBlock extends StatelessWidget {
  final String label;
  final String amount;
  final bool approximate;
  final String? note;
  const AmountBlock({
    super.key,
    required this.label,
    required this.amount,
    this.approximate = false,
    this.note,
  });

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final c = FalakColors.of(context);
    final t = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: t.bodyMedium!.copyWith(fontSize: TypeRole.label, color: c.muted)),
        const SizedBox(height: 2),
        Semantics(
          label: '${approximate ? '≈ ' : ''}$amount ${s.currency}',
          excludeSemantics: true,
          child: Text.rich(
            TextSpan(children: [
              if (approximate)
                TextSpan(text: '≈ ', style: TextStyle(color: c.muted, fontWeight: FontWeight.w500)),
              TextSpan(text: ltr(amount)),
              TextSpan(
                text: '  ${s.currency}',
                style: TextStyle(
                    fontSize: TypeRole.body,
                    fontWeight: FontWeight.w500,
                    color: c.muted,
                    letterSpacing: 0),
              ),
            ]),
            style: t.headlineSmall!.copyWith(
              fontSize: TypeRole.amount,
              fontWeight: FontWeight.w600,
              letterSpacing: -0.5,
              height: 1.2,
              fontFeatures: tabular,
            ),
          ),
        ),
        if (note != null) ...[
          const SizedBox(height: Space.xs),
          Text(note!,
              style:
                  t.bodyMedium!.copyWith(fontSize: TypeRole.small, color: c.muted, height: 1.45)),
        ],
      ],
    );
  }
}

/// One line saying where a value came from, led by its trust mark.
class ProvenanceLine extends StatelessWidget {
  final Widget mark;
  final String strong;
  final String rest;
  const ProvenanceLine({super.key, required this.mark, required this.strong, required this.rest});

  @override
  Widget build(BuildContext context) {
    final c = FalakColors.of(context);
    final t = Theme.of(context).textTheme;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(padding: const EdgeInsets.only(top: 2), child: mark),
        const SizedBox(width: Space.s),
        Expanded(
          child: Text.rich(
            TextSpan(children: [
              TextSpan(text: strong, style: TextStyle(color: c.text, fontWeight: FontWeight.w500)),
              TextSpan(text: ' · $rest'),
            ]),
            style: t.bodyMedium!.copyWith(fontSize: TypeRole.small, color: c.muted, height: 1.4),
          ),
        ),
      ],
    );
  }
}

/// Inline text actions at the foot of a slip.
class SlipActions extends StatelessWidget {
  final List<String> labels;
  const SlipActions({super.key, required this.labels});

  @override
  Widget build(BuildContext context) {
    final c = FalakColors.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Space.s, vertical: Space.xs),
      child: Wrap(
        children: [
          for (final l in labels)
            TextButton(
              onPressed: () => notInDemo(context),
              style: TextButton.styleFrom(
                foregroundColor: c.ink,
                minimumSize: const Size(44, 44),
                padding: const EdgeInsets.symmetric(horizontal: Space.s),
                textStyle: labelStyle(weight: FontWeight.w500),
              ),
              child: Text(l),
            ),
        ],
      ),
    );
  }
}

void notInDemo(BuildContext context) => showToast(context, S.of(context).notInDemo);

/// Progressive disclosure: one line, opened on demand.
class WhySection extends StatefulWidget {
  final List<String> points;
  final List<bool>? warn;
  const WhySection({super.key, required this.points, this.warn});

  @override
  State<WhySection> createState() => _WhySectionState();
}

class _WhySectionState extends State<WhySection> {
  bool _open = false;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final c = FalakColors.of(context);
    final t = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Semantics(
          button: true,
          expanded: _open,
          child: RingInkWell(
            onTap: () => setState(() => _open = !_open),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: Space.l, vertical: Space.m),
              child: Row(
                children: [
                  Expanded(
                    child: Text(s.whyTitle,
                        style: t.bodyMedium!.copyWith(
                            fontSize: TypeRole.label, fontWeight: FontWeight.w500, color: c.ink)),
                  ),
                  AnimatedRotation(
                    turns: _open ? 0.5 : 0,
                    duration: Motion.fast(context),
                    child: Icon(Icons.expand_more, size: 20, color: c.ink),
                  ),
                ],
              ),
            ),
          ),
        ),
        AnimatedSize(
          duration: Motion.fast(context),
          curve: Curves.easeOutCubic,
          alignment: Alignment.topCenter,
          child: !_open
              ? const SizedBox(width: double.infinity)
              : Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(Space.l, 0, Space.l, Space.m),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      for (var i = 0; i < widget.points.length; i++)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: Space.xs),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 3),
                                child: TrustMark(
                                  (widget.warn?[i] ?? false) ? MarkKind.dots : MarkKind.solid,
                                  size: 12,
                                ),
                              ),
                              const SizedBox(width: Space.s + 2),
                              Expanded(
                                child: Text(widget.points[i],
                                    style: t.bodyMedium!.copyWith(
                                        fontSize: TypeRole.small, color: c.text, height: 1.45)),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
        ),
      ],
    );
  }
}

/// Steps shown while an answer is assembled; collapse once done.
class ProgressSteps extends StatelessWidget {
  final List<String> steps;
  final int done;
  const ProgressSteps({super.key, required this.steps, required this.done});

  @override
  Widget build(BuildContext context) {
    final c = FalakColors.of(context);
    final t = Theme.of(context).textTheme;
    return Semantics(
      liveRegion: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (var i = 0; i < steps.length; i++)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Row(
                children: [
                  SizedBox.square(
                    dimension: 16,
                    child: i < done
                        ? Icon(Icons.check, size: 16, color: c.ink)
                        : i == done
                            ? CircularProgressIndicator(strokeWidth: 1.6, color: c.ink)
                            : Icon(Icons.circle_outlined, size: 14, color: c.hairStrong),
                  ),
                  const SizedBox(width: Space.m - 2),
                  Expanded(
                    child: Text(steps[i],
                        style: t.bodyMedium!.copyWith(
                            fontSize: TypeRole.small,
                            color: i <= done ? c.text : c.muted,
                            height: 1.3)),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
