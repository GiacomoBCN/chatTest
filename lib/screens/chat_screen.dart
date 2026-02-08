import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/message.dart';
import '../widgets/message_bubble.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<ChatMessage> _messages = [];
  bool _isProcessing = false;

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: AppTheme.animationFast,
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _runScenario(int scenario) async {
    if (_isProcessing) return;
    setState(() => _isProcessing = true);

    String userMessage;
    switch (scenario) {
      case 1:
        userMessage = 'What is my current account balance?';
        break;
      case 2:
        userMessage = 'Analyze my spending patterns from last month';
        break;
      case 3:
        userMessage = 'Should I take out a personal loan?';
        break;
      case 4:
        userMessage = 'Show me customer recommendations for today';
        break;
      default:
        return;
    }

    // Add user message
    setState(() {
      _messages.add(ChatMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        type: MessageType.user,
        content: userMessage,
        timestamp: DateTime.now(),
      ));
    });
    _scrollToBottom();

    await Future.delayed(const Duration(milliseconds: 300));

    // Process scenario
    switch (scenario) {
      case 1:
        await _scenario1AccountBalance();
        break;
      case 2:
        await _scenario2TransactionAnalysis();
        break;
      case 3:
        await _scenario3LoanAdvice();
        break;
      case 4:
        await _scenario4RMRecommendation();
        break;
    }

    setState(() => _isProcessing = false);
  }

  Future<void> _scenario1AccountBalance() async {
    final messageId = DateTime.now().millisecondsSinceEpoch.toString();

    setState(() {
      _messages.add(ChatMessage(
        id: messageId,
        type: MessageType.bot,
        content: 'Your current account balance is **QAR 45,230.50**',
        timestamp: DateTime.now(),
        tierLevel: TierLevel.tier1,
        isStreaming: true,
        streamingSteps: const [
          StreamingStep(label: 'Connecting to core banking system...'),
          StreamingStep(label: 'Authenticating user credentials...'),
          StreamingStep(label: 'Fetching account data...'),
        ],
      ));
    });
    _scrollToBottom();

    for (int i = 0; i < 3; i++) {
      await Future.delayed(AppTheme.streamingDelay);
      setState(() {
        final msgIndex = _messages.indexWhere((m) => m.id == messageId);
        if (msgIndex != -1) {
          final msg = _messages[msgIndex];
          final updatedSteps = msg.streamingSteps!.asMap().entries.map((e) {
            if (e.key <= i) {
              return e.value.copyWith(isComplete: true);
            }
            return e.value;
          }).toList();
          _messages[msgIndex] = msg.copyWith(streamingSteps: updatedSteps);
        }
      });
    }

    await Future.delayed(const Duration(milliseconds: 500));

    setState(() {
      final msgIndex = _messages.indexWhere((m) => m.id == messageId);
      if (msgIndex != -1) {
        _messages[msgIndex] = ChatMessage(
          id: messageId,
          type: MessageType.bot,
          content: 'Your current account balance is QAR 45,230.50',
          timestamp: DateTime.now(),
          tierLevel: TierLevel.tier1,
          confidencePercent: 99,
          sources: const [
            SourceInfo(
              name: 'Core Banking System',
              metadata: 'Last updated: 2 minutes ago',
              url: '#',
            ),
          ],
          actionButtons: const ['View Statement', 'Download PDF'],
          isStreaming: false,
        );
      }
    });
    _scrollToBottom();
  }

  Future<void> _scenario2TransactionAnalysis() async {
    final messageId = DateTime.now().millisecondsSinceEpoch.toString();

    setState(() {
      _messages.add(ChatMessage(
        id: messageId,
        type: MessageType.bot,
        content: '',
        timestamp: DateTime.now(),
        tierLevel: TierLevel.tier2,
        isStreaming: true,
        streamingSteps: const [
          StreamingStep(label: 'Analyzing transaction history...'),
          StreamingStep(label: 'Categorizing expenditures...'),
          StreamingStep(label: 'Cross-referencing patterns...'),
          StreamingStep(label: 'Calculating confidence intervals...'),
        ],
      ));
    });
    _scrollToBottom();

    for (int i = 0; i < 4; i++) {
      await Future.delayed(AppTheme.streamingDelay);
      setState(() {
        final msgIndex = _messages.indexWhere((m) => m.id == messageId);
        if (msgIndex != -1) {
          final msg = _messages[msgIndex];
          final updatedSteps = msg.streamingSteps!.asMap().entries.map((e) {
            if (e.key <= i) {
              return e.value.copyWith(isComplete: true);
            }
            return e.value;
          }).toList();
          _messages[msgIndex] = msg.copyWith(streamingSteps: updatedSteps);
        }
      });
    }

    await Future.delayed(const Duration(milliseconds: 500));

    setState(() {
      final msgIndex = _messages.indexWhere((m) => m.id == messageId);
      if (msgIndex != -1) {
        _messages[msgIndex] = ChatMessage(
          id: messageId,
          type: MessageType.bot,
          content:
              'Your estimated total spending for January 2026 is approximately QAR 45,230',
          timestamp: DateTime.now(),
          tierLevel: TierLevel.tier2,
          confidencePercent: 73,
          warningMessage: 'Data Quality Alert: Possible error range ± QAR 2,000',
          uncertaintyData: const UncertaintyData(
            confirmedAmount: 38445,
            estimatedAmount: 4285,
            uncertainAmount: 2500,
          ),
          sources: const [
            SourceInfo(
              name: 'Transaction Database',
              metadata: '28 days complete, 3 days partial',
              url: '#',
            ),
            SourceInfo(
              name: 'Card Processing System',
              metadata: 'Last synced: 3 days ago',
              url: '#',
            ),
            SourceInfo(
              name: 'ATM Network',
              metadata: 'Real-time',
            ),
          ],
          mlReasoning: const MLReasoning(points: [
            '28 days have complete transaction records',
            '⚠ Jan 15-17: Partial data (system maintenance)',
            '⚠ 2 offline ATM transactions not yet synced',
            'Cross-referenced with bank statement totals',
          ]),
          actionButtons: const ['View Raw Data', 'Export Details', 'Report Issue'],
          isStreaming: false,
        );
      }
    });
    _scrollToBottom();
  }

  Future<void> _scenario3LoanAdvice() async {
    final messageId = DateTime.now().millisecondsSinceEpoch.toString();

    setState(() {
      _messages.add(ChatMessage(
        id: messageId,
        type: MessageType.bot,
        content: '',
        timestamp: DateTime.now(),
        tierLevel: TierLevel.tier3,
        isStreaming: true,
        streamingSteps: const [
          StreamingStep(label: 'Processing request...'),
          StreamingStep(label: 'Analyzing query type...'),
        ],
      ));
    });
    _scrollToBottom();

    for (int i = 0; i < 2; i++) {
      await Future.delayed(AppTheme.streamingDelay);
      setState(() {
        final msgIndex = _messages.indexWhere((m) => m.id == messageId);
        if (msgIndex != -1) {
          final msg = _messages[msgIndex];
          final updatedSteps = msg.streamingSteps!.asMap().entries.map((e) {
            if (e.key <= i) {
              return e.value.copyWith(isComplete: true);
            }
            return e.value;
          }).toList();
          _messages[msgIndex] = msg.copyWith(streamingSteps: updatedSteps);
        }
      });
    }

    await Future.delayed(const Duration(milliseconds: 500));

    setState(() {
      final msgIndex = _messages.indexWhere((m) => m.id == messageId);
      if (msgIndex != -1) {
        _messages[msgIndex] = ChatMessage(
          id: messageId,
          type: MessageType.bot,
          content:
              'Loan recommendations require personalized financial advice from a licensed advisor. I cannot provide this guidance, but I can connect you with the right specialist.',
          timestamp: DateTime.now(),
          tierLevel: TierLevel.tier3,
          showHumanHandoff: true,
          actionButtons: const ['View Loan Products', 'Loan Calculator'],
          isStreaming: false,
        );
      }
    });
    _scrollToBottom();
  }

  Future<void> _scenario4RMRecommendation() async {
    final messageId = DateTime.now().millisecondsSinceEpoch.toString();

    setState(() {
      _messages.add(ChatMessage(
        id: messageId,
        type: MessageType.bot,
        content: '',
        timestamp: DateTime.now(),
        isStreaming: true,
        streamingSteps: const [
          StreamingStep(label: 'Analyzing customer portfolio...'),
          StreamingStep(label: 'Identifying engagement opportunities...'),
          StreamingStep(label: 'Calculating recommendation confidence...'),
          StreamingStep(label: 'Running validation checks...'),
        ],
      ));
    });
    _scrollToBottom();

    for (int i = 0; i < 4; i++) {
      await Future.delayed(AppTheme.streamingDelay);
      setState(() {
        final msgIndex = _messages.indexWhere((m) => m.id == messageId);
        if (msgIndex != -1) {
          final msg = _messages[msgIndex];
          final updatedSteps = msg.streamingSteps!.asMap().entries.map((e) {
            if (e.key <= i) {
              return e.value.copyWith(isComplete: true);
            }
            return e.value;
          }).toList();
          _messages[msgIndex] = msg.copyWith(streamingSteps: updatedSteps);
        }
      });
    }

    await Future.delayed(const Duration(milliseconds: 500));

    setState(() {
      final msgIndex = _messages.indexWhere((m) => m.id == messageId);
      if (msgIndex != -1) {
        _messages[msgIndex] = ChatMessage(
          id: messageId,
          type: MessageType.bot,
          content: 'Recommended Action: Contact Ahmed Al-Mansouri today',
          timestamp: DateTime.now(),
          tierLevel: TierLevel.tier2,
          tierLabel: 'RM Assistant: Customer Recommendation',
          confidencePercent: 92,
          customerProfile: const CustomerProfile(
            name: 'Ahmed Al-Mansouri',
            segment: 'Premium',
            relationship: '5 years',
            lastContact: '3 months ago',
            potentialValue: '+15% (recent)',
            riskScore: 'Low',
          ),
          mlReasoning: const MLReasoning(points: [
            'Salary increase detected: +15% (verified from employer)',
            'Life stage indicator: Recently married (profile updated)',
            'Savings pattern: Increased by 40% last 3 months',
            'Similar customer patterns: 87% converted to mortgage within 6 months',
            'Engagement window: Last contact 3 months ago (optimal timing)',
          ]),
          showAccountabilityCheckpoint: true,
          isStreaming: false,
        );
      }
    });
    _scrollToBottom();
  }

  void _sendMessage() {
    if (_textController.text.trim().isEmpty || _isProcessing) return;

    setState(() {
      _messages.add(ChatMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        type: MessageType.user,
        content: _textController.text.trim(),
        timestamp: DateTime.now(),
      ));
    });
    _textController.clear();
    _scrollToBottom();

    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        _messages.add(ChatMessage(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          type: MessageType.bot,
          content:
              'Thank you for your message. Please use the quick action buttons below to explore the demo scenarios with full hallucination safety features.',
          timestamp: DateTime.now(),
        ));
      });
      _scrollToBottom();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        // Full screen gradient background
        decoration: BoxDecoration(
          gradient: AppTheme.backgroundGradient,
        ),
        child: SafeArea(
          child: Center(
            child: Container(
              // Chat container with max width 600px
              constraints: const BoxConstraints(maxWidth: 600),
              margin: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(AppTheme.borderRadiusLarge),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 60,
                    offset: const Offset(0, 20),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(AppTheme.borderRadiusLarge),
                child: Column(
                  children: [
                    // Header
                    _buildHeader(),
                    // Framework Banner
                    _buildFrameworkBanner(),
                    // Messages list
                    Expanded(
                      child: Container(
                        color: AppTheme.backgroundLight,
                        child: _messages.isEmpty
                            ? _buildWelcomeMessage()
                            : ListView.builder(
                                controller: _scrollController,
                                padding: const EdgeInsets.all(AppTheme.paddingLarge),
                                itemCount: _messages.length,
                                itemBuilder: (context, index) {
                                  return MessageBubble(
                                    message: _messages[index],
                                    onApprove: () {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                          content: Text('✓ Recommendation approved!'),
                                          backgroundColor: AppTheme.success,
                                        ),
                                      );
                                    },
                                    onDecline: () {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                          content: Text('✗ Recommendation declined'),
                                          backgroundColor: AppTheme.danger,
                                        ),
                                      );
                                    },
                                  );
                                },
                              ),
                      ),
                    ),
                    // Input Area
                    _buildInputArea(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      decoration: BoxDecoration(
        gradient: AppTheme.headerGradient,
      ),
      child: Row(
        children: [
          // Bot avatar
          Semantics(
            label: 'Security shield - Protected AI',
            child: Container(
              width: 45,
              height: 45,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: Icon(
                  Icons.shield,
                  size: 24,
                  color: AppTheme.primaryBurgundy,
                  semanticLabel: 'Protected',
                ),
              ),
            ),
          ),
          const SizedBox(width: 15),
          // Header text
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Commercial Bank AI Assistant',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Hallucination Safety Framework Enabled',
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
          // Safety badge - Green
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppTheme.success,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.check_circle, color: Colors.white, size: 14),
                SizedBox(width: 6),
                Text(
                  'Safety Mode Active',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFrameworkBanner() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFe7f3ff), Color(0xFFcfe2ff)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border(
          bottom: BorderSide(color: AppTheme.infoText, width: 2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '🔬 Active Safety Features:',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppTheme.infoText,
            ),
          ),
          const SizedBox(height: 5),
          Wrap(
            spacing: 20,
            runSpacing: 5,
            children: [
              _buildFeatureItem('Confidence Scoring'),
              _buildFeatureItem('Source Attribution'),
              _buildFeatureItem('Streaming Validation'),
              _buildFeatureItem('Accountability Tracking'),
              _buildFeatureItem('Human Handoff'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureItem(String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text('✓', style: TextStyle(color: AppTheme.infoText, fontSize: 12)),
        const SizedBox(width: 5),
        Text(
          text,
          style: const TextStyle(
            fontSize: 12,
            color: AppTheme.infoText,
          ),
        ),
      ],
    );
  }

  Widget _buildWelcomeMessage() {
    return ListView(
      padding: const EdgeInsets.all(AppTheme.paddingLarge),
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Bot avatar
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: const Color(0xFFe3f2fd),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Center(
                child: Text('🛡️', style: TextStyle(fontSize: 18)),
              ),
            ),
            const SizedBox(width: 12),
            // Message content
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: AppTheme.cardShadow,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppTheme.tier1Bg,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        'System Message',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.tier1Text,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Welcome to Commercial Bank AI Assistant',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      "I'm designed with hallucination mitigation protocols. Every response includes: confidence scoring, source attribution, and accountability tracking.",
                      style: TextStyle(
                        fontSize: 14,
                        color: AppTheme.textPrimary,
                        height: 1.6,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildInputArea() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: Color(0xFFdee2e6), width: 1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Quick actions - 2x2 grid
          Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: _QuickActionChip(
                      emoji: '🟢',
                      label: 'Account Balance',
                      onTap: () => _runScenario(1),
                      isProcessing: _isProcessing,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _QuickActionChip(
                      emoji: '🔵',
                      label: 'Transaction Analysis',
                      onTap: () => _runScenario(2),
                      isProcessing: _isProcessing,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: _QuickActionChip(
                      emoji: '🔴',
                      label: 'Loan Advice',
                      onTap: () => _runScenario(3),
                      isProcessing: _isProcessing,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _QuickActionChip(
                      emoji: '⚠️',
                      label: 'RM Recommendation',
                      onTap: () => _runScenario(4),
                      isProcessing: _isProcessing,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Input field
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _textController,
                  decoration: const InputDecoration(
                    hintText: 'Ask me anything...',
                    hintStyle: TextStyle(color: AppTheme.textSecondary),
                  ),
                  onSubmitted: (_) => _sendMessage(),
                ),
              ),
              const SizedBox(width: 10),
              Semantics(
                button: true,
                label: 'Send message',
                child: Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    gradient: AppTheme.headerGradient,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.send, color: Colors.white, size: 22),
                    onPressed: _sendMessage,
                    tooltip: 'Send message',
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _QuickActionChip extends StatelessWidget {
  final String emoji;
  final String label;
  final VoidCallback onTap;
  final bool isProcessing;

  const _QuickActionChip({
    required this.emoji,
    required this.label,
    required this.onTap,
    required this.isProcessing,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      enabled: !isProcessing,
      label: label,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isProcessing ? null : onTap,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            width: double.infinity,
            constraints: const BoxConstraints(minHeight: 44), // Touch target
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
            decoration: BoxDecoration(
              color: isProcessing ? Colors.grey[200] : const Color(0xFFF8F9FA),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isProcessing ? Colors.grey[300]! : const Color(0xFFdee2e6),
              ),
            ),
            child: Text(
              '$emoji $label',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: AppTheme.fontSizeTiny,
                color: isProcessing ? Colors.grey : AppTheme.textPrimary,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
