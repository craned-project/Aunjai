import 'package:flutter/material.dart';
import 'package:aunjai/questionlist.dart';
import 'package:go_router/go_router.dart';

// 🎯 Enum for controlling the UI state
enum CallUIState {
  initial, // Main Chat & Analysis Page
  multipleChoice, // Separated: Multiple choice question
  textAnswer, // Separated: Text input question
}

class CallMode extends StatefulWidget {
  const CallMode({super.key});

  @override
  State<CallMode> createState() => _CallModeState();
}

class _CallModeState extends State<CallMode> {
  // Game State Variables
  CallUIState currentState = CallUIState.initial;
  Set<String> activeContextTags = {};
  Question? currentQuestion;
  List<Question> unaskedQuestions = [];
  int questionsAskedCount = 0;
  static const int maxQuestions = 5;

  // Track max possible points vs accumulated points per category
  int actionEarned = 0;
  int actionMax = 0;
  int identityEarned = 0;
  int identityMax = 0;
  int contextEarned = 0;
  int contextMax = 0;

  // Final percentage scores to pass directly to your UI Result Page
  double finalActionRiskPercentage = 0.0;
  double finalIdentityRiskPercentage = 0.0;
  double finalContextRiskPercentage = 0.0;

  /// Initializes the engine with your test question pool
  void initializeGame() {
    unaskedQuestions = List.from(getTestQuestions());
    currentState = CallUIState.initial;
    activeContextTags.clear();
    questionsAskedCount = 0;
    currentQuestion = null;

    // Reset score buckets
    actionEarned = 0;
    identityEarned = 0;
    contextEarned = 0;

    // CHANGE THIS: Set a baseline max ceiling so categories never divide by zero
    actionMax = 100;
    identityMax = 100;
    contextMax = 100;

    finalActionRiskPercentage = 0.0;
    finalIdentityRiskPercentage = 0.0;
    finalContextRiskPercentage = 0.0;
  }

  /// Helper to route points to the correct bucket based on question tags
  void _addPointsToCategory(
    Set<String> tags,
    int earnedPoints,
    int maxPossiblePoints,
  ) {
    // 1. Action Risk Category
    if (tags.contains('crypto') || tags.contains('urgency')) {
      actionEarned += earnedPoints;
      actionMax += maxPossiblePoints;
    }

    // 2. Identity Risk Category
    if (tags.contains('phishing')) {
      identityEarned += earnedPoints;
      identityMax += maxPossiblePoints;
    }

    // 3. Context Risk Category (Explicitly check for 'context' tag)
    if (tags.contains('context') || (!tags.contains('crypto') && !tags.contains('urgency') && !tags.contains('phishing'))) {
      contextEarned += earnedPoints;
      contextMax += maxPossiblePoints;
    }
  }

  /// Step 1: User submits their initial concern
  void handleInitialInput({
    String? textInput,
    List<String>? chosenCategoryTags,
  }) {
    if (chosenCategoryTags != null && chosenCategoryTags.isNotEmpty) {
      for (var tag in chosenCategoryTags) {
        activeContextTags.add(tag);
        _addPointsToCategory({tag}, 25, 25);
      }
    }
    if (textInput != null && textInput.isNotEmpty) {
      _scanTextForInitialTags(textInput);
    }
    moveToNextQuestion();
  }

  /// Step 2: Pick the next question using Akinator-style tag relevance
  void moveToNextQuestion() {
    // Check stopping conditions (e.g., if we run out of questions or hit max questions)
    if (questionsAskedCount >= maxQuestions || unaskedQuestions.isEmpty) {
      endGameAndShowVerdict();
      return;
    }

    Question? bestNextQuestion;
    int highestMatchCount = -1;

    // Scan remaining questions for matching context tags
    for (var question in unaskedQuestions) {
      final matchCount = question.relevantTags
          .intersection(activeContextTags)
          .length;
      if (matchCount > highestMatchCount) {
        highestMatchCount = matchCount;
        bestNextQuestion = question;
      }
    }

    // Fallback if no tags intersect
    bestNextQuestion ??= unaskedQuestions.first;

    unaskedQuestions.remove(bestNextQuestion);
    questionsAskedCount++;
    currentQuestion = bestNextQuestion;

    _updateUI(bestNextQuestion.type);
  }

  /// Step 3: Handle Multiple Choice Selection
  void submitMultipleChoiceAnswer(Choice selectedChoice) {
    if (currentQuestion != null && currentQuestion!.choice != null) {
      // Find the highest possible score in this question to calculate a proper ratio
      int maxQuestionScore = currentQuestion!.choice!
          .map((c) => c.score)
          .reduce((value, element) => value > element ? value : element);

      _addPointsToCategory(
        currentQuestion!.relevantTags,
        selectedChoice.score,
        maxQuestionScore,
      );
      activeContextTags.addAll(currentQuestion!.relevantTags);
    }

    moveToNextQuestion();
  }

  /// Step 4: Handle Text Input Submission
  void submitTextAnswer(String userInput) {
    if (currentQuestion == null || currentQuestion!.targetKeywords == null) {
      moveToNextQuestion();
      return;
    }

    int earned = 0;
    const int maxTextScore = 25;
    final lowerInput = userInput.toLowerCase();

    for (var keyword in currentQuestion!.targetKeywords!) {
      if (lowerInput.contains(keyword.toLowerCase())) {
        earned = maxTextScore; // High bump for hitting a trap keyword
        break;
      }
    }

    _addPointsToCategory(currentQuestion!.relevantTags, earned, maxTextScore);

    if (earned > 0) {
      _addPointsToCategory(currentQuestion!.relevantTags, earned, maxTextScore);
      activeContextTags.addAll(currentQuestion!.relevantTags);
    }

    moveToNextQuestion();
  }

  /// Scanning utility for initial onboarding screen text
  void _scanTextForInitialTags(String text) {
    final lowerText = text.toLowerCase();
    Set<String> matchedTags = {};

    if (lowerText.contains('crypto') || lowerText.contains('bitcoin'))
      matchedTags.add('crypto');
    if (lowerText.contains('delivery') ||
        lowerText.contains('link') ||
        lowerText.contains('url'))
      matchedTags.add('phishing');
    if (lowerText.contains('urgent') ||
        lowerText.contains('police') ||
        lowerText.contains('hack'))
      matchedTags.add('urgency');

    if (matchedTags.isNotEmpty) {
      activeContextTags.addAll(matchedTags);
      _addPointsToCategory(matchedTags, 25, 25);
    }
  }

  void _updateUI(QuestionType qtype) {
    // UI hooks go here (e.g., notifyListeners() if using ChangeNotifier)
    setState(() {
      if (qtype == QuestionType.multipleChoice) {
        currentState = CallUIState.multipleChoice;
      } else {
        currentState = CallUIState.textAnswer;
      }
    });
  }

  /// Calculates dynamic ratio percentages mapped out of 30%, 35%, and 35%
  void endGameAndShowVerdict() {
    // Calculate raw severity ratios (0.0 to 1.0) per category
    double actionRatio = actionMax > 0 ? (actionEarned / actionMax) : 0.0;
    double identityRatio = identityMax > 0
        ? (identityEarned / identityMax)
        : 0.0;
    double contextRatio = contextMax > 0 ? (contextEarned / contextMax) : 0.0;

    print(
      "${actionRatio * 100}% | ${identityRatio * 100}% | ${contextRatio * 100}%",
    );

    context.go(
      '/call/result',
      extra: {
        'actionRisk': actionRatio,
        'identityRisk': identityRatio,
        'contextRisk': contextRatio,
      },
    );
  }

  String? selectedCategoryTag;
  // ⚙️ Change this value to switch between different screens!
  String topic = "เขาโทรมาอ้างว่าเป็นตำรวจ";

  final TextEditingController _chatController = TextEditingController();
  final TextEditingController _answerController = TextEditingController();

  final Set<String> _selectedChips = {};

  @override
  void dispose() {
    _chatController.dispose();
    _answerController.dispose();
    super.dispose();
  }

  List<String> _getMappedTagsFromSelection() {
    List<String> tags = [];
    if (_selectedChips.contains("ขอข้อมูลส่วนตัว")) tags.add("phishing");
    if (_selectedChips.contains("เร่งให้โอนเงิน")) tags.add("urgency");
    if (_selectedChips.contains("อ้างเป็นหน่วยงาน")) tags.add("phishing");
    if (_selectedChips.contains("ไม่แน่ใจ")) tags.add("context");
    return tags;
  }

  @override
  void initState() {
    super.initState();
    // Load your questions when the screen opens
    unaskedQuestions = List.from(getTestQuestions());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff091026),
      body: Container(
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment(0, -0.2),
            radius: 0.8,
            colors: [
              Color(0xff1e1b4b), // Glowing deep purple center
              Color(0xff091026), // Main background color
            ],
            stops: [0.0, 1.0],
          ),
        ),
        child: SafeArea(
          bottom: false,
          child: Column(
            children: [
              // 1. App Bar (Shared across all pages)
              _buildAppBar(context),

              // 2. Main Content (Scrollable top to down)
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics(),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24.0,
                    vertical: 16.0,
                  ),
                  child: Column(
                    children: [
                      // 🎯 SEPARATED PAGE CONTENT
                      if (currentState == CallUIState.initial) ...[
                        _buildInitialState(),
                        const SizedBox(height: 24),
                        _buildMockChatHistory(),
                      ] else if (currentState ==
                          CallUIState.multipleChoice) ...[
                        _buildMultipleChoiceState(currentQuestion!),
                      ] else if (currentState == CallUIState.textAnswer) ...[
                        _buildTextAnswerState(currentQuestion!),
                      ],
                    ],
                  ),
                ),
              ),

              // 3. Bottom Chat Input (🎯 Brought back for ALL modes!)
              _buildChatInput(),
            ],
          ),
        ),
      ),
    );
  }

  // ==========================================
  // Main UI Components
  // ==========================================

  Widget _buildAppBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => context.go('/home'),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.05),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.arrow_back,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
          const SizedBox(width: 16),
          const Text(
            "AunJai Assistant",
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  // ------------------------------------------
  // State 1: Initial
  // ------------------------------------------
  Widget _buildInitialState() {
    return Column(
      children: [
        SizedBox(
          height: 120,
          child: Image.asset(
            'assets/logo/blue.png',
            errorBuilder: (context, error, stackTrace) =>
                const Icon(Icons.smart_toy, size: 80, color: Colors.blueAccent),
          ),
        ),
        const SizedBox(height: 12),
        // 🎯 The exact text requested
        const Text(
          "เล่าให้ผมฟังหน่อยว่า\nเขาพูดอะไรกับคุณอยู่ ?",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
            height: 1.4,
          ),
        ),
        const SizedBox(height: 20),

        Wrap(
          spacing: 12,
          runSpacing: 12,
          alignment: WrapAlignment.center,
          children: [
            _buildOutlineChip("ขอข้อมูลส่วนตัว"),
            _buildOutlineChip("เร่งให้โอนเงิน"),
            _buildOutlineChip("อ้างเป็นหน่วยงาน"),
            _buildOutlineChip("ไม่แน่ใจ"),
          ],
        ),
        const SizedBox(height: 24),

        Row(
          children: [
            Expanded(
              child: _buildGradientButton(
                icon: Icons.report,
                text: "เริ่มน่าสงสัย",
                colors: [const Color(0xfff59e0b), const Color(0xffd97706)],
                onPressed: () {
                  // CHANGE: Added this trigger fallback
                  handleInitialInput(chosenCategoryTags: ['urgency']);
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildGradientButton(
                icon: Icons.search,
                text: "ช่วยฉันตรวจสอบ",
                colors: [const Color(0xff06b6d4), const Color(0xff0891b2)],
                onPressed: () {
                  // CHANGE: Map chip selections & text field input to engine
                  handleInitialInput(
                    textInput: _chatController.text,
                    chosenCategoryTags: _getMappedTagsFromSelection(),
                  );
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),

        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xff111827),
            borderRadius: BorderRadius.circular(12),
            border: const Border(
              left: BorderSide(color: Color(0xfff59e0b), width: 4),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Risk Snapshot",
                style: TextStyle(
                  color: Color(0xfff59e0b),
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              _buildBulletText("ใช้คำเร่งด่วนผิดปกติ"),
              _buildBulletText("ขอข้อมูลส่วนตัวทันที"),
              _buildBulletText("ไม่ยอมให้ตรวจสอบ"),
            ],
          ),
        ),
      ],
    );
  }

  // ------------------------------------------
  // Real Production Chat Mockup
  // ------------------------------------------
  Widget _buildMockChatHistory() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Align(
          alignment: Alignment.centerRight,
          child: Container(
            margin: const EdgeInsets.only(bottom: 12, left: 40),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xff2563eb),
              borderRadius: BorderRadius.circular(
                16,
              ).copyWith(bottomRight: const Radius.circular(4)),
            ),
            child: const Text(
              "มีคนโทรมาบอกว่าเป็นศาลอาญา บอกว่าผมมีหมายจับพัวพันฟอกเงิน ต้องโอนเงินไปตรวจสอบครับ ทำไงดี?",
              style: TextStyle(color: Colors.white, fontSize: 14, height: 1.4),
            ),
          ),
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: Container(
            margin: const EdgeInsets.only(bottom: 16, right: 40),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xff1e293b).withValues(alpha: 0.8),
              borderRadius: BorderRadius.circular(
                16,
              ).copyWith(bottomLeft: const Radius.circular(4)),
              border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
            ),
            child: const Text(
              "อุ่นใจขอให้รอสักครู่นะครับ กําลังเตรียมชุดคําถามและข้อมูลที่ในการตรวจสอบข้อมูลระหว่างนี้ ถือสายไว้ก่อนนะครับ !",
              style: TextStyle(color: Colors.white, fontSize: 14, height: 1.4),
            ),
          ),
        ),
      ],
    );
  }

  // ------------------------------------------
  // Common Question Header
  // ------------------------------------------
  Widget _buildQuestionHeader(String topic) {
    return Column(
      children: [
        SizedBox(
          height: 120,
          child: Image.asset(
            'assets/logo/blue.png',
            errorBuilder: (context, error, stackTrace) => const Icon(
              Icons.help_outline,
              size: 80,
              color: Colors.yellowAccent,
            ),
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xff86efac), Color(0xff93c5fd)],
            ),
            borderRadius: BorderRadius.circular(30),
          ),
          child: const Text(
            "✨ สรุปผลทันที",
            style: TextStyle(
              color: Color(0xff064e3b),
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          decoration: BoxDecoration(
            color: const Color(0xff1e293b).withValues(alpha: 0.8),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            topic,
            style: TextStyle(color: Colors.white, fontSize: 14),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  // ------------------------------------------
  // State 2: Multiple Choice
  // ------------------------------------------
  Widget _buildMultipleChoiceState(Question question) {
    return Column(
      children: [
        _buildQuestionHeader(topic),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xff111827).withValues(alpha: 0.7),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                question.q,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 24),
              ...question.choice!.asMap().entries.map((entry) {
                int index = entry.key;
                var e = entry.value;

                return Column(
                  children: [
                    _buildChoiceButton(e),
                    // Render the spacer ONLY if this isn't the last item in the list
                    if (index < question.choice!.length - 1)
                      const SizedBox(height: 12),
                  ],
                );
              }),
            ],
          ),
        ),
      ],
    );
  }

  // ------------------------------------------
  // State 3: Text Answer
  // ------------------------------------------
  Widget _buildTextAnswerState(Question question) {
    return Column(
      children: [
        _buildQuestionHeader(topic),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xff111827).withValues(alpha: 0.7),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                question.q,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 16),
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xff1e293b).withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.1),
                  ),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: TextField(
                  controller: _answerController,
                  maxLines: 4,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintStyle: TextStyle(color: Colors.white30),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff22c55e),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                  onPressed: () {
                    submitTextAnswer(_answerController.text);
                    _answerController.clear();
                  },
                  child: const Text(
                    "ส่งคำตอบ",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ==========================================
  // Helper Widgets
  // ==========================================

  Widget _buildOutlineChip(String text) {
    final isSelected = _selectedChips.contains(text);
    return GestureDetector(
      onTap: () {
        setState(() {
          if (isSelected) {
            _selectedChips.remove(text);
          } else {
            _selectedChips.add(text);
          }
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: (MediaQuery.of(context).size.width / 2) - 30,
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xff3b82f6).withValues(alpha: 0.2)
              : const Color(0xff1e293b).withValues(alpha: 0.4),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? const Color(0xff60a5fa)
                : Colors.white.withValues(alpha: 0.1),
            width: isSelected ? 1.5 : 1.0,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: const Color(0xff3b82f6).withValues(alpha: 0.4),
                    blurRadius: 12,
                    spreadRadius: 1,
                  ),
                ]
              : [],
        ),
        alignment: Alignment.center,
        child: Text(
          text,
          style: TextStyle(
            color: isSelected
                ? Colors.white
                : Colors.white.withValues(alpha: 0.9),
            fontSize: 14,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildGradientButton({
    required IconData icon,
    required String text,
    required List<Color> colors,
    required VoidCallback onPressed,
  }) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: LinearGradient(
          colors: colors,
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        boxShadow: [
          BoxShadow(
            color: colors.first.withValues(alpha: 0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 20, color: Colors.white),
            const SizedBox(width: 8),
            Text(
              text,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBulletText(String text) {
    return Row(
      children: [
        const Text(
          "• ",
          style: TextStyle(color: Color(0xfff59e0b), fontSize: 18),
        ),
        Text(
          text,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.8),
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Widget _buildChoiceButton(Choice c) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: c.color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: () {
          submitMultipleChoiceAnswer(c);
        },
        child: Text(
          c.text,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildChatInput() {
    return Container(
      margin: const EdgeInsets.only(
        left: 16.0,
        right: 16.0,
        top: 8.0,
        bottom: 100.0,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
      decoration: BoxDecoration(
        color: const Color(0xff1e293b).withValues(alpha: 0.85),
        borderRadius: BorderRadius.circular(40),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.15),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.4),
            blurRadius: 20,
            spreadRadius: 2,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 8.0),
              child: TextField(
                controller: _chatController,
                style: const TextStyle(color: Colors.white, fontSize: 15),
                decoration: InputDecoration(
                  hintText: "พิมพ์ประโยคสำคัญที่เขาพูด...",
                  hintStyle: TextStyle(
                    color: Colors.white.withValues(alpha: 0.4),
                    fontSize: 14,
                  ),
                  border: InputBorder.none,
                  isDense: true,
                ),
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                colors: [Color(0xff60a5fa), Color(0xff2563eb)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xff3b82f6).withValues(alpha: 0.4),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: IconButton(
              icon: const Icon(
                Icons.send_rounded,
                color: Colors.white,
                size: 20,
              ),
              onPressed: () {
                submitTextAnswer(_answerController.text);
              },
            ),
          ),
        ],
      ),
    );
  }
}
