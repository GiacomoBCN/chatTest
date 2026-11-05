# Falak · AI assistant concept

A coded prototype of a banking AI assistant that shows **where each answer comes from** and **how sure it is**, and hands over to a person when it should. Falak is a fictional bank; every name and figure in the demo is invented.

**[Open the demo](https://giacomobcn.github.io/chatTest/)** · English and Arabic · light and dark

## Four examples

The demo runs four scripted examples. Each one shows a different behaviour.

| Example | Who it's for | What it shows |
|---|---|---|
| **Balance** | Customer | A fact read from the system. Answered directly, with its source and how fresh it is. |
| **Spending** | Customer | An estimate. The total is a range, and the answer separates what is confirmed from what is estimated or not yet synced. |
| **Loan advice** | Customer | A question an AI shouldn't decide. It hands the customer to an advisor, with wait times and the conversation passed along. |
| **Client to contact** | Bank staff | The AI suggests a client for a relationship manager to contact. A person reviews it and signs off, and the decision is logged. |

## Design decisions

- **Words and marks, not percentages.** A number like "73%" reads as precise even when it isn't calibrated. Each answer instead carries a mark borrowed from banknote printing: solid for data from the system, hatched for an estimate, dotted for something not yet confirmed. The marks work without colour.
- **Red only for real alarms.** Uncertainty isn't an error, so it's never shown in red.
- **The answer comes first.** The amount or the recommendation leads; the source sits in one line under it, and the reasoning opens on request.
- **Same signals in both languages.** English and Arabic show identical trust cues. Switching language translates the whole conversation, including screen-reader labels.
- **Accessible by default.** Text contrast of at least 4.5:1 in both themes, a visible keyboard focus, real buttons, and reduced motion when the system asks for it.

## Visual language

The identity comes from banknote security printing, the oldest trust technology a bank has: intaglio-green ink on cool paper, a single guilloche rosette, and an engraved temple emblem. The type is Readex Pro, one family for Latin and Arabic.

## Run it locally

Requires [Flutter](https://docs.flutter.dev/get-started/install) 3.24 or later.

```bash
flutter pub get
flutter run -d chrome
```

## Built with

Flutter and Dart. No backend and no live AI: the conversations are scripted to study the interaction patterns. Built with Claude Code.
