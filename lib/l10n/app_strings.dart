class AppStrings {
  final bool isArabic;
  const AppStrings(this.isArabic);

  // Header
  String get safetyModeActive =>
      isArabic ? 'وضع الأمان نشط' : 'Safety Mode Active';
  String get hallucinationSafetyEnabled =>
      isArabic ? 'إطار أمان الهلوسة مفعّل' : 'Hallucination Safety Framework Enabled';

  // Framework banner
  String get activeSafetyFeatures =>
      isArabic ? 'ميزات الأمان النشطة' : 'Active Safety Features';
  String get confidenceScoring =>
      isArabic ? 'تقييم الثقة' : 'Confidence Scoring';
  String get sourceAttribution =>
      isArabic ? 'نسب المصدر' : 'Source Attribution';
  String get streamingValidation =>
      isArabic ? 'التحقق المتدفق' : 'Streaming Validation';
  String get accountabilityTracking =>
      isArabic ? 'تتبع المساءلة' : 'Accountability Tracking';
  String get humanHandoff =>
      isArabic ? 'التحويل البشري' : 'Human Handoff';

  // Input area quick buttons
  String get balance => isArabic ? 'الرصيد' : 'Balance';
  String get transactions => isArabic ? 'المعاملات' : 'Transactions';
  String get loan => isArabic ? 'القرض' : 'Loan';
  String get rmTips => isArabic ? 'نصائح المستشار' : 'RM Tips';
  String get askMeAnything =>
      isArabic ? 'اسألني أي شيء...' : 'Ask me anything...';

  // Scenario 1 – account balance
  String get scenario1UserMessage =>
      isArabic ? 'ما هو رصيدي الحالي؟' : 'What is my current account balance?';
  String get scenario1BotContent =>
      isArabic
          ? 'رصيدك الحالي هو QAR 45,230.50'
          : 'Your current account balance is QAR 45,230.50';
  String get coreBankingSystem =>
      isArabic ? 'نظام البنك الأساسي' : 'Core Banking System';
  String get lastUpdated2MinAgo =>
      isArabic ? 'آخر تحديث: منذ دقيقتين' : 'Last updated: 2 minutes ago';
  String get viewStatement =>
      isArabic ? 'عرض الكشف' : 'View Statement';
  String get downloadPDF =>
      isArabic ? 'تحميل PDF' : 'Download PDF';

  // Human hand-off
  String get connectWithSpecialist =>
      isArabic ? 'تواصل مع متخصص' : 'Connect with a Specialist';
  String get scheduleCall =>
      isArabic ? 'جدولة مكالمة' : 'Schedule Call';
  String get liveChatNow =>
      isArabic ? 'دردشة مباشرة الآن' : 'Live Chat Now';

  // Confidence indicator
  String get confidenceScore =>
      isArabic ? 'درجة الثقة' : 'CONFIDENCE SCORE';
  String get highConfidenceLabel =>
      isArabic
          ? '✓ ثقة عالية - استعلام مباشر من قاعدة البيانات'
          : '✓ High Confidence - Direct database query, real-time data';

  // Source attribution
  String get dataSources =>
      isArabic ? 'مصادر البيانات' : 'Data Sources';

  // Accountability checkpoint
  String get accountabilityCheckpoint =>
      isArabic ? 'نقطة تفتيش المساءلة' : 'Accountability Checkpoint';
  String get approveAndSchedule =>
      isArabic ? 'موافقة وجدولة' : 'Approve & Schedule';
  String get decline => isArabic ? 'رفض' : 'Decline';
}
