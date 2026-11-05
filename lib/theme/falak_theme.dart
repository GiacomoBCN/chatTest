import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Falak colour roles. Inks from banknote security printing:
/// a deep intaglio green on cool cotton paper, and a foil tone kept
/// for the staff/accountability role only.
@immutable
class FalakColors extends ThemeExtension<FalakColors> {
  final Color ground; // page behind everything
  final Color surface; // device + answer slips
  final Color sunk; // grouped backgrounds, selected rows
  final Color text;
  final Color muted; // secondary text, ≥4.5:1 on surface
  final Color hair; // separators
  final Color hairStrong; // control outlines, ≥3:1 on surface
  final Color ink; // brand + primary action + trust marks
  final Color onInk;
  final Color userBubble;
  final Color onUserBubble;
  final Color staff; // internal staff role
  final Color staffSoft;
  final Color guilloche; // the one decorative line work
  final Color danger;

  const FalakColors({
    required this.ground,
    required this.surface,
    required this.sunk,
    required this.text,
    required this.muted,
    required this.hair,
    required this.hairStrong,
    required this.ink,
    required this.onInk,
    required this.userBubble,
    required this.onUserBubble,
    required this.staff,
    required this.staffSoft,
    required this.guilloche,
    required this.danger,
  });

  static const light = FalakColors(
    ground: Color(0xFFE9EDE7),
    surface: Color(0xFFFBFCFA),
    sunk: Color(0xFFF0F3EF),
    text: Color(0xFF14211C),
    muted: Color(0xFF4E5B55),
    hair: Color(0xFFD3DAD5),
    hairStrong: Color(0xFF78867F),
    ink: Color(0xFF1D5A45),
    onInk: Color(0xFFFFFFFF),
    userBubble: Color(0xFF1D5A45),
    onUserBubble: Color(0xFFFFFFFF),
    staff: Color(0xFF7A4321),
    staffSoft: Color(0xFFF3E9E1),
    guilloche: Color(0x2E1D5A45),
    danger: Color(0xFFA3281C),
  );

  static const dark = FalakColors(
    ground: Color(0xFF0B110F),
    surface: Color(0xFF131B18),
    sunk: Color(0xFF19231F),
    text: Color(0xFFE6ECE7),
    muted: Color(0xFF9AA8A1),
    hair: Color(0xFF26322D),
    hairStrong: Color(0xFF5E6E66),
    ink: Color(0xFF8CC7AE),
    onInk: Color(0xFF0B110F),
    userBubble: Color(0xFF22362E),
    onUserBubble: Color(0xFFE6ECE7),
    staff: Color(0xFFE2A882),
    staffSoft: Color(0xFF2B1F17),
    guilloche: Color(0x298CC7AE),
    danger: Color(0xFFF08A7E),
  );

  static FalakColors of(BuildContext context) => Theme.of(context).extension<FalakColors>()!;

  @override
  FalakColors copyWith() => this;

  @override
  FalakColors lerp(ThemeExtension<FalakColors>? other, double t) {
    if (other is! FalakColors) return this;
    Color l(Color a, Color b) => Color.lerp(a, b, t)!;
    return FalakColors(
      ground: l(ground, other.ground),
      surface: l(surface, other.surface),
      sunk: l(sunk, other.sunk),
      text: l(text, other.text),
      muted: l(muted, other.muted),
      hair: l(hair, other.hair),
      hairStrong: l(hairStrong, other.hairStrong),
      ink: l(ink, other.ink),
      onInk: l(onInk, other.onInk),
      userBubble: l(userBubble, other.userBubble),
      onUserBubble: l(onUserBubble, other.onUserBubble),
      staff: l(staff, other.staff),
      staffSoft: l(staffSoft, other.staffSoft),
      guilloche: l(guilloche, other.guilloche),
      danger: l(danger, other.danger),
    );
  }
}

/// Spacing and radius scale. One rhythm everywhere.
class Space {
  static const double xs = 4;
  static const double s = 8;
  static const double m = 12;
  static const double l = 16;
  static const double xl = 24;
  static const double xxl = 32;
}

class Radii {
  static const double control = 12;
  static const double slip = 18;
  static const double group = 16;
  static const double device = 30;
}

/// Type roles (Readex Pro covers Latin and Arabic with one family).
class TypeRole {
  static const double amount = 28;
  static const double title = 17;
  static const double body = 15;
  static const double label = 14;
  static const double small = 13;
  static const double tiny = 12;
}

/// Durations; collapse to zero when the platform asks for reduced motion.
class Motion {
  static Duration fast(BuildContext c) =>
      MediaQuery.of(c).disableAnimations ? Duration.zero : const Duration(milliseconds: 180);
  static Duration enter(BuildContext c) =>
      MediaQuery.of(c).disableAnimations ? Duration.zero : const Duration(milliseconds: 220);
}

const tabular = [FontFeature.tabularFigures()];

ThemeData buildFalakTheme(Brightness brightness) {
  final c = brightness == Brightness.dark ? FalakColors.dark : FalakColors.light;
  final base = ThemeData(
    useMaterial3: true,
    brightness: brightness,
    fontFamily: GoogleFonts.readexPro().fontFamily,
    colorScheme: ColorScheme.fromSeed(
      seedColor: c.ink,
      brightness: brightness,
      primary: c.ink,
      onPrimary: c.onInk,
      surface: c.surface,
      onSurface: c.text,
      error: c.danger,
    ),
    scaffoldBackgroundColor: c.ground,
    extensions: [c],
    splashFactory: InkSparkle.splashFactory,
    dividerColor: c.hair,
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: c.ink,
      selectionColor: c.ink.withOpacity(0.25),
      selectionHandleColor: c.ink,
    ),
    tooltipTheme: TooltipThemeData(
      decoration: BoxDecoration(
        color: c.text,
        borderRadius: BorderRadius.circular(8),
      ),
      textStyle: TextStyle(color: c.surface, fontSize: TypeRole.small),
      waitDuration: const Duration(milliseconds: 400),
    ),
    snackBarTheme: SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      backgroundColor: c.text,
      contentTextStyle: TextStyle(color: c.surface, fontSize: TypeRole.label),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Radii.control)),
    ),
    filledButtonTheme: FilledButtonThemeData(style: ButtonStyle(side: focusSide(c.text))),
    textButtonTheme: TextButtonThemeData(style: ButtonStyle(side: focusSide(c.text))),
    checkboxTheme: CheckboxThemeData(
      side: BorderSide(color: c.hairStrong, width: 1.5),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
    ),
  );
  return base.copyWith(
    textTheme: GoogleFonts.readexProTextTheme(base.textTheme).apply(
      bodyColor: c.text,
      displayColor: c.text,
    ),
  );
}

/// Isolates a number so it keeps its left-to-right order inside Arabic text.
String ltr(String s) => '${String.fromCharCode(0x2066)}$s${String.fromCharCode(0x2069)}';

/// Button labels: Material's button styles drop the theme family when a
/// textStyle is given, so every label goes through this.
TextStyle labelStyle({double size = TypeRole.label, FontWeight weight = FontWeight.w500}) =>
    GoogleFonts.readexPro(fontSize: size, fontWeight: weight);

/// Keyboard focus ring: a 2px outline in the text colour (≥14:1 on both
/// themes), drawn only when focused, so it never depends on a faint fill.
WidgetStateProperty<BorderSide?> focusSide(Color ring, [BorderSide? rest]) =>
    WidgetStateProperty.resolveWith((states) =>
        states.contains(WidgetState.focused) ? BorderSide(color: ring, width: 2) : rest);

/// InkWell with a visible keyboard focus ring.
class RingInkWell extends StatefulWidget {
  final VoidCallback? onTap;
  final BorderRadius? borderRadius;
  final Color? hoverColor;
  final Color? focusColor;
  final Widget child;
  const RingInkWell({
    super.key,
    required this.onTap,
    required this.child,
    this.borderRadius,
    this.hoverColor,
    this.focusColor,
  });

  @override
  State<RingInkWell> createState() => _RingInkWellState();
}

class _RingInkWellState extends State<RingInkWell> {
  bool _focused = false;

  @override
  Widget build(BuildContext context) {
    final c = FalakColors.of(context);
    final keyboard = FocusManager.instance.highlightMode == FocusHighlightMode.traditional;
    return InkWell(
      onTap: widget.onTap,
      borderRadius: widget.borderRadius,
      hoverColor: widget.hoverColor,
      focusColor: widget.focusColor ?? Colors.transparent,
      onFocusChange: (f) => setState(() => _focused = f),
      child: Container(
        foregroundDecoration: _focused && keyboard
            ? BoxDecoration(
                border: Border.all(color: c.text, width: 2),
                borderRadius: widget.borderRadius,
              )
            : null,
        child: widget.child,
      ),
    );
  }
}

/// Short confirmation, sized to the conversation rather than the window.
void showToast(BuildContext context, String message) {
  final w = MediaQuery.sizeOf(context).width;
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(
      content: Text(message),
      width: w < 432 ? null : 400,
      duration: const Duration(seconds: 3),
    ));
}
