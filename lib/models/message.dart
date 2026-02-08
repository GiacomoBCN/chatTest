enum MessageType { user, bot }
enum TierLevel { tier1, tier2, tier3 }
enum ConfidenceLevel { high, medium, low }

class StreamingStep {
  final String label;
  final bool isComplete;

  const StreamingStep({
    required this.label,
    this.isComplete = false,
  });

  StreamingStep copyWith({bool? isComplete}) {
    return StreamingStep(
      label: label,
      isComplete: isComplete ?? this.isComplete,
    );
  }
}

class SourceInfo {
  final String name;
  final String metadata;
  final String? url;

  const SourceInfo({
    required this.name,
    required this.metadata,
    this.url,
  });
}

class UncertaintyData {
  final double confirmedAmount;
  final double estimatedAmount;
  final double uncertainAmount;

  const UncertaintyData({
    required this.confirmedAmount,
    required this.estimatedAmount,
    required this.uncertainAmount,
  });

  double get total => confirmedAmount + estimatedAmount + uncertainAmount;
  double get confirmedPercent => (confirmedAmount / total) * 100;
  double get estimatedPercent => (estimatedAmount / total) * 100;
  double get uncertainPercent => (uncertainAmount / total) * 100;
}

class MLReasoning {
  final List<String> points;

  const MLReasoning({required this.points});
}

class CustomerProfile {
  final String name;
  final String segment;
  final String relationship;
  final String lastContact;
  final String potentialValue;
  final String riskScore;

  const CustomerProfile({
    required this.name,
    required this.segment,
    required this.relationship,
    required this.lastContact,
    required this.potentialValue,
    required this.riskScore,
  });
}

class ChatMessage {
  final String id;
  final MessageType type;
  final String content;
  final DateTime timestamp;
  final TierLevel? tierLevel;
  final String? tierLabel;
  final int? confidencePercent;
  final List<SourceInfo>? sources;
  final UncertaintyData? uncertaintyData;
  final MLReasoning? mlReasoning;
  final bool showHumanHandoff;
  final bool showAccountabilityCheckpoint;
  final CustomerProfile? customerProfile;
  final List<String>? actionButtons;
  final String? warningMessage;
  final List<StreamingStep>? streamingSteps;
  final bool isStreaming;

  const ChatMessage({
    required this.id,
    required this.type,
    required this.content,
    required this.timestamp,
    this.tierLevel,
    this.tierLabel,
    this.confidencePercent,
    this.sources,
    this.uncertaintyData,
    this.mlReasoning,
    this.showHumanHandoff = false,
    this.showAccountabilityCheckpoint = false,
    this.customerProfile,
    this.actionButtons,
    this.warningMessage,
    this.streamingSteps,
    this.isStreaming = false,
  });

  ConfidenceLevel? get confidenceLevel {
    if (confidencePercent == null) return null;
    if (confidencePercent! >= 90) return ConfidenceLevel.high;
    if (confidencePercent! >= 70) return ConfidenceLevel.medium;
    return ConfidenceLevel.low;
  }

  ChatMessage copyWith({
    List<StreamingStep>? streamingSteps,
    bool? isStreaming,
  }) {
    return ChatMessage(
      id: id,
      type: type,
      content: content,
      timestamp: timestamp,
      tierLevel: tierLevel,
      tierLabel: tierLabel,
      confidencePercent: confidencePercent,
      sources: sources,
      uncertaintyData: uncertaintyData,
      mlReasoning: mlReasoning,
      showHumanHandoff: showHumanHandoff,
      showAccountabilityCheckpoint: showAccountabilityCheckpoint,
      customerProfile: customerProfile,
      actionButtons: actionButtons,
      warningMessage: warningMessage,
      streamingSteps: streamingSteps ?? this.streamingSteps,
      isStreaming: isStreaming ?? this.isStreaming,
    );
  }
}
