import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// 🎯 Enum for controlling the UI state
enum CallUIState { 
  initial,        // Main Chat & Analysis Page
  multipleChoice, // Separated: Multiple choice question
  textAnswer      // Separated: Text input question
}

class CallMode extends StatefulWidget {
  const CallMode({super.key});

  @override
  State<CallMode> createState() => _CallModeState();
}

class _CallModeState extends State<CallMode> {
  // ⚙️ Change this value to switch between different screens!
  CallUIState _uiState = CallUIState.initial; 

  final TextEditingController _chatController = TextEditingController();
  final TextEditingController _answerController = TextEditingController();
  
  final Set<String> _selectedChips = {};

  @override
  void dispose() {
    _chatController.dispose();
    _answerController.dispose();
    super.dispose();
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
                  physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                  padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                  child: Column(
                    children: [
                      // 🎯 SEPARATED PAGE CONTENT
                      if (_uiState == CallUIState.initial) ...[
                        _buildInitialState(),
                        const SizedBox(height: 24),
                        _buildMockChatHistory(),
                      ] 
                      else if (_uiState == CallUIState.multipleChoice) ...[
                        _buildMultipleChoiceState(),
                      ] 
                      else if (_uiState == CallUIState.textAnswer) ...[
                        _buildTextAnswerState(),
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
              child: const Icon(Icons.arrow_back, color: Colors.white, size: 20),
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
            errorBuilder: (context, error, stackTrace) => const Icon(Icons.smart_toy, size: 80, color: Colors.blueAccent),
          ),
        ),
        const SizedBox(height: 12),
        // 🎯 The exact text requested
        const Text(
          "เล่าให้ผมฟังหน่อยว่า\nเขาพูดอะไรกับคุณอยู่ ?",
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold, height: 1.4),
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
                icon: "🚨",
                text: "เริ่มน่าสงสัย",
                colors: [const Color(0xfff59e0b), const Color(0xffd97706)],
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildGradientButton(
                icon: "🔍",
                text: "ช่วยฉันตรวจสอบ",
                colors: [const Color(0xff06b6d4), const Color(0xff0891b2)],
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
                style: TextStyle(color: Color(0xfff59e0b), fontSize: 14, fontWeight: FontWeight.bold), 
              ),
              const SizedBox(height: 8),
              _buildBulletText("ใช้คำเร่งด่วนผิดปกติ"),
              const SizedBox(height: 4), 
              _buildBulletText("ขอข้อมูลส่วนตัวทันที"),
              const SizedBox(height: 4),
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
              borderRadius: BorderRadius.circular(16).copyWith(bottomRight: const Radius.circular(4)),
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
              borderRadius: BorderRadius.circular(16).copyWith(bottomLeft: const Radius.circular(4)),
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
  Widget _buildQuestionHeader() {
    return Column(
      children: [
        SizedBox(
          height: 120,
          child: Image.asset(
            'assets/logo/blue.png',
            errorBuilder: (context, error, stackTrace) => const Icon(Icons.help_outline, size: 80, color: Colors.yellowAccent),
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
            style: TextStyle(color: Color(0xff064e3b), fontWeight: FontWeight.bold, fontSize: 14),
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          decoration: BoxDecoration(
            color: const Color(0xff1e293b).withValues(alpha: 0.8),
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Text(
            "มีตำรวจโทรมาบอกผมว่าผมทำผิดกฎหมาย",
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
  Widget _buildMultipleChoiceState() {
    return Column(
      children: [
        _buildQuestionHeader(),
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
              const Text(
                "เขาขอข้อมูลส่วนตัว เช่น เลขบัตร หรือรหัส OTP\nหรือไม่?",
                style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold, height: 1.5),
              ),
              const SizedBox(height: 24),
              _buildChoiceButton("ใช่", const Color(0xff22c55e)),
              const SizedBox(height: 12),
              _buildChoiceButton("ไม่", const Color(0xffef4444)),
              const SizedBox(height: 12),
              _buildChoiceButton("ไม่แน่ใจ", const Color(0xfff59e0b)),
            ],
          ),
        ),
      ],
    );
  }

  // ------------------------------------------
  // State 3: Text Answer
  // ------------------------------------------
  Widget _buildTextAnswerState() {
    return Column(
      children: [
        _buildQuestionHeader(),
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
              const Text(
                "เขาขอข้อมูลส่วนตัว เช่น เลขบัตร หรือรหัส OTP\nหรือไม่?",
                style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold, height: 1.5),
              ),
              const SizedBox(height: 16),
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xff1e293b).withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                  ),
                  onPressed: () {},
                  child: const Text("ส่งคำตอบ", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
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
                  )
                ]
              : [],
        ),
        alignment: Alignment.center,
        child: Text(
          text,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.white.withValues(alpha: 0.9), 
            fontSize: 14,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildGradientButton({required String icon, required String text, required List<Color> colors}) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: LinearGradient(colors: colors, begin: Alignment.centerLeft, end: Alignment.centerRight),
        boxShadow: [
          BoxShadow(color: colors.first.withValues(alpha: 0.3), blurRadius: 8, offset: const Offset(0, 4)),
        ],
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        onPressed: () {},
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(icon, style: const TextStyle(fontSize: 16)),
            const SizedBox(width: 8),
            Text(text, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
          ],
        ),
      ),
    );
  }

  Widget _buildBulletText(String text) {
    return Row(
      children: [
        const Text("• ", style: TextStyle(color: Color(0xfff59e0b), fontSize: 16)),
        Text(text, style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontSize: 13)),
      ],
    );
  }

  Widget _buildChoiceButton(String text, Color color) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        onPressed: () {},
        child: Text(
          text,
          style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildChatInput() {
    return Container(
      margin: const EdgeInsets.only(left: 16.0, right: 16.0, top: 8.0, bottom: 100.0),
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
      decoration: BoxDecoration(
        color: const Color(0xff1e293b).withValues(alpha: 0.85),
        borderRadius: BorderRadius.circular(40),
        border: Border.all(color: Colors.white.withValues(alpha: 0.15), width: 1.5),
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
              icon: const Icon(Icons.send_rounded, color: Colors.white, size: 20),
              onPressed: () {},
            ),
          ),
        ],
      ),
    );
  }
}