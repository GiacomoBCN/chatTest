/// The four scripted examples. Content is rendered from the scenario at
/// build time, so switching language re-renders the whole conversation.
enum Scenario { balance, spending, loan, client }

extension ScenarioInfo on Scenario {
  bool get isStaff => this == Scenario.client;
}

enum EntryKind { question, answer, freeText, fallback }

class ChatEntry {
  final int id;
  final EntryKind kind;
  final Scenario? scenario;
  final String? text; // free text typed by the user
  final int stepsDone; // progress steps completed so far
  final bool done;

  const ChatEntry({
    required this.id,
    required this.kind,
    this.scenario,
    this.text,
    this.stepsDone = 0,
    this.done = true,
  });

  ChatEntry copyWith({int? stepsDone, bool? done}) => ChatEntry(
        id: id,
        kind: kind,
        scenario: scenario,
        text: text,
        stepsDone: stepsDone ?? this.stepsDone,
        done: done ?? this.done,
      );
}
