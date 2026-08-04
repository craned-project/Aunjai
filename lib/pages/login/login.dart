import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:dio/dio.dart';
import 'package:aunjai/services/auth_service.dart';

class LogInPage extends StatefulWidget {
  const LogInPage({super.key});

  @override
  State<LogInPage> createState() => _LogInPageState();
}

class _LogInPageState extends State<LogInPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _emailOrUsernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _rememberMe = false;
  bool _obscurePassword = true;
  bool _isFormInputValid = false;
  bool _isLoading = false;
  final AuthService _authService = AuthService();

  @override
  void initState() {
    super.initState();
    // Listeners to validate the button state reactively as the user types
    _emailOrUsernameController.addListener(_validateFormState);
    _passwordController.addListener(_validateFormState);
  }

  @override
  void dispose() {
    _emailOrUsernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _validateFormState() {
  // 🎯 Extract text from your two login controllers
  final emailOrUsername = _emailOrUsernameController.text.trim();
  final password = _passwordController.text;

  // 🎯 Only check that identity is not empty and password meets your minimum character requirements
  final isValid = emailOrUsername.isNotEmpty && password.length >= 8;

  if (isValid != _isFormInputValid) {
    setState(() {
      _isFormInputValid = isValid;
    });
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        // 🌌 Forces the dark app background gradient to stretch 100% full screen
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xff091026), // Top deep navy blue
              Color(0xff050814), // Bottom dark base background
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Stack(
          children: [
            // Ambient Top Left Blue Glow
            Positioned(
              top: -150,
              left: -100,
              child: Container(
                width: 350,
                height: 350,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.transparent,
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xff0ea5e9).withValues(alpha: 0.12),
                      blurRadius: 140,
                      spreadRadius: 20,
                    ),
                  ],
                ),
              ),
            ),

            // Beautiful Bottom Airbrushed Purple Halo
            Positioned(
              bottom: -100,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  width: 320,
                  height: 320,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.transparent,
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xff6366f1).withValues(alpha: 0.25),
                        blurRadius: 120,
                        spreadRadius: 40,
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Scrollable UI Content
            GestureDetector(
              onTap: () => FocusScope.of(context).unfocus(),
              child: SafeArea(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 28.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 12),

                        // Back Button Arrow Anchor
                        Container(
                          decoration: BoxDecoration(
                            color: const Color(
                              0xff111827,
                            ).withValues(alpha: 0.5),
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                            icon: const Icon(
                              Icons.arrow_back_ios_new,
                              color: Colors.white,
                              size: 18,
                            ),
                            onPressed: () {
                              Navigator.of(context).maybePop();
                            },
                          ),
                        ),
                        const SizedBox(height: 12),

                        // Mascot Graphic Frame
                        Center(
                          child: SizedBox(
                            height: 140,
                            child: Image.asset(
                              'logo/blue.png',
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) {
                                return const Center(
                                  child: Text(
                                    "🤖",
                                    style: TextStyle(fontSize: 64),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Headings Block
                        const Center(
                          child: Text(
                            "ยินดีต้อนรับกลับมา",
                            style: TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Center(
                          child: Text(
                            "เข้าสู่ระบบเพื่อใช้งานผู้ช่วย AI อุ่นใจ",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white.withValues(alpha: 0.5),
                            ),
                          ),
                        ),
                        const SizedBox(height: 32),

                        // 1. Username Field
                        _buildFieldLabel("อีเมล / ชื่อผู้ใช้งาน"),
                        _buildInputField(
                          controller: _emailOrUsernameController,
                          hintText: "กรอกอีเมลหรือชื่อผู้ใช้งานของคุณ",
                          onChanged: (_) => _validateFormState(),
                        ),
                        const SizedBox(height: 20),

                        // 4. Password Field
                        _buildFieldLabel("รหัสผ่าน"),
                        _buildInputField(
                          controller: _passwordController,
                          hintText: "กำหนดรหัสผ่าน (อย่างน้อย 8 ตัวอักษร)",
                          obscureText: _obscurePassword,
                          onChanged: (_) => _validateFormState(),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: Colors.white.withValues(alpha: 0.38),
                              size: 20,
                            ),
                            onPressed: () => setState(
                              () => _obscurePassword = !_obscurePassword,
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Terms and Conditions Consent Checkbox
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Theme(
                              data: ThemeData(
                                unselectedWidgetColor: Colors.white.withValues(
                                  alpha: 0.24,
                                ),
                              ),
                              child: SizedBox(
                                width: 24,
                                height: 24,
                                child: Checkbox(
                                  value: _rememberMe,
                                  activeColor: const Color(0xff2563eb),
                                  checkColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  side: BorderSide(
                                    color: Colors.white.withValues(alpha: 0.2),
                                  ),
                                  onChanged: (val) {
                                    setState(() {
                                      _rememberMe = val ?? false;
                                    });
                                    _validateFormState();
                                  },
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                "จดจำฉัน",
                                style: TextStyle(
                                  color: Colors.white.withValues(alpha: 0.4),
                                  fontSize: 16,
                                  height: 1.5,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 36),

                        // Gradient Button (Unlocks with a gorgeous green light/glow style dynamically)
                        Container(
                          width: double.infinity,
                          height: 54,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            gradient: LinearGradient(
                              colors: _isFormInputValid
                                  ? [
                                      const Color(0xff2563eb),
                                      const Color(0xff7c3aed),
                                    ]
                                  : [
                                      const Color(
                                        0xff1e293b,
                                      ).withValues(alpha: 0.6),
                                      const Color(
                                        0xff1e293b,
                                      ).withValues(alpha: 0.6),
                                    ],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ),
                            boxShadow: _isFormInputValid
                                ? [
                                    BoxShadow(
                                      color: const Color(
                                        0xff7c3aed,
                                      ).withValues(alpha: 0.25),
                                      blurRadius: 16,
                                      offset: const Offset(0, 4),
                                    ),
                                  ]
                                : [],
                          ),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            onPressed: (_isFormInputValid && !_isLoading)
                                ? () async {
                                    if (_formKey.currentState!.validate()) {
                                      setState(() => _isLoading = true);
                                      try {
                                        await _authService.login(
                                          _emailOrUsernameController.text.trim(),
                                          _passwordController.text,
                                        );
                                        if (mounted) context.go('/home');
                                      } on DioException catch (e) {
                                        if (mounted) {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(
                                              content: Text(_authService.getErrorMessage(e)),
                                              backgroundColor: Colors.red.shade700,
                                            ),
                                          );
                                        }
                                      } finally {
                                        if (mounted) setState(() => _isLoading = false);
                                      }
                                    }
                                  }
                                : null,
                            child: _isLoading
                                ? const SizedBox(
                                    width: 24,
                                    height: 24,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  )
                                : Text(
                              "เข้าสู่ระบบ",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: _isFormInputValid
                                    ? Colors.white
                                    : Colors.white.withValues(alpha: 0.24),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 28),

                        // Footer Switch Redirect Link
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "ยังไม่มีบัญชีผู้ใช้งานใช่ไหม? ",
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.4),
                                fontSize: 16,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                context.go('/register');
                              },
                              child: const Text(
                                "สมัครสมาชิก",
                                style: TextStyle(
                                  color: Color(0xff3b82f6),
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFieldLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8.0),
      child: Text(
        label,
        style: TextStyle(
          color: Colors.white.withValues(alpha: 0.6),
          fontSize: 16,
        ),
      ),
    );
  }

  // 🎯 FIXED SIGNATURE: Fully accepts and utilizes the onChanged callback now!
  Widget _buildInputField({
    required TextEditingController controller,
    required String hintText,
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
    Widget? suffixIcon,
    String? Function(String?)? validator,
    ValueChanged<String>? onChanged,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xff111827).withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
      ),
      padding: const EdgeInsets.only(left: 14),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        textAlignVertical: TextAlignVertical
            .center, // Keeps your text vertically centered with icons
        validator: validator,
        onChanged: onChanged,
        style: const TextStyle(color: Colors.white, fontSize: 16),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(
            color: Colors.white.withValues(alpha: 0.2),
            fontSize: 16,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 16),
          suffixIcon: suffixIcon,
        ),
      ),
    );
  }
}
