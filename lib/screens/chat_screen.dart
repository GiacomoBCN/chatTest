import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/message.dart';
import '../widgets/message_bubble.dart';
import '../language_provider.dart';
import '../l10n/app_strings.dart';

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

    // Capture language at call time so async steps stay consistent.
    final isArabic = LanguageProvider.of(context).isArabic;
    final s = AppStrings(isArabic);

    String userMessage;
    switch (scenario) {
      case 1:
        userMessage = s.scenario1UserMessage;
        break;
      case 2:
        userMessage = isArabic
            ? 'تحليل أنماط إنفاقي من الشهر الماضي'
            : 'Analyze my spending patterns from last month';
        break;
      case 3:
        userMessage = isArabic
            ? 'هل يجب أن آخذ قرضاً شخصياً؟'
            : 'Should I take out a personal loan?';
        break;
      case 4:
        userMessage = isArabic
            ? 'أظهر لي توصيات العملاء لهذا اليوم'
            : 'Show me customer recommendations for today';
        break;
      default:
        return;
    }

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

    switch (scenario) {
      case 1:
        await _scenario1AccountBalance(s);
        break;
      case 2:
        await _scenario2TransactionAnalysis(isArabic);
        break;
      case 3:
        await _scenario3LoanAdvice(isArabic, s);
        break;
      case 4:
        await _scenario4RMRecommendation(isArabic);
        break;
    }

    setState(() => _isProcessing = false);
  }

  Future<void> _scenario1AccountBalance(AppStrings s) async {
    final messageId = DateTime.now().millisecondsSinceEpoch.toString();

    setState(() {
      _messages.add(ChatMessage(
        id: messageId,
        type: MessageType.bot,
        content: s.scenario1BotContent,
        timestamp: DateTime.now(),
        tierLevel: TierLevel.tier1,
        isStreaming: true,
        streamingSteps: s.isArabic
            ? const [
                StreamingStep(label: 'جارٍ الاتصال بنظام البنك الأساسي...'),
                StreamingStep(label: 'جارٍ مصادقة بيانات اعتماد المستخدم...'),
                StreamingStep(label: 'جارٍ جلب بيانات الحساب...'),
              ]
            : const [
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
            if (e.key <= i) return e.value.copyWith(isComplete: true);
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
          content: s.scenario1BotContent,
          timestamp: DateTime.now(),
          tierLevel: TierLevel.tier1,
          confidencePercent: 99,
          sources: [
            SourceInfo(
              name: s.coreBankingSystem,
              metadata: s.lastUpdated2MinAgo,
              url: '#',
            ),
          ],
          actionButtons: [s.viewStatement, s.downloadPDF],
          isStreaming: false,
        );
      }
    });
    _scrollToBottom();
  }

  Future<void> _scenario2TransactionAnalysis(bool isArabic) async {
    final messageId = DateTime.now().millisecondsSinceEpoch.toString();

    setState(() {
      _messages.add(ChatMessage(
        id: messageId,
        type: MessageType.bot,
        content: '',
        timestamp: DateTime.now(),
        tierLevel: TierLevel.tier2,
        isStreaming: true,
        streamingSteps: isArabic
            ? const [
                StreamingStep(label: 'جارٍ تحليل سجل المعاملات...'),
                StreamingStep(label: 'جارٍ تصنيف النفقات...'),
                StreamingStep(label: 'جارٍ مقارنة الأنماط...'),
                StreamingStep(label: 'جارٍ حساب فترات الثقة...'),
              ]
            : const [
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
            if (e.key <= i) return e.value.copyWith(isComplete: true);
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
          content: isArabic
              ? 'إجمالي إنفاقك المقدّر لشهر يناير 2026 هو تقريباً QAR 45,230'
              : 'Your estimated total spending for January 2026 is approximately QAR 45,230',
          timestamp: DateTime.now(),
          tierLevel: TierLevel.tier2,
          confidencePercent: 73,
          warningMessage: isArabic
              ? 'تنبيه جودة البيانات: نطاق خطأ محتمل ± QAR 2,000'
              : 'Data Quality Alert: Possible error range ± QAR 2,000',
          uncertaintyData: const UncertaintyData(
            confirmedAmount: 38445,
            estimatedAmount: 4285,
            uncertainAmount: 2500,
          ),
          sources: isArabic
              ? const [
                  SourceInfo(
                    name: 'قاعدة بيانات المعاملات',
                    metadata: '28 يوماً مكتملاً، 3 أيام جزئية',
                    url: '#',
                  ),
                  SourceInfo(
                    name: 'نظام معالجة البطاقات',
                    metadata: 'آخر مزامنة: منذ 3 أيام',
                    url: '#',
                  ),
                  SourceInfo(
                    name: 'شبكة الصراف الآلي',
                    metadata: 'في الوقت الفعلي',
                  ),
                ]
              : const [
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
          mlReasoning: MLReasoning(points: isArabic
              ? const [
                  'سجلات المعاملات كاملة لـ 28 يوماً',
                  '⚠ 15-17 يناير: بيانات جزئية (صيانة النظام)',
                  '⚠ معاملتان غير متصلتين عبر الصراف الآلي لم تتم مزامنتهما بعد',
                  'تمت المقارنة مع إجماليات كشف الحساب البنكي',
                ]
              : const [
                  '28 days have complete transaction records',
                  '⚠ Jan 15-17: Partial data (system maintenance)',
                  '⚠ 2 offline ATM transactions not yet synced',
                  'Cross-referenced with bank statement totals',
                ]),
          actionButtons: isArabic
              ? const ['عرض البيانات الخام', 'تصدير التفاصيل', 'الإبلاغ عن مشكلة']
              : const ['View Raw Data', 'Export Details', 'Report Issue'],
          isStreaming: false,
        );
      }
    });
    _scrollToBottom();
  }

  Future<void> _scenario3LoanAdvice(bool isArabic, AppStrings s) async {
    final messageId = DateTime.now().millisecondsSinceEpoch.toString();

    setState(() {
      _messages.add(ChatMessage(
        id: messageId,
        type: MessageType.bot,
        content: '',
        timestamp: DateTime.now(),
        tierLevel: TierLevel.tier3,
        isStreaming: true,
        streamingSteps: isArabic
            ? const [
                StreamingStep(label: 'جارٍ معالجة الطلب...'),
                StreamingStep(label: 'جارٍ تحليل نوع الاستعلام...'),
              ]
            : const [
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
            if (e.key <= i) return e.value.copyWith(isComplete: true);
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
          content: isArabic
              ? 'توصيات القروض تتطلب مشورة مالية مخصصة من مستشار مرخص. لا أستطيع تقديم هذه التوجيهات، لكن يمكنني التواصل مع المختص المناسب.'
              : 'Loan recommendations require personalized financial advice from a licensed advisor. I cannot provide this guidance, but I can connect you with the right specialist.',
          timestamp: DateTime.now(),
          tierLevel: TierLevel.tier3,
          showHumanHandoff: true,
          actionButtons: isArabic
              ? const ['عرض منتجات القروض', 'حاسبة القروض']
              : const ['View Loan Products', 'Loan Calculator'],
          isStreaming: false,
        );
      }
    });
    _scrollToBottom();
  }

  Future<void> _scenario4RMRecommendation(bool isArabic) async {
    final messageId = DateTime.now().millisecondsSinceEpoch.toString();

    setState(() {
      _messages.add(ChatMessage(
        id: messageId,
        type: MessageType.bot,
        content: '',
        timestamp: DateTime.now(),
        isStreaming: true,
        streamingSteps: isArabic
            ? const [
                StreamingStep(label: 'جارٍ تحليل محفظة العميل...'),
                StreamingStep(label: 'جارٍ تحديد فرص التفاعل...'),
                StreamingStep(label: 'جارٍ حساب ثقة التوصية...'),
                StreamingStep(label: 'جارٍ إجراء فحوصات التحقق...'),
              ]
            : const [
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
            if (e.key <= i) return e.value.copyWith(isComplete: true);
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
          content: isArabic
              ? 'الإجراء الموصى به: تواصل مع أحمد المنصوري اليوم'
              : 'Recommended Action: Contact Ahmed Al-Mansouri today',
          timestamp: DateTime.now(),
          tierLevel: TierLevel.tier2,
          tierLabel: isArabic
              ? 'مساعد المستشار: توصية العميل'
              : 'RM Assistant: Customer Recommendation',
          confidencePercent: 92,
          customerProfile: const CustomerProfile(
            name: 'Ahmed Al-Mansouri',
            segment: 'Premium',
            relationship: '5 years',
            lastContact: '3 months ago',
            potentialValue: '+15% (recent)',
            riskScore: 'Low',
          ),
          mlReasoning: MLReasoning(points: isArabic
              ? const [
                  'تم اكتشاف زيادة في الراتب: +15% (موثّقة من صاحب العمل)',
                  'مؤشر المرحلة الحياتية: متزوج حديثاً (تم تحديث الملف)',
                  'نمط الادخار: زيادة بنسبة 40% خلال آخر 3 أشهر',
                  'أنماط عملاء مماثلة: 87% تحولوا إلى رهن عقاري خلال 6 أشهر',
                  'نافذة التفاعل: آخر تواصل منذ 3 أشهر (التوقيت مثالي)',
                ]
              : const [
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

    final isArabic = LanguageProvider.of(context).isArabic;
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        _messages.add(ChatMessage(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          type: MessageType.bot,
          content: isArabic
              ? 'شكراً لرسالتك. يرجى استخدام أزرار الإجراءات السريعة أدناه لاستكشاف سيناريوهات العرض التوضيحي.'
              : 'Thank you for your message. Please use the quick action buttons below to explore the demo scenarios with full hallucination safety features.',
          timestamp: DateTime.now(),
        ));
      });
      _scrollToBottom();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isArabic = LanguageProvider.of(context).isArabic;
    final s = AppStrings(isArabic);

    return Scaffold(
      body: Container(
        color: Colors.white,
        child: SafeArea(
          child: Center(
            child: Container(
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
                    _buildHeader(isArabic),
                    _buildFrameworkBanner(s),
                    Expanded(
                      child: Container(
                        color: AppTheme.backgroundLight,
                        child: _messages.isEmpty
                            ? _buildWelcomeMessage(isArabic)
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
                    _buildInputArea(s),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(bool isArabic) {
    final s = AppStrings(isArabic);
    final toggle = LanguageProvider.of(context).toggleLanguage;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      decoration: BoxDecoration(gradient: AppTheme.headerGradient),
      child: Row(
        children: [
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
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Commercial Bank AI Assistant',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  s.hallucinationSafetyEnabled,
                  style: const TextStyle(fontSize: 11, color: Colors.white70),
                ),
              ],
            ),
          ),
          // Language toggle
          Semantics(
            button: true,
            label: isArabic ? 'Switch to English' : 'التبديل إلى العربية',
            child: GestureDetector(
              onTap: toggle,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white.withOpacity(0.5)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'EN',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight:
                            !isArabic ? FontWeight.bold : FontWeight.normal,
                        color: !isArabic ? Colors.white : Colors.white54,
                      ),
                    ),
                    const Text(
                      ' | ',
                      style: TextStyle(fontSize: 12, color: Colors.white38),
                    ),
                    Text(
                      'AR',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight:
                            isArabic ? FontWeight.bold : FontWeight.normal,
                        color: isArabic ? Colors.white : Colors.white54,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFrameworkBanner(AppStrings s) {
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
          Text(
            '🔬 ${s.activeSafetyFeatures}:',
            style: const TextStyle(
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
              _buildFeatureItem(s.confidenceScoring),
              _buildFeatureItem(s.sourceAttribution),
              _buildFeatureItem(s.streamingValidation),
              _buildFeatureItem(s.accountabilityTracking),
              _buildFeatureItem(s.humanHandoff),
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
          style: const TextStyle(fontSize: 12, color: AppTheme.infoText),
        ),
      ],
    );
  }

  Widget _buildWelcomeMessage(bool isArabic) {
    return ListView(
      padding: const EdgeInsets.all(AppTheme.paddingLarge),
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppTheme.tier1Bg,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        isArabic ? 'رسالة النظام' : 'System Message',
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.tier1Text,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      isArabic
                          ? 'مرحباً بك في مساعد البنك التجاري الذكي'
                          : 'Welcome to Commercial Bank AI Assistant',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      isArabic
                          ? 'تم تصميمي مع بروتوكولات للحد من الهلوسة. كل استجابة تتضمن: تقييم الثقة، ونسب المصدر، وتتبع المساءلة.'
                          : "I'm designed with hallucination mitigation protocols. Every response includes: confidence scoring, source attribution, and accountability tracking.",
                      style: const TextStyle(
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

  Widget _buildInputArea(AppStrings s) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: const Border(
          top: BorderSide(color: Color(0xFFe9ecef), width: 1),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        children: [
          // On narrow screens (<360 px) the buttons form a 2×2 grid;
          // on wider screens they stay in a single row.
          LayoutBuilder(builder: (context, constraints) {
            final w = constraints.maxWidth;
            final isNarrow = w < 360;
            final btnW = isNarrow ? (w - 8) / 2 : (w - 24) / 4;
            return Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _buildActionBtn(
                  icon: Icons.account_balance_wallet_outlined,
                  label: s.balance,
                  onTap: () => _runScenario(1),
                  width: btnW,
                ),
                _buildActionBtn(
                  icon: Icons.receipt_long_outlined,
                  label: s.transactions,
                  onTap: () => _runScenario(2),
                  width: btnW,
                ),
                _buildActionBtn(
                  icon: Icons.request_quote_outlined,
                  label: s.loan,
                  onTap: () => _runScenario(3),
                  width: btnW,
                ),
                _buildActionBtn(
                  icon: Icons.people_outline,
                  label: s.rmTips,
                  onTap: () => _runScenario(4),
                  width: btnW,
                ),
              ],
            );
          }),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _textController,
                  decoration: InputDecoration(
                    hintText: s.askMeAnything,
                    hintStyle: const TextStyle(color: AppTheme.textSecondary),
                  ),
                  onSubmitted: (_) => _sendMessage(),
                ),
              ),
              const SizedBox(width: 10),
              Semantics(
                button: true,
                label: 'Send message',
                child: Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    gradient: AppTheme.headerGradient,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.send_rounded,
                        color: Colors.white, size: 20),
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

  Widget _buildActionBtn({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    required double width,
  }) {
    return SizedBox(
      width: width,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: _isProcessing ? null : onTap,
          borderRadius: BorderRadius.circular(10),
          child: Opacity(
            opacity: _isProcessing ? 0.5 : 1.0,
            child: Container(
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: AppTheme.primaryBurgundy.withOpacity(0.25),
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.primaryBurgundy.withOpacity(0.06),
                    blurRadius: 4,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(icon, size: 15, color: AppTheme.primaryBurgundy),
                  const SizedBox(width: 5),
                  Flexible(
                    child: Text(
                      label,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
