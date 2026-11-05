# UI Audit — Commercial Bank AI Assistant (PoC)

Data: 2026-11-05 · Target: `lib/**` + demo live https://giacomobcn.github.io/chatTest/

Skill usate:
- **impeccable** (`audit` — 5 dimensioni, severità P0–P3). Il launcher `scripts/impeccable context` non è stato eseguito (download binario bloccato nell'ambiente), quindi il contesto è stato letto direttamente: non esistono `PRODUCT.md` / `DESIGN.md`.
- **web-design-guidelines** (Vercel Web Interface Guidelines, regole scaricate al momento), adattate a Flutter Web (render su canvas: le regole HTML valgono tramite l'albero di semantica).
- **playwright-cli / Playwright**: i 4 scenari eseguiti sulla demo live in EN e AR, a 1280px, 375px e 320px, più un dump dell'albero di semantica.

Modalità di superficie (impeccable): **Operate** — chat interna/strumento, quindi precisione e coerenza contano più dell'espressività.

---

## Punteggio

| # | Dimensione | Voto | Problema principale |
|---|---|---|---|
| 1 | Accessibilità | 1 | Pulsanti rapidi e toggle lingua non sono veri pulsanti (niente ruolo, niente tastiera); contrasto del giallo fallisce |
| 2 | Performance | 3 | App piccola; solo animazioni senza reduced-motion |
| 3 | Theming | 2 | Token in `AppTheme` esistono ma >40 colori/size hardcoded nei widget |
| 4 | Responsive | 1 | Su mobile il fumetto del bot è largo ~180px: testo spezzato a metà parola |
| 5 | Implementation Integrity | 2 | Etichette di confidenza fuorvianti, i18n incompleta in AR, pulsanti che non fanno nulla |
| **Totale** | | **9/20** | **Poor**: servono interventi mirati, non un redesign |

**Verdetto integrità:** il sistema di trust (tier → confidenza → fonti → reasoning → checkpoint) è coerente e specifico del prodotto: è il punto forte. Lo indeboliscono però i dettagli che contraddicono il messaggio "trasparenza": la confidenza al 92% di una *raccomandazione* dice "Direct database query, real-time data", e metà della card cliente resta in inglese in modalità araba.

Conteggio: **P0: 0 · P1: 9 · P2: 10 · P3: 4**

---

## P1 — da sistemare prima di mostrare la demo

**[P1] Fumetto del bot troppo stretto su mobile**
- Dove: `lib/widgets/message_bubble.dart:77-93`, `:124-126`; `lib/screens/chat_screen.dart:486,511`
- Su 375px il contenuto passa da 375 → 335 (margine 20) → 285 (padding lista 25) → 253 (padding bubble 16) → ~205 meno avatar. Risultato verificato a screenshot: "Sched/ule/Call", "Accountabili/ty", "CONFI…", "Appr…", "Relation/ship", "+15%/(recent/)". `maxWidth: MediaQuery.size.width * 0.75` usa la larghezza dello *schermo*, non del contenitore.
- Fix: sotto ~600px togliere il margine/card esterno (full-bleed), ridurre i padding della lista (25+16 → ~12), usare `LayoutBuilder` per il maxWidth, avatar più piccolo (32) o nascosto nei fumetti bot su schermi stretti.
- Comando: `/impeccable adapt`

**[P1] Pulsanti rapidi non esposti come pulsanti**
- Dove: `lib/screens/chat_screen.dart:873-928`
- Il dump di semantica mostra solo 2 bottoni (lingua, invio): Balance/Transactions/Loan/RM Tips non hanno `role=button` né stato disabled. Lo stato "processing" è solo `Opacity`.
- Fix: avvolgere in `Semantics(button: true, enabled: !_isProcessing, label: …)` oppure usare `OutlinedButton.icon`.
- Comando: `/impeccable harden`

**[P1] Toggle lingua non raggiungibile da tastiera**
- Dove: `lib/screens/chat_screen.dart:598-640`
- `GestureDetector` non riceve focus né Enter/Space; nessun focus ring. Target ~28px di altezza.
- Fix: `InkWell`/`TextButton` con `focusColor` visibile, altezza minima 44.

**[P1] Contrasto insufficiente del giallo**
- Dove: `lib/widgets/uncertainty_bar.dart:143-146` (testo "Estimated 9%" #FFC107 su #F5F5F5 ≈ 1.5:1), `message_bubble.dart:184-187` e `expandable_section.dart:128-130` (icone ⚠ gialle su sfondo chiaro).
- WCAG 1.4.3 / 1.4.11. Fix: testo legenda in `textPrimary`, giallo solo per il campione; un ambra scuro (es. #8A5A00) per icone/testo di avviso.

**[P1] Barra di incertezza solo a colori (verde/giallo/rosso)**
- Dove: `lib/widgets/uncertainty_bar.dart:44-67`
- L'enum `_LegendPattern` e i painter `_DiagonalStripesPainter` / `_DottedPainter` esistono ma **non sono mai usati** (codice morto): l'intenzione di distinguere i segmenti con pattern non è stata completata. Per daltonici rosso/verde i segmenti sono indistinguibili.
- Fix: applicare i painter già scritti ai segmenti e ai campioni della legenda. Aggiungere `Semantics` con il riepilogo testuale della barra.
- Comando: `/impeccable colorize` (o fix diretto)

**[P1] Etichetta di confidenza fuorviante**
- Dove: `lib/widgets/confidence_indicator.dart:73-86`, `lib/l10n/app_strings.dart:55-58`
- Ogni confidenza ≥90% mostra "Direct database query, real-time data", anche nello scenario 4 (raccomandazione ML al 92%). In un prototipo sul tema *hallucination safety* è proprio il tipo di errore che il prodotto vuole evitare.
- Fix: passare la spiegazione dal messaggio (`ChatMessage.confidenceExplanation`) invece di derivarla dal livello.
- Comando: `/impeccable clarify`

**[P1] i18n araba incompleta**
- `customer_profile_card.dart:75,82,94,102`: "Relationship", "Last Contact", "Potential Value", "Risk Score" hardcoded EN; valori "Premium", "5 years", "3 months ago", "+15% (recent)", "Low" in EN (`chat_screen.dart:413-420`). In RTL "+15% (recent)" si rompe in "15%+ / recent) / (" (bidi).
- `chat_screen.dart:519,527`: SnackBar "Recommendation approved/declined" solo in inglese.
- `chat_screen.dart:582`: titolo header sempre in inglese.
- `chat_screen.dart:558,571,850,862`, `message_bubble.dart:102,116`, `confidence_indicator.dart:94`, `streaming_indicator.dart:31-33`: label di semantica solo in inglese (screen reader in arabo legge inglese).
- `expandable_section.dart:67-69`: traduzione fatta confrontando la stringa `'Show ML reasoning'` — fragile; spostare in `AppStrings`.
- Comando: `/impeccable harden`

**[P1] Pulsanti che non fanno nulla**
- `message_bubble.dart:273` (`onPressed: () {}` per tutte le action), `:250-251` (Schedule Call / Live Chat), `source_attribution.dart:65` (link fonte `url: '#'`).
- Sembrano attivi (hover/ripple) ma non danno alcun feedback: in un test di usabilità l'utente pensa che l'app sia rotta.
- Fix minimo: SnackBar "Demo: azione non disponibile" localizzata, oppure stato disabilitato esplicito.

**[P1] Checkpoint di accountability: logica incoerente**
- Dove: `lib/widgets/accountability_checkpoint.dart`
- "Decline" è sempre attivo anche senza motivo selezionato, mentre il dropdown motivo esiste proprio per quello; il placeholder "Select reason..." è un valore selezionabile.
- Dopo Approve/Decline nulla cambia: si può approvare N volte, nessuna traccia visiva della decisione (contraddice "Your decision will be logged").
- Il bottone Approve disabilitato è grigio chiaro con testo bianco (contrasto ~1.5:1).
- Fix: Decline abilitato solo con motivo; `hint:` al posto del valore placeholder; dopo la decisione bloccare la card e mostrare l'esito + timestamp.
- Comando: `/impeccable harden`

---

## P2

- **Banner "Active Safety Features" non a piena larghezza su desktop**: `chat_screen.dart:646` — il `Container` col gradiente si restringe al contenuto (la `Column` padre centra). Visibile a 1280px. Fix: `width: double.infinity`.
- **Nessun supporto reduced-motion**: `message_bubble.dart:41-59`, `confidence_indicator.dart:29-40`, `expandable_section.dart`, `_scrollToBottom`. Controllare `MediaQuery.of(context).disableAnimations`.
- **Freccia "▶" non specchiata in RTL**: `expandable_section.dart:80-89` punta a destra anche in arabo. Usare `Icons.chevron_right` dentro `Directionality`-aware o `Transform.flip` in RTL; aggiungere `Semantics(expanded: _isExpanded)`.
- **Doppia semantica sul pulsante invio**: `chat_screen.dart:848-863` — `Semantics(button)` + `IconButton(tooltip)` = due nodi "Send message".
- **Font sotto il minimo dichiarato**: `AppTheme` dice "minimum 12px" ma 11px in `chat_screen.dart:592,741`, `customer_profile_card.dart:154`, `accountability_checkpoint.dart` (audit note).
- **Colori hardcoded fuori dai token**: `Color(0xFFe7f3ff)`, `0xFFcfe2ff`, `0xFFe3f2fd`, `0xFFe9ecef`, `0xFFdee2e6`, `0xFFF8F9FA`, `Colors.grey[…]`, `Colors.blue[700]` in 8 file. `AppTheme.handoffGradient*` esistono ma il banner ricrea gli stessi valori a mano. `AppTheme.containerShadow` esiste ma `chat_screen.dart:490` lo riscrive.
- **Emoji come icone**: 🔬 🛡️ 👨‍💼 📞 💬 📄 ⚖️ ℹ️ — rendering diverso per piattaforma (su web lo scudo diventa monocromo), nessuna semantica controllata, stile incoerente con le Material icons usate altrove. Il "🔬" del banner è reso come un'icona microscopio nera.
- **Typography**: "..." invece di "…" in placeholder e step di streaming (`app_strings.dart:28`, step in `chat_screen.dart`, "Select reason..."). `TextField` senza `textInputAction: send`.
- **`web/index.html`**: `<title>chat_test</title>`, description "A new Flutter project.", manca `<meta name="theme-color">`; `manifest.json` idem. È la prima cosa che si vede nel tab e nelle anteprime link.
- **Logica duplicata 4×**: il loop di streaming in `chat_screen.dart:128-141, 198-211, 315-328, 381-394` è identico. Estrarre `_runStreamingSteps(messageId, count)`.

## P3

- `_sendMessage` (`chat_screen.dart:459`): `setState` dentro `Future.delayed` senza controllo `mounted`; durante quei 500 ms `_isProcessing` resta false.
- Dati demo incoerenti: alert "± QAR 2,000" ma la quota "Uncertain" è QAR 2,500; saldo conto e spesa mensile sono lo stesso numero (45,230).
- `cupertino_icons` dichiarato ma non usato; workflow CI con `--no-tree-shake-icons` (bundle più pesante del necessario).
- `README.md`: sezione "Getting Started" ancora quella del template Flutter.

---

## Punti di forza

- Gerarchia di trust chiara e coerente tra gli scenari: tier badge → contenuto → confidenza → fonti → reasoning → azione.
- Il pattern di **streaming validation** funziona bene ed è leggibile anche in arabo.
- Buona attenzione all'RTL: `BorderRadiusDirectional`, `BorderDirectional`, barre forzate LTR per i numeri, font Noto Sans Arabic.
- Fix overflow già fatti (griglia 2×2 dei pulsanti rapidi sotto 360px, `Flexible` + ellipsis).
- Palette dei tier con testo scuro su pastello: contrasti AA ok.

---

## Azioni consigliate (in ordine)

1. **[P1] `/impeccable adapt`** — layout full-bleed su mobile e larghezza dei fumetti basata sul contenitore.
2. **[P1] `/impeccable harden`** — semantica/tastiera dei pulsanti, i18n araba completa, logica del checkpoint, feedback sui pulsanti demo.
3. **[P1] `/impeccable clarify`** — spiegazione della confidenza per-messaggio, copy dei placeholder.
4. **[P1] `/impeccable colorize`** — contrasto del giallo, pattern sulla barra di incertezza.
5. **[P2] `/impeccable animate`** — reduced-motion, chevron RTL.
6. **[P2] `/impeccable polish`** — token al posto dei colori hardcoded, emoji → icone, banner a piena larghezza, `index.html`/manifest.

Rilanciare l'audit dopo le modifiche per confrontare il punteggio.
