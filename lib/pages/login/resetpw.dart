import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ResetPWPage extends StatefulWidget {
  const ResetPWPage({super.key});

  @override
  State<ResetPWPage> createState() => _ResetPWPageState();
}

class _ResetPWPageState extends State<ResetPWPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _emailOrUsernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  // 🎯 ADDED: Separate controller for the confirmation/verification field
  final TextEditingController _confirmPasswordController = TextEditingController();

  bool _obscurePassword = true;
  bool _isFormInputValid = false; // Tracks if the complete form criteria is met
  bool _doPasswordsMatch = false; // 🎯 ADDED: Tracks password alignment states

  @override
  void initState() {
    super.initState();
    // Listeners to validate the button state reactively as the user types
    _emailOrUsernameController.addListener(_validateFormState);
    _passwordController.addListener(_validateFormState);
    _confirmPasswordController.addListener(_validateFormState); // 🎯 ADDED
  }

  @override
  void dispose() {
    _emailOrUsernameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose(); // 🎯 ADDED
    super.dispose();
  }

  void _validateFormState() {
    final emailOrUsername = _emailOrUsernameController.text.trim();
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;

    // 🎯 CHECK 1: Do both password fields match exactly?
    final matches = password.isNotEmpty && confirmPassword.isNotEmpty && password == confirmPassword;

    // 🎯 CHECK 2: Main submission requirements (Identity present, valid length, and passwords match)
    final isValid = emailOrUsername.isNotEmpty && password.length >= 8 && matches;

    setState(() {
      _doPasswordsMatch = matches;
      _isFormInputValid = isValid;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xff091026),
              Color(0xff050814),
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
                            color: const Color(0xff111827).withValues(alpha: 0.5),
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                            icon: const Icon(
                              Icons.arrow_back_ios_new,
                              color: Colors.white,
                              size: 18,
                            ),
                            onPressed: () {
                              context.go('/login');
                            },
                          ),
                        ),
                        const SizedBox(height: 12),

                        // Mascot Graphic Frame
                        Center(
                          child: SizedBox(
                            height: 140,
                            child: Image.asset(
                              'logo/yellow.png',
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
                            "รีเซ็ตรหัสผ่าน",
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
                            "โปรดใส่ข้อมูลอีเมลที่ได้ลงทะเบียนในการสร้างบัญชี",
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

                        // 2. New Password Field
                        _buildFieldLabel("รหัสผ่านใหม่"),
                        _buildInputField(
                          controller: _passwordController,
                          hintText: "กำหนดรหัสผ่านใหม่ (อย่างน้อย 8 ตัวอักษร)",
                          obscureText: _obscurePassword,
                          onChanged: (_) => _validateFormState(),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword ? Icons.visibility_off : Icons.visibility,
                              color: Colors.white.withValues(alpha: 0.38),
                              size: 20,
                            ),
                            onPressed: () => setState(
                              () => _obscurePassword = !_obscurePassword,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),

                        // 3. Confirm Password Field (Verification Box)
                        _buildFieldLabel("ยืนยันรหัสผ่านใหม่"),
                        _buildInputField(
                          controller: _confirmPasswordController, // 🎯 FIX: Changed to confirmation controller
                          hintText: "ยืนยันรหัสผ่านใหม่ของคุณ",
                          obscureText: true, // 🎯 FIX: Forced to true so it cannot be unobscured
                          onChanged: (_) => _validateFormState(),
                          // 🎯 FIX: Displays a green check icon dynamically when passwords match
                          suffixIcon: _doPasswordsMatch
                              ? const Icon(
                                  Icons.check_circle_rounded,
                                  color: Color(0xff10b981),
                                  size: 22,
                                )
                              : null,
                        ),
                        const SizedBox(height: 36),

                        // Gradient Submit Button
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
                                      const Color(0xff1e293b).withValues(alpha: 0.6),
                                      const Color(0xff1e293b).withValues(alpha: 0.6),
                                    ],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ),
                            boxShadow: _isFormInputValid
                                ? [
                                    BoxShadow(
                                      color: const Color(0xff7c3aed).withValues(alpha: 0.25),
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
                            onPressed: _isFormInputValid
                                ? () {
                                    if (_formKey.currentState!.validate()) {
                                      final Map<String, dynamic> payload = {
                                        'emailoruser': _emailOrUsernameController.text.trim(),
                                        'password': _passwordController.text,
                                      };

                                      print("Ready to send packed object: $payload");
                                    }
                                  }
                                : null,
                            child: Text(
                              "เปลี่ยนรหัสผ่าน",
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
                              "มีบัญชีผู้ใช้งานอยู่แล้วใช่ไหม? ",
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.4),
                                fontSize: 16,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                context.go('/login');
                              },
                              child: const Text(
                                "เข้าสู่ระบบ",
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
        textAlignVertical: TextAlignVertical.center,
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