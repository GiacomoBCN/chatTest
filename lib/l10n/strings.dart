import 'package:flutter/widgets.dart';
import '../app_scope.dart';

/// Every user-facing string, English and Arabic side by side.
class S {
  final bool ar;
  const S(this.ar);

  static S of(BuildContext context) => S(AppScope.of(context).isArabic);

  String _t(String en, String arabic) => ar ? arabic : en;

  // Brand
  String get bank => _t('Falak', 'فلك');
  String get assistant => _t('AI assistant', 'مساعد ذكاء اصطناعي');
  String get bankTagline =>
      _t('Fictional bank · AI assistant concept', 'بنك خيالي · مفهوم لمساعد ذكي');
  String get currency => _t('AED', 'د.إ');

  // Controls
  String get english => 'EN';
  String get arabic => 'عربي';
  String get switchToDark => _t('Switch to dark theme', 'التبديل إلى الوضع الداكن');
  String get switchToLight => _t('Switch to light theme', 'التبديل إلى الوضع الفاتح');
  String get restart => _t('Start over', 'البدء من جديد');
  String get examples => _t('Examples', 'أمثلة');
  String get askPlaceholder => _t('Ask Falak…', 'اسأل فلك…');
  String get send => _t('Send', 'إرسال');
  String get notInDemo => _t('Not available in this demo.', 'غير متاح في هذا العرض التوضيحي.');
  String get languageLabel => _t('Language', 'اللغة');

  // Index of examples
  String get indexTitle =>
      _t('Four ways an AI answer earns trust', 'أربع طرق يكسب بها رد الذكاء الاصطناعي الثقة');
  String get indexLead => _t(
      'Each example shows a different behaviour. Pick one to run it in the chat.',
      'كل مثال يُظهر سلوكاً مختلفاً. اختر مثالاً لتشغيله في المحادثة.');
  String get forCustomers => _t('For customers', 'للعملاء');
  String get forStaff => _t('For bank staff', 'لموظفي البنك');
  String get indexFine => _t('Scripted demo. Names, figures and the bank are invented.',
      'عرض توضيحي مُعدّ مسبقاً. الأسماء والأرقام والبنك من نسج الخيال.');

  String get exBalance => _t('Balance', 'الرصيد');
  String get exBalanceDesc => _t('A fact read from your account, shown with where it came from.',
      'معلومة مقروءة من حسابك، مع مصدرها.');
  String get exSpending => _t('Spending', 'الإنفاق');
  String get exSpendingDesc => _t('An estimate that separates what is confirmed from what is not.',
      'تقدير يفصل بين ما هو مؤكد وما ليس كذلك.');
  String get exLoan => _t('Loan advice', 'استشارة قرض');
  String get exLoanDesc => _t('Outside what an AI should decide, so it hands you to a person.',
      'خارج ما يجب أن يقرره الذكاء الاصطناعي، لذا يحيلك إلى شخص.');
  String get exClient => _t('Client to contact', 'عميل للتواصل');
  String get exClientDesc => _t('The AI suggests, a relationship manager decides and signs off.',
      'الذكاء الاصطناعي يقترح، ومدير العلاقة يقرر ويعتمد.');

  // Disclosure
  String get discTitle =>
      _t("You're chatting with an AI assistant.", 'أنت تتحدث مع مساعد ذكاء اصطناعي.');
  String get discBody => _t(
      'It shows where each answer comes from, and hands you to a person when it should.',
      'يوضح مصدر كل إجابة، ويحيلك إلى شخص عندما يلزم ذلك.');

  // Trust marks
  String get markSystem => _t('From your account', 'من حسابك');
  String get markEstimate => _t('Estimate', 'تقدير');
  String get markUnconfirmed => _t('Not yet confirmed', 'غير مؤكد بعد');
  String get markPerson => _t('Needs a person', 'يتطلب شخصاً');

  // Scenario 1 – balance
  String get q1 => _t("What's my current balance?", 'ما هو رصيدي الحالي؟');
  String get currentAccount => _t('Current account', 'الحساب الجاري');
  String get balanceSource =>
      _t('core banking · 2 min ago', 'النظام المصرفي الأساسي · قبل دقيقتين');
  String get viewStatement => _t('View statement', 'عرض الكشف');
  String get downloadPdf => _t('Download PDF', 'تنزيل PDF');
  List<String> get steps1 => ar
      ? [
          'جارٍ الاتصال بالنظام المصرفي الأساسي…',
          'جارٍ التحقق من الجلسة…',
          'جارٍ جلب بيانات الحساب…'
        ]
      : ['Connecting to core banking…', 'Checking your session…', 'Fetching account data…'];

  // Scenario 2 – spending
  String get q2 => _t('How much did I spend last month?', 'كم أنفقت الشهر الماضي؟');
  String get spendingTitle => _t('Spending in October', 'الإنفاق في أكتوبر');
  String get spendingRange => _t('Between 38,445 and 45,230. 3 of 31 days are still incomplete.',
      'بين 38,445 و45,230. لا تزال 3 أيام من أصل 31 غير مكتملة.');
  String get confirmed => _t('Confirmed', 'مؤكد');
  String get estimatedLink => _t('Estimated · see 6 items', 'مُقدَّر · عرض 6 عناصر');
  String get unsyncedLink => _t('Not yet synced · 2 ATM', 'لم تتم مزامنته · 2 صراف آلي');
  String get sourcesTitle => _t('Sources used', 'المصادر المستخدمة');
  String get srcTx =>
      _t('Transactions · 28 of 31 days complete', 'المعاملات · 28 من 31 يوماً مكتملة');
  String get srcCards =>
      _t('Card processing · last synced 3 days ago', 'معالجة البطاقات · آخر مزامنة قبل 3 أيام');
  String get srcAtm => _t('ATM network · real time', 'شبكة الصراف الآلي · فوري');
  String get whyTitle => _t('Why this answer', 'لماذا هذه الإجابة');
  List<String> get why2 => ar
      ? [
          'سجلات المعاملات كاملة لـ 28 يوماً',
          '15–17 أكتوبر: بيانات جزئية (صيانة النظام)',
          'معاملتان عبر الصراف الآلي لم تتم مزامنتهما بعد',
          'تمت المقارنة مع إجماليات كشف الحساب'
        ]
      : [
          '28 days have complete transaction records',
          'Oct 15–17: partial data (system maintenance)',
          '2 offline ATM withdrawals not yet synced',
          'Cross-checked against statement totals'
        ];
  List<bool> get why2Warn => const [false, true, true, false];
  String get reportIssue => _t('Report an issue', 'الإبلاغ عن مشكلة');
  List<String> get steps2 => ar
      ? ['جارٍ قراءة المعاملات…', 'جارٍ قراءة بيانات البطاقات…', 'جارٍ مقارنة الإجماليات…']
      : ['Reading transactions…', 'Reading card data…', 'Cross-checking totals…'];

  // Scenario 3 – loan
  String get q3 => _t('Should I take out a personal loan?', 'هل يجب أن آخذ قرضاً شخصياً؟');
  String get loanAnswer => _t(
      'Whether a loan is right for you depends on your situation, so a licensed advisor should answer this. I can connect you now.',
      'ملاءمة القرض لك تعتمد على وضعك، لذا يجب أن يجيب على ذلك مستشار مرخّص. يمكنني توصيلك الآن.');
  String get chatAdvisor => _t('Chat with an advisor', 'محادثة مع مستشار');
  String get chatAdvisorMeta => _t('About 4 min wait', 'انتظار نحو 4 دقائق');
  String get bookCall => _t('Book a call', 'حجز مكالمة');
  String get bookCallMeta => _t('Tomorrow, 9:00–12:00', 'غداً، 9:00–12:00');
  String get handoffShare => _t(
      'Your conversation will be shared with the advisor, so you won’t have to repeat yourself.',
      'ستتم مشاركة محادثتك مع المستشار، فلن تحتاج إلى التكرار.');
  String get loanProducts => _t('Loan products', 'منتجات القروض');
  String get loanCalculator => _t('Loan calculator', 'حاسبة القروض');
  List<String> get steps3 => ar
      ? ['جارٍ فهم الطلب…', 'جارٍ التحقق من نطاق المساعد…']
      : ['Understanding the request…', 'Checking what the assistant may answer…'];

  // Scenario 4 – staff
  String get q4 => _t('Which client should I contact today?', 'أي عميل يجب أن أتواصل معه اليوم؟');
  String get staffView => _t('Relationship manager view', 'واجهة مدير العلاقة');
  String get recommended => _t('Suggested action', 'الإجراء المقترح');
  String get rmAction => _t('Contact Ahmed Al-Mansouri today', 'تواصل مع أحمد المنصوري اليوم');
  String get clientName => _t('Ahmed Al-Mansouri', 'أحمد المنصوري');
  String get segment => _t('Segment', 'الفئة');
  String get segmentValue => _t('Premium', 'مميز');
  String get clientSince => _t('Client for', 'عميل منذ');
  String get clientSinceValue => _t('5 years', '5 سنوات');
  String get lastContact => _t('Last contact', 'آخر تواصل');
  String get lastContactValue => _t('3 months ago', 'قبل 3 أشهر');
  String get risk => _t('Risk', 'المخاطر');
  String get riskValue => _t('Low', 'منخفضة');
  List<String> get why4 => ar
      ? [
          'زيادة في الراتب: ‎+15%‎ (موثّقة من صاحب العمل)',
          'مؤشر مرحلة حياتية: متزوج حديثاً (تم تحديث الملف)',
          'المدخرات: زيادة بنسبة 40% خلال آخر 3 أشهر',
          'آخر تواصل قبل 3 أشهر'
        ]
      : [
          'Salary increase: +15% (verified with employer)',
          'Life stage: recently married (profile updated)',
          'Savings up 40% over the last 3 months',
          'Last contact 3 months ago'
        ];
  String get checkpointTitle => _t('Your decision', 'قرارك');
  String get attestation => _t(
      'I have reviewed the client data and the AI suggestion, and this action fits bank policy and the client’s interests.',
      'لقد راجعت بيانات العميل واقتراح الذكاء الاصطناعي، وهذا الإجراء يتوافق مع سياسة البنك ومصلحة العميل.');
  String get declineReasonHint => _t('Reason for declining', 'سبب الرفض');
  List<String> get declineReasons => ar
      ? [
          'بيانات العميل غير كافية',
          'يلزم تقييم المخاطر',
          'يلزم موافقة المدير',
          'العميل غير مؤهل',
          'أخرى'
        ]
      : [
          'Not enough client data',
          'Risk assessment needed',
          'Manager approval needed',
          'Client not eligible',
          'Other'
        ];
  String get approve => _t('Approve', 'موافقة');
  String get decline => _t('Decline', 'رفض');
  String get auditNote => _t('Your decision is logged for audit. Session FLK-2026-1105-4521',
      'يُسجَّل قرارك لأغراض التدقيق. الجلسة FLK-2026-1105-4521');
  String get approvedToast =>
      _t('Suggestion approved and logged.', 'تمت الموافقة على الاقتراح وتسجيله.');
  String get declinedToast => _t('Suggestion declined and logged.', 'تم رفض الاقتراح وتسجيله.');
  List<String> get steps4 => ar
      ? ['جارٍ مراجعة محفظة العملاء…', 'جارٍ البحث عن فرص التواصل…', 'جارٍ إجراء فحوصات التحقق…']
      : [
          'Reviewing the client portfolio…',
          'Looking for contact opportunities…',
          'Running validation checks…'
        ];

  // Free text
  String get fallback => _t('This demo answers four scripted examples. Open Examples to run one.',
      'هذا العرض يجيب على أربعة أمثلة مُعدّة مسبقاً. افتح الأمثلة لتشغيل أحدها.');
}
