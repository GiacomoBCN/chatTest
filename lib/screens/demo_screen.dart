import 'package:flutter/material.dart';
import '../app_scope.dart';
import '../l10n/strings.dart';
import '../models/demo.dart';
import '../theme/falak_theme.dart';
import '../widgets/answers.dart';
import '../widgets/engraving.dart';
import '../widgets/example_index.dart';
import '../widgets/slip.dart';

const _wideBreakpoint = 900.0;

class DemoScreen extends StatefulWidget {
  const DemoScreen({super.key});

  @override
  State<DemoScreen> createState() => _DemoScreenState();
}

class _DemoScreenState extends State<DemoScreen> {
  final _input = TextEditingController();
  final _scroll = ScrollController();
  final List<ChatEntry> _entries = [];
  int _nextId = 0;
  int _run = 0; // bumps on restart so pending timers stop writing
  bool _busy = false;
  Scenario? _active;

  @override
  void dispose() {
    _input.dispose();
    _scroll.dispose();
    super.dispose();
  }

  void _toBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scroll.hasClients) return;
      final d = Motion.enter(context);
      if (d == Duration.zero) {
        _scroll.jumpTo(_scroll.position.maxScrollExtent);
      } else {
        _scroll.animateTo(_scroll.position.maxScrollExtent,
            duration: d, curve: Curves.easeOutCubic);
      }
    });
  }

  void _replace(int id, ChatEntry Function(ChatEntry) f) {
    final i = _entries.indexWhere((e) => e.id == id);
    if (i != -1) _entries[i] = f(_entries[i]);
  }

  Future<void> _runScenario(Scenario sc) async {
    if (_busy) return;
    final run = _run;
    final steps = stepsFor(S.of(context), sc);
    final answerId = _nextId + 1;
    setState(() {
      _active = sc;
      _entries.add(ChatEntry(id: _nextId++, kind: EntryKind.question, scenario: sc));
      _entries
          .add(ChatEntry(id: _nextId++, kind: EntryKind.answer, scenario: sc, done: steps == null));
      _busy = steps != null;
    });
    _toBottom();
    if (steps == null) return; // a direct read answers straight away
    final durations = stepDurations(sc);
    for (var i = 0; i < steps.length; i++) {
      await Future.delayed(Duration(milliseconds: durations[i]));
      if (!mounted || run != _run || _isStopped(answerId)) return;
      setState(() => _replace(answerId, (e) => e.copyWith(stepsDone: i + 1)));
    }
    if (!mounted || run != _run || _isStopped(answerId)) return;
    setState(() {
      _replace(answerId, (e) => e.copyWith(done: true));
      _busy = false;
    });
    _toBottom();
  }

  bool _isStopped(int id) => _entries.any((e) => e.id == id && e.stopped);

  void _stop(int id) {
    setState(() {
      _replace(id, (e) => e.copyWith(stopped: true));
      _busy = false;
    });
  }

  void _talkToPerson() {
    if (_busy) return;
    setState(() {
      _active = null;
      _entries.add(ChatEntry(id: _nextId++, kind: EntryKind.personQuestion));
      _entries.add(ChatEntry(id: _nextId++, kind: EntryKind.personAnswer));
    });
    _toBottom();
  }

  void _send() {
    final text = _input.text.trim();
    if (text.isEmpty || _busy) return;
    final run = _run;
    setState(() {
      _entries.add(ChatEntry(id: _nextId++, kind: EntryKind.freeText, text: text));
      _busy = true;
    });
    _input.clear();
    _toBottom();
    Future.delayed(const Duration(milliseconds: 400), () {
      if (!mounted || run != _run) return;
      setState(() {
        _entries.add(ChatEntry(id: _nextId++, kind: EntryKind.fallback));
        _busy = false;
      });
      _toBottom();
    });
  }

  void _restart() {
    setState(() {
      _run++;
      _entries.clear();
      _busy = false;
      _active = null;
    });
  }

  void _openExamples() {
    final c = FalakColors.of(context);
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      backgroundColor: c.surface,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (sheetContext) => SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(Space.l, 0, Space.l, Space.xl),
          child: ExampleIndex(
            active: _active,
            enabled: !_busy,
            onRun: (sc) {
              Navigator.of(sheetContext).pop();
              _runScenario(sc);
            },
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final c = FalakColors.of(context);
    return Scaffold(
      backgroundColor: c.ground,
      body: LayoutBuilder(builder: (context, box) {
        final wide = box.maxWidth >= _wideBreakpoint;
        if (!wide) {
          return ColoredBox(
            color: c.surface,
            child: SafeArea(child: _device(wide: false)),
          );
        }
        final deviceHeight = (box.maxHeight - 64).clamp(560.0, 880.0);
        return Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: Space.xl, vertical: Space.xxl),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 300,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: Space.xs),
                      _brand(large: true),
                      const SizedBox(height: Space.xl),
                      ExampleIndex(active: _active, enabled: !_busy, onRun: _runScenario),
                    ],
                  ),
                ),
                const SizedBox(width: Space.xxl),
                Container(
                  width: 430,
                  height: deviceHeight,
                  decoration: BoxDecoration(
                    color: c.surface,
                    borderRadius: BorderRadius.circular(Radii.device),
                    border: Border.all(color: c.hair),
                    boxShadow: [
                      BoxShadow(
                          color:
                              Colors.black.withOpacity(AppScope.of(context).isDark ? 0.35 : 0.06),
                          blurRadius: 24,
                          offset: const Offset(0, 8)),
                    ],
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: _device(wide: true),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _brand({required bool large}) {
    final s = S.of(context);
    final c = FalakColors.of(context);
    final t = Theme.of(context).textTheme;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        FalakEmblem(size: large ? 44 : 34),
        const SizedBox(width: Space.m - 2),
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(s.bank,
                  style: t.titleLarge!.copyWith(
                      fontSize: large ? 20 : TypeRole.title,
                      fontWeight: FontWeight.w600,
                      height: 1.2)),
              Text(large ? s.bankTagline : s.assistant,
                  maxLines: large ? 2 : 1,
                  overflow: TextOverflow.ellipsis,
                  style: t.bodySmall!
                      .copyWith(fontSize: large ? TypeRole.small : TypeRole.tiny, color: c.muted)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _device({required bool wide}) {
    final c = FalakColors.of(context);
    return Column(
      children: [
        _header(),
        Divider(height: 1, thickness: 1, color: c.hair),
        Expanded(child: _feed()),
        Divider(height: 1, thickness: 1, color: c.hair),
        _dock(showExamples: !wide),
      ],
    );
  }

  Widget _header() {
    final s = S.of(context);
    final scope = AppScope.of(context);
    final c = FalakColors.of(context);
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(Space.l, Space.m, Space.m, Space.m),
      child: Row(
        children: [
          Expanded(
            child: LayoutBuilder(
              builder: (context, box) => Align(
                alignment: AlignmentDirectional.centerStart,
                // On narrow phones the emblem alone carries the brand.
                child: box.maxWidth < 96
                    ? Semantics(label: s.bank, child: const FalakEmblem(size: 34))
                    : _brand(large: false),
              ),
            ),
          ),
          _LanguageSwitch(isArabic: scope.isArabic, onChanged: scope.setArabic),
          const SizedBox(width: Space.s),
          _HeaderButton(
            icon: scope.isDark ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
            tooltip: scope.isDark ? s.switchToLight : s.switchToDark,
            onPressed: scope.toggleTheme,
          ),
          const SizedBox(width: Space.s),
          _HeaderButton(
              icon: Icons.support_agent_outlined,
              tooltip: s.talkToPerson,
              onPressed: _talkToPerson),
          if (_entries.isNotEmpty) ...[
            const SizedBox(width: Space.s),
            _HeaderButton(icon: Icons.refresh, tooltip: s.restart, onPressed: _restart),
          ],
        ],
      ),
    ).withColor(c.surface);
  }

  Widget _feed() {
    return ListView(
      controller: _scroll,
      padding: const EdgeInsets.fromLTRB(Space.l, Space.l + 2, Space.l, Space.xl),
      children: [
        const _Disclosure(),
        for (final e in _entries)
          Padding(
            padding: const EdgeInsets.only(top: Space.m + 2),
            child: _EnterTransition(key: ValueKey(e.id), child: _entryView(e)),
          ),
      ],
    );
  }

  Widget _entryView(ChatEntry e) {
    final s = S.of(context);
    switch (e.kind) {
      case EntryKind.question:
        return _UserBubble(text: questionFor(s, e.scenario!));
      case EntryKind.freeText:
        return _UserBubble(text: e.text!);
      case EntryKind.answer:
        return _AssistantRow(child: AnswerView(entry: e, onStop: () => _stop(e.id)));
      case EntryKind.personQuestion:
        return _UserBubble(text: s.qPerson);
      case EntryKind.personAnswer:
        return const _AssistantRow(child: PersonAnswer());
      case EntryKind.fallback:
        return _AssistantRow(
          child: Slip(sections: [
            SlipSection(
              child: Text(s.fallback,
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge!
                      .copyWith(fontSize: TypeRole.body, height: 1.5)),
            ),
          ]),
        );
    }
  }

  Widget _dock({required bool showExamples}) {
    final s = S.of(context);
    final c = FalakColors.of(context);
    final t = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(Space.m, Space.s + 2, Space.m, Space.l),
      child: Row(
        children: [
          if (showExamples) ...[
            OutlinedButton.icon(
              onPressed: _openExamples,
              icon: Icon(Icons.format_list_bulleted, size: 18, color: c.text),
              label: Text(s.examples),
              style: OutlinedButton.styleFrom(
                foregroundColor: c.text,
                minimumSize: const Size(0, 46),
                padding: const EdgeInsets.symmetric(horizontal: Space.m),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Radii.control)),
                textStyle: labelStyle(weight: FontWeight.w500),
              ).copyWith(side: focusSide(c.text, BorderSide(color: c.hairStrong))),
            ),
            const SizedBox(width: Space.s),
          ],
          Expanded(
            child: TextField(
              controller: _input,
              textInputAction: TextInputAction.send,
              onSubmitted: (_) => _send(),
              style: t.bodyLarge!.copyWith(fontSize: TypeRole.body),
              cursorColor: c.ink,
              decoration: InputDecoration(
                hintText: s.askPlaceholder,
                hintStyle: TextStyle(color: c.muted, fontSize: TypeRole.body),
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
                filled: true,
                fillColor: c.surface,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(Radii.control),
                  borderSide: BorderSide(color: c.hairStrong),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(Radii.control),
                  borderSide: BorderSide(color: c.ink, width: 1.6),
                ),
              ),
            ),
          ),
          const SizedBox(width: Space.s),
          Tooltip(
            message: s.send,
            child: SizedBox.square(
              dimension: 46,
              child: FilledButton(
                onPressed: _busy ? null : _send,
                style: FilledButton.styleFrom(
                  padding: EdgeInsets.zero,
                  backgroundColor: c.ink,
                  foregroundColor: c.onInk,
                  disabledBackgroundColor: c.sunk,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Radii.control)),
                ),
                child: Icon(Icons.arrow_forward, size: 20, semanticLabel: s.send),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

extension on Widget {
  Widget withColor(Color color) => ColoredBox(color: color, child: this);
}

class _Disclosure extends StatelessWidget {
  const _Disclosure();

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final c = FalakColors.of(context);
    final t = Theme.of(context).textTheme;
    return Container(
      decoration: BoxDecoration(
        color: c.sunk,
        borderRadius: BorderRadius.circular(Radii.group),
        border: Border.all(color: c.hair),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          const PositionedDirectional(end: -44, top: -50, child: Guilloche(size: 220)),
          Padding(
            padding: const EdgeInsets.all(Space.l),
            child: FractionallySizedBox(
              widthFactor: 0.78,
              alignment: AlignmentDirectional.centerStart,
              child: Text.rich(
                TextSpan(children: [
                  TextSpan(
                      text: '${s.discTitle} ',
                      style: TextStyle(color: c.text, fontWeight: FontWeight.w600)),
                  TextSpan(text: s.discBody),
                ]),
                style:
                    t.bodyMedium!.copyWith(fontSize: TypeRole.label, color: c.muted, height: 1.5),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _UserBubble extends StatelessWidget {
  final String text;
  const _UserBubble({required this.text});

  @override
  Widget build(BuildContext context) {
    final c = FalakColors.of(context);
    final t = Theme.of(context).textTheme;
    return Align(
      alignment: AlignmentDirectional.centerEnd,
      child: LayoutBuilder(builder: (context, box) {
        return ConstrainedBox(
          constraints: BoxConstraints(maxWidth: box.maxWidth * 0.8),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: c.userBubble,
              borderRadius: const BorderRadiusDirectional.only(
                topStart: Radius.circular(18),
                topEnd: Radius.circular(18),
                bottomStart: Radius.circular(18),
                bottomEnd: Radius.circular(6),
              ),
            ),
            child: Text(text,
                style: t.bodyLarge!
                    .copyWith(fontSize: TypeRole.body, color: c.onUserBubble, height: 1.4)),
          ),
        );
      }),
    );
  }
}

class _AssistantRow extends StatelessWidget {
  final Widget child;
  const _AssistantRow({required this.child});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: AlignmentDirectional.centerStart,
      child: LayoutBuilder(builder: (context, box) {
        return ConstrainedBox(
          constraints:
              BoxConstraints(maxWidth: box.maxWidth >= 360 ? box.maxWidth * 0.94 : box.maxWidth),
          child: child,
        );
      }),
    );
  }
}

/// One entrance for new messages: a short fade and rise.
class _EnterTransition extends StatefulWidget {
  final Widget child;
  const _EnterTransition({super.key, required this.child});

  @override
  State<_EnterTransition> createState() => _EnterTransitionState();
}

class _EnterTransitionState extends State<_EnterTransition> with SingleTickerProviderStateMixin {
  late final AnimationController _c;

  @override
  void initState() {
    super.initState();
    _c = AnimationController(vsync: this);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_c.status == AnimationStatus.dismissed) {
      _c.duration = Motion.enter(context);
      _c.forward();
    }
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final a = CurvedAnimation(parent: _c, curve: Curves.easeOutCubic);
    return FadeTransition(
      opacity: a,
      child: SlideTransition(
        position: Tween(begin: const Offset(0, 0.06), end: Offset.zero).animate(a),
        child: widget.child,
      ),
    );
  }
}

class _HeaderButton extends StatelessWidget {
  final IconData icon;
  final String tooltip;
  final VoidCallback onPressed;
  const _HeaderButton({required this.icon, required this.tooltip, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final c = FalakColors.of(context);
    return IconButton(
      onPressed: onPressed,
      tooltip: tooltip,
      icon: Icon(icon, size: 20),
      style: IconButton.styleFrom(
        foregroundColor: c.text,
        fixedSize: const Size(40, 40),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Radii.control - 2),
        ),
      ).copyWith(side: focusSide(c.text, BorderSide(color: c.hairStrong))),
    );
  }
}

class _LanguageSwitch extends StatelessWidget {
  final bool isArabic;
  final ValueChanged<bool> onChanged;
  const _LanguageSwitch({required this.isArabic, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final c = FalakColors.of(context);

    Widget option(String label, bool value, String semantic) {
      final on = isArabic == value;
      return Semantics(
        button: true,
        selected: on,
        label: semantic,
        excludeSemantics: true,
        child: RingInkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: on ? null : () => onChanged(value),
          child: AnimatedContainer(
            duration: Motion.fast(context),
            constraints: const BoxConstraints(minHeight: 32, minWidth: 40),
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: Space.s + 2),
            decoration: BoxDecoration(
              color: on ? c.surface : Colors.transparent,
              borderRadius: BorderRadius.circular(8),
              boxShadow: on
                  ? [
                      BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 2,
                          offset: const Offset(0, 1))
                    ]
                  : null,
            ),
            child: Text(label,
                style: TextStyle(
                    fontSize: TypeRole.small,
                    fontWeight: FontWeight.w500,
                    color: on ? c.text : c.muted)),
          ),
        ),
      );
    }

    return Semantics(
      label: s.languageLabel,
      child: Container(
        padding: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          color: c.sunk,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: c.hair),
        ),
        child: Material(
          type: MaterialType.transparency,
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: Row(mainAxisSize: MainAxisSize.min, children: [
              option(s.english, false, 'English'),
              option(s.arabic, true, 'العربية'),
            ]),
          ),
        ),
      ),
    );
  }
}
