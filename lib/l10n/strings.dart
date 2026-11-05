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
  String get assistant => _t('AI assistant', 'مساعد ذكي');
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
      ? [
          'قراءة المعاملات (28 من 31 يوماً)…',
          'قراءة معالجة البطاقات (آخر مزامنة قبل 3 أيام)…',
          'المقارنة مع إجماليات الكشف…'
        ]
      : [
          'Reading transactions (28 of 31 days)…',
          'Reading card processing (last synced 3 days ago)…',
          'Cross-checking statement totals…'
        ];

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

  // Scenario 4 – staff
  String get q4 => _t('Which client should I contact today?', 'أي عميل يجب أن أتواصل معه اليوم؟');
  String get staffView => _t('Relationship manager view', 'واجهة مدير العلاقة');
  String get clientName => _t('Ahmed Al-Mansouri', 'أحمد المنصوري');
  String get clientLabel => _t('Client flagged by the AI', 'عميل حدده الذكاء الاصطناعي');
  String get segment => _t('Segment', 'الفئة');
  String get segmentValue => _t('Premium', 'مميز');
  String get clientSince => _t('Client for', 'عميل منذ');
  String get clientSinceValue => _t('5 years', '5 سنوات');
  String get lastContact => _t('Last contact', 'آخر تواصل');
  String get lastContactValue => _t('3 months ago', 'قبل 3 أشهر');
  String get debtToIncome => _t('Debt to income', 'نسبة الدين إلى الدخل');
  String get debtToIncomeValue => _t('18% · within policy', '18% · ضمن السياسة');
  // Independent first read
  String get firstReadTitle => _t('Your read first', 'رأيك أولاً');
  String get firstReadQ => _t(
      'Before you see the AI’s suggestion: should this client be contacted about a home loan now?',
      'قبل أن ترى اقتراح الذكاء الاصطناعي: هل يجب التواصل مع هذا العميل بشأن تمويل سكني الآن؟');
  String get yes => _t('Yes', 'نعم');
  String get no => _t('No', 'لا');
  String get notSure => _t('Not sure', 'لست متأكداً');
  // The suggestion
  String get recommended => _t('AI suggestion', 'اقتراح الذكاء الاصطناعي');
  String get rmAction => _t('Contact Ahmed Al-Mansouri today about a home loan',
      'تواصل مع أحمد المنصوري اليوم بشأن تمويل سكني');
  String get evidenceTitle => _t('What the suggestion is based on', 'ما يستند إليه الاقتراح');
  String get evSalary => _t('Salary up 15%', 'زيادة الراتب 15%');
  String get evSalaryMeta =>
      _t('payroll deposits · verified with employer', 'إيداعات الرواتب · موثّقة من صاحب العمل');
  String get evSavings => _t('Savings up 40% in 3 months', 'زيادة المدخرات 40% خلال 3 أشهر');
  String get evSavingsMeta => _t('account balances', 'أرصدة الحسابات');
  String get evMarried => _t('Recently married', 'متزوج حديثاً');
  String get evMarriedMeta => _t(
      'inferred from a joint account opened Sep 2026 · not confirmed by the client · sensitive',
      'مستنتج من حساب مشترك فُتح في سبتمبر 2026 · لم يؤكده العميل · بيانات حساسة');
  String get yourRead => _t('Your first read', 'رأيك الأول');
  // Checks and decision
  String get checksTitle => _t('Before you decide, check', 'قبل أن تقرر، تحقّق من');
  String get check1 => _t('Where “recently married” comes from, and that it may be used',
      'مصدر معلومة “متزوج حديثاً”، وأنه يجوز استخدامها');
  String get check2 => _t('Affordability against income and commitments',
      'القدرة على السداد مقارنة بالدخل والالتزامات');
  String get check3 => _t(
      'No signs of vulnerability or financial difficulty', 'لا مؤشرات على هشاشة أو صعوبات مالية');
  String get decisionTitle => _t('Your decision', 'قرارك');
  String get approve => _t('Approve', 'موافقة');
  String get decline => _t('Decline', 'رفض');
  String get reasonHint => _t('Reason (required)', 'السبب (مطلوب)');
  List<String> get approveReasons => ar
      ? [
          'يتوافق مع أهداف العميل المعلنة',
          'الحدث الحياتي تم تأكيده مع العميل',
          'القدرة على السداد ضمن السياسة',
          'أخرى'
        ]
      : [
          'Matches the client’s stated goals',
          'Life event confirmed with the client',
          'Affordability within policy',
          'Other'
        ];
  List<String> get declineReasons => ar
      ? [
          'بيانات العميل غير كافية',
          'يلزم تقييم المخاطر',
          'الاستنتاج غير مؤكد',
          'العميل غير مؤهل',
          'أخرى'
        ]
      : [
          'Not enough client data',
          'Risk assessment needed',
          'Inference not confirmed',
          'Client not eligible',
          'Other'
        ];
  String get signOff => _t('Sign off', 'اعتماد');
  String get checksNeeded =>
      _t('Complete the three checks to approve.', 'أكمل الفحوصات الثلاثة للموافقة.');
  String get sampledNote => _t('Reasons are sampled and reviewed by a second line.',
      'تُراجَع عينة من الأسباب من قِبل خط رقابة ثانٍ.');
  // Receipt
  String get receiptTitle => _t('Decision logged', 'تم تسجيل القرار');
  String get rDecision => _t('Decision', 'القرار');
  String get rApproved => _t('Approved', 'موافقة');
  String get rDeclined => _t('Declined', 'رفض');
  String get rReason => _t('Reason', 'السبب');
  String get rFirstRead => _t('First read', 'الرأي الأول');
  String get rBy => _t('Signed off by', 'اعتمده');
  String get rByValue => _t('You · relationship manager', 'أنت · مدير العلاقة');
  String get rTime => _t('Time', 'الوقت');
  String get rModel => _t('Model', 'النموذج');
  String get rSession => _t('Session', 'الجلسة');
  List<String> get steps4 => ar
      ? ['قراءة محفظة العملاء…', 'التحقق من سجل التواصل…', 'إجراء فحوصات السياسة…']
      : ['Reading the client portfolio…', 'Checking contact history…', 'Running policy checks…'];

  // Talk to a person, always available
  String get talkToPerson => _t('Talk to a person', 'التحدث مع شخص');
  String get qPerson => _t('I’d like to talk to a person.', 'أود التحدث مع شخص.');
  String get personAnswer => _t(
      'Of course. Choose how you’d like to reach us.', 'بالتأكيد. اختر طريقة التواصل التي تناسبك.');

  // Feedback on any answer
  String get wrongAnswer => _t('Something wrong with this answer?', 'هل هناك خطأ في هذه الإجابة؟');
  String get wrongThanks =>
      _t('Thanks. A person will review this answer.', 'شكراً. سيراجع شخص هذه الإجابة.');

  // Stop while working
  String get stop => _t('Stop', 'إيقاف');
  String get stopped => _t('Stopped. Nothing was changed.', 'تم الإيقاف. لم يتغير شيء.');

  // Estimated / unsynced items (spending)
  String get estItemsTitle => _t('Estimated items', 'العناصر المقدَّرة');
  String get estItemsLead => _t(
      'Card payments from Oct 15–17, when card data was incomplete. Amounts are from merchant authorisations and may change.',
      'مدفوعات البطاقة من 15 إلى 17 أكتوبر، حين كانت بيانات البطاقات غير مكتملة. المبالغ من تفويضات التجار وقد تتغير.');
  List<(String, String, String)> get estItems => ar
      ? [
          ('سوبرماركت', '15 أكتوبر', '1,240'),
          ('مطعم', '15 أكتوبر', '865'),
          ('صيدلية', '16 أكتوبر', '612'),
          ('محطة وقود', '16 أكتوبر', '540'),
          ('متجر إلكترونيات', '17 أكتوبر', '718'),
          ('طلب عبر الإنترنت', '17 أكتوبر', '310')
        ]
      : [
          ('Supermarket', 'Oct 15', '1,240'),
          ('Restaurant', 'Oct 15', '865'),
          ('Pharmacy', 'Oct 16', '612'),
          ('Fuel station', 'Oct 16', '540'),
          ('Electronics store', 'Oct 17', '718'),
          ('Online order', 'Oct 17', '310')
        ];
  String get atmItemsTitle => _t('Not yet synced', 'لم تتم مزامنته');
  String get atmItemsLead => _t(
      'Cash withdrawals made at offline ATMs. They’ll appear once the ATM reconnects.',
      'سحوبات نقدية من صرافات آلية غير متصلة. ستظهر عند إعادة اتصال الصراف.');
  List<(String, String, String)> get atmItems => ar
      ? [
          ('صراف آلي · مول المدينة', '29 أكتوبر', '1,500'),
          ('صراف آلي · المطار', '30 أكتوبر', '1,000')
        ]
      : [('ATM · City Mall', 'Oct 29', '1,500'), ('ATM · Airport', 'Oct 30', '1,000')];

  // Free text
  String get fallback => _t(
      'This demo answers four scripted examples. Pick one from Examples, or use Talk to a person.',
      'هذا العرض يجيب على أربعة أمثلة مُعدّة مسبقاً. اختر أحدها من الأمثلة، أو استخدم التحدث مع شخص.');
}
