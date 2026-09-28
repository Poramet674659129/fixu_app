import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() {
    final username = _usernameController.text.trim();
    final password = _passwordController.text;

    if (username.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('กรุณากรอกอีเมล/รหัสนักศึกษาและรหัสผ่าน'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (AuthService.instance.registeredUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('ยังไม่มีบัญชีในระบบ กรุณาสมัครสมาชิกก่อนเข้าสู่ระบบ'),
          backgroundColor: Colors.orange,
        ),
      );
      _navigateToRegister();
      return;
    }

    final success = AuthService.instance.login(username, password);

    if (success) {
      Navigator.of(context).pushReplacementNamed('/main');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('อีเมล/รหัสนักศึกษา หรือ รหัสผ่านไม่ถูกต้อง'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _navigateToRegister() async {
    final result = await Navigator.of(context).pushNamed('/register');
    if (result is String && result.isNotEmpty) {
      setState(() {
        _usernameController.text = result;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 28.0, vertical: 20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                // Logo Icon Box
                Container(
                  width: 90,
                  height: 90,
                  decoration: BoxDecoration(
                    color: const Color(0xFF0265D8),
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF0265D8).withOpacity(0.25),
                        blurRadius: 16,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.build_rounded,
                      size: 48,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // App Title
                const Text(
                  'FixU',
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0F172A),
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 6),
                // Subtitle
                const Text(
                  'แอปแจ้งซ่อมในมหาวิทยาลัย',
                  style: TextStyle(
                    fontSize: 15,
                    color: Color(0xFF64748B),
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 40),

                // Email/StudentID Input Field
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'อีเมล หรือ รหัสนักศึกษา',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade800,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _usernameController,
                  decoration: InputDecoration(
                    hintText: 'กรอกอีเมล หรือ รหัสนักศึกษา',
                    hintStyle: const TextStyle(color: Color(0xFF94A3B8), fontSize: 14),
                    prefixIcon: const Icon(Icons.person_outline, color: Color(0xFF64748B)),
                    filled: true,
                    fillColor: const Color(0xFFF8FAFC),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFF0265D8), width: 1.5),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Password Input Field
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'รหัสผ่าน',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade800,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  decoration: InputDecoration(
                    hintText: 'กรอกรหัสผ่าน',
                    hintStyle: const TextStyle(color: Color(0xFF94A3B8), fontSize: 14),
                    prefixIcon: const Icon(Icons.lock_outline, color: Color(0xFF64748B)),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                        color: const Color(0xFF64748B),
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                    filled: true,
                    fillColor: const Color(0xFFF8FAFC),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFF0265D8), width: 1.5),
                    ),
                  ),
                ),
                const SizedBox(height: 28),

                // Login Button
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: _handleLogin,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0265D8),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'เข้าสู่ระบบ',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Divider Or
                Row(
                  children: [
                    Expanded(child: Container(height: 1, color: const Color(0xFFE2E8F0))),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        'หรือ',
                        style: TextStyle(color: Color(0xFF94A3B8), fontSize: 14),
                      ),
                    ),
                    Expanded(child: Container(height: 1, color: const Color(0xFFE2E8F0))),
                  ],
                ),
                const SizedBox(height: 24),

                // Google Login Button
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: OutlinedButton(
                    onPressed: () {
                      if (AuthService.instance.registeredUser == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('ยังไม่มีบัญชีในระบบ กรุณาสมัครสมาชิกก่อนเข้าสู่ระบบ'),
                            backgroundColor: Colors.orange,
                          ),
                        );
                        _navigateToRegister();
                      } else {
                        AuthService.instance.login(
                          AuthService.instance.registeredUser!.emailOrStudentId,
                          AuthService.instance.registeredUser!.password,
                        );
                        Navigator.of(context).pushReplacementNamed('/main');
                      }
                    },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Color(0xFFCBD5E1)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      backgroundColor: Colors.white,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            color: Colors.red.shade50,
                            shape: BoxShape.circle,
                          ),
                          child: const Center(
                            child: Text(
                              'G',
                              style: TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Text(
                          'เข้าสู่ระบบด้วย Google',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF334155),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 32),

                // Register Link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'ยังไม่มีบัญชี? ',
                      style: TextStyle(color: Color(0xFF64748B), fontSize: 14),
                    ),
                    GestureDetector(
                      onTap: _navigateToRegister,
                      child: const Text(
                        'สมัครสมาชิก',
                        style: TextStyle(
                          color: Color(0xFF0265D8),
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
