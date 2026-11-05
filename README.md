# Falak · AI assistant concept

A coded prototype of a banking AI assistant that shows **where each answer comes from** and **how sure it is**, and hands over to a person when it should. Falak is a fictional bank; every name and figure in the demo is invented.

**[Open the demo](https://giacomobcn.github.io/chatTest/)** · English and Arabic · light and dark

## Four examples

The demo runs four scripted examples. Each one shows a different behaviour.

| Example | Who it's for | What it shows |
|---|---|---|
| **Balance** | Customer | A fact read from the system. Answered directly, with its source and how fresh it is. |
| **Spending** | Customer | An estimate. The total is a range, the answer separates what is confirmed from what is estimated or not yet synced, and one tap shows the items behind each estimate. |
| **Loan advice** | Customer | A question an AI shouldn't decide. It hands the customer to an advisor, with wait times and the conversation passed along. |
| **Client to contact** | Bank staff | The AI flags a client for a relationship manager. The manager gives their own read before seeing the AI's suggestion, checks specific points, gives a reason either way, and gets a receipt of what was logged. |

## Design decisions and the research behind them

One finding shaped everything: trust signals such as percentages, citations, visible steps and explanations **raise trust even when the AI is wrong**. They only make trust *appropriate* when they lower the cost of checking an answer, or push the person to form their own judgement. Each decision below follows from that.

### How sure the answer is

**Words and marks instead of a percentage.** Each answer carries a mark borrowed from banknote printing: solid for data read from the system, hatched for an estimate, dotted for something not yet confirmed. The marks read without colour.
*Why:* when an AI's displayed confidence was inflated while its accuracy stayed fixed, people followed it more often, and most of them rated the overconfident AI as well calibrated ([Li et al.](https://arxiv.org/html/2402.07632v4)). Google's People + AI Guidebook calls numeric confidence risky and recommends a few categories, each tied to a clear action ([PAIR](https://pair.withgoogle.com/chapter/People%20+%20AI%20Guidebook%20-%20Explainability%20+%20Trust.pdf)).

**Estimates shown as a range, with the parts broken down.** Spending reads "≈ 42,700, between 38,445 and 45,230", followed by what is confirmed, estimated and not yet synced.
*Why:* a numeric range barely lowers trust in the source ([van der Bles et al.](https://blog.aiimpacts.org/p/paper-summary-the-effects-of-communicating)), while a single precise figure placed next to uncertain parts distorts judgement ([Kale, Kay & Hullman](https://arxiv.org/pdf/2007.14516v3.pdf)).

**Checking an estimate takes one tap.** The estimated and unsynced amounts open the transactions behind them.
*Why:* what reduces over-reliance on AI is making verification cheaper, not adding more signals ([Vasconcelos et al.](https://arxiv.org/abs/2212.06823)).

### Where the answer comes from

**A source on every answer, in one line, and only the sources actually used.**
*Why:* citations raise trust even when they are random, and few people check them ([Ding et al.](https://arxiv.org/pdf/2501.01303v1.pdf)). So a source label is only worth showing if it is exact. Sources also reduced reliance on wrong answers, where explanations increased it ([Kim et al.](https://arxiv.org/abs/2502.08554v1)).

**The reasoning stays one tap away.** "Why this answer" is collapsed by default and lists the data used.
*Why:* people look at explanations mainly when an answer surprises them, so a short layer first and detail on demand works best ([Springer & Whittaker](https://arxiv.org/abs/1811.02164)).

### How the assistant behaves

**No fake progress.** A balance is answered straight away. Steps appear only when the assistant consults several sources, each step names the source it reads, and the work can be stopped.
*Why:* slow algorithmic answers are judged *less* accurate, unlike slow human ones ([Efendić et al.](https://research.tilburguniversity.edu/en/publications/slow-response-times-undermine-trust-in-algorithmic-but-not-human-/)). AWS's guidance defines a step as a real unit of work and says to stream fast answers directly ([Cloudscape](https://cloudscape.design/patterns/genai/progressive-steps)).

**Some questions get a person, not a guess.** The loan question is handed to an advisor without the AI offering its own best guess.
*Why:* telling people the AI had declined to answer, without showing its uncertain guess, gave the most accurate decisions; showing the guess pulled people towards it ([Bondi et al.](https://ar5iv.labs.arxiv.org/html/2112.06751)).

**A person is always one tap away, and any answer can be flagged as wrong.** "Talk to a person" sits in the header.
*Why:* chatbots with no way out ("doom loops") are among the main harms the US consumer finance regulator found in banking assistants ([CFPB](https://files.consumerfinance.gov/f/documents/cfpb_chatbot-issue-spotlight_2023-06.pdf)).

**The assistant says it is an AI from the first message.** This is the transparency duty in Article 50 of the EU AI Act.

### Human oversight that isn't a rubber stamp

**The relationship manager commits to a view first.** They see the client's data and answer "should we contact them?" before the AI's suggestion appears.
*Why:* automation bias affects experts as much as novices and isn't fixed by training or instructions ([Parasuraman & Manzey](https://pubmed.ncbi.nlm.nih.gov/21077562/)). Asking for an independent judgement first reduces over-reliance more than explanations do ([Buçinca et al.](https://arxiv.org/pdf/2102.09692)).

**Specific checks and a reason for either decision.** Three named checks replace a generic "I have reviewed" box, and approving needs a reason just as declining does. The form then turns into a receipt.
*Why:* a generic attestation adds a click without adding scrutiny, and human-oversight policies built on it can give a false sense of security ([Green](https://arxiv.org/abs/2109.05067v3)). Accountability works when people know before deciding that they will have to justify the decision ([Lerner & Tetlock](https://www.eurekalert.org/pub_releases/1999-06/CMU-CMrs-080699.php)). Asking for a reason only on decline would make approving the path of least resistance.

**Inferred and sensitive data is labelled as such.** "Recently married" is marked as inferred from a joint account and not confirmed by the client. The conversion-rate argument ("87% of similar clients took a mortgage") was removed: it worked as a sales pitch aimed at the reviewer.
*Why:* data that indirectly reveals sensitive information is treated as sensitive data under EU law ([CJEU C-184/20](https://www.insideprivacy.com/eu-data-protection/special-category-data-by-inference-cjeu-significantly-expands-the-scope-of-article-9-gdpr/)).

### Language and colour

**The same trust signals in English and Arabic.** Switching language translates the whole conversation, including screen-reader labels.
*Why:* across cultures, trust in automation starts at different levels but follows the same mechanism, tracking reliability ([Chien et al.](https://d-scholarship.pitt.edu/34582/)).

**Red means error or decline, nothing else.** Uncertainty is never shown in red, and colour is never the only signal.
*Why:* in banking red already means overdrafts, refusals and fraud, so a red badge on a correct but uncertain answer reads as a problem. Accessibility rules also require a second cue alongside colour ([WCAG 1.4.1](https://w3c.github.io/wcag/understanding/use-of-color)).

**Accessible in both themes.** Text contrast of at least 4.5:1 in light and dark, a visible keyboard focus, real buttons, and reduced motion when the system asks for it.

## Limits

- The conversations are scripted. A system that always behaves the same tells you nothing about how well people calibrate their trust.
- Most of the evidence above comes from lab and crowdsourced studies on simplified tasks, not from field studies of banking chat.
- The next step would be to test the demo with deliberately wrong answers and measure behaviour: how many errors people catch, how often they open the sources, how long staff reviews take and how much they vary.

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
