import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  UserRole _selectedRole = UserRole.student;
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onRoleChanged(UserRole role) {
    setState(() {
      _selectedRole = role;
    });
  }

  Future<void> _handleLogin() async {
    final username = _usernameController.text.trim();
    final password = _passwordController.text;

    if (username.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('กรุณากรอกข้อมูลเข้าสู่ระบบและรหัสผ่าน'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final isTechEmail = AuthService.instance.isTechnicianEmail(username);

    // Technician role validation
    if (_selectedRole == UserRole.technician && !isTechEmail) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('กรุณากรอกอีเมลช่างเทคนิค เช่น poramet@mail.ch.com'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final isTechnicianTarget = _selectedRole == UserRole.technician || isTechEmail;

    final success = await AuthService.instance.login(
      username,
      password,
      role: isTechnicianTarget ? UserRole.technician : UserRole.student,
    );

    if (mounted) {
      setState(() {
        _isLoading = false;
      });

      if (success) {
        if (isTechnicianTarget) {
          Navigator.of(context).pushReplacementNamed('/technician_main');
        } else {
          Navigator.of(context).pushReplacementNamed('/main');
        }
      } else {
        if (isTechnicianTarget) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('อีเมลนี้ไม่มีสิทธิ์เข้าใช้งานในฐานะช่างเทคนิค'),
              backgroundColor: Colors.red,
            ),
          );
        } else {
          if (AuthService.instance.registeredUser == null) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('ยังไม่มีบัญชีในระบบ กรุณาสมัครสมาชิกก่อนเข้าสู่ระบบ'),
                backgroundColor: Colors.orange,
              ),
            );
            _navigateToRegister();
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('ข้อมูลเข้าสู่ระบบ หรือ รหัสผ่านไม่ถูกต้อง'),
                backgroundColor: Colors.red,
              ),
            );
          }
        }
      }
    }
  }

  Future<void> _navigateToRegister() async {
    final result = await Navigator.of(context).pushNamed('/register');
    if (result is String && result.isNotEmpty && mounted) {
      setState(() {
        _usernameController.text = result;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isTechnicianTab = _selectedRole == UserRole.technician;

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
                const SizedBox(height: 10),
                // Logo Icon Box
                Container(
                  width: 86,
                  height: 86,
                  decoration: BoxDecoration(
                    color: isTechnicianTab ? const Color(0xFF0F172A) : const Color(0xFF0265D8),
                    borderRadius: BorderRadius.circular(22),
                    boxShadow: [
                      BoxShadow(
                        color: isTechnicianTab ? const Color(0x400F172A) : const Color(0x400265D8),
                        blurRadius: 16,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Icon(
                      isTechnicianTab ? Icons.engineering_rounded : Icons.build_rounded,
                      size: 46,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // App Title
                const Text(
                  'FixU',
                  style: TextStyle(
                    fontSize: 34,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0F172A),
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 4),
                // Subtitle
                Text(
                  isTechnicianTab ? 'ระบบจัดการงานซ่อมสำหรับช่าง' : 'แอปแจ้งซ่อมสำหรับนักศึกษาและบุคลากร',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF64748B),
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 28),

                // Role Segmented Selector Switch
                Container(
                  height: 48,
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () => _onRoleChanged(UserRole.student),
                          child: Container(
                            decoration: BoxDecoration(
                              color: !isTechnicianTab ? const Color(0xFF0265D8) : Colors.transparent,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.school_outlined,
                                    size: 18,
                                    color: !isTechnicianTab ? Colors.white : const Color(0xFF64748B),
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    'นักศึกษา / บุคลากร',
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: !isTechnicianTab ? FontWeight.bold : FontWeight.w500,
                                      color: !isTechnicianTab ? Colors.white : const Color(0xFF64748B),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () => _onRoleChanged(UserRole.technician),
                          child: Container(
                            decoration: BoxDecoration(
                              color: isTechnicianTab ? const Color(0xFF0F172A) : Colors.transparent,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.engineering_outlined,
                                    size: 18,
                                    color: isTechnicianTab ? Colors.white : const Color(0xFF64748B),
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    'ช่างเทคนิค',
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: isTechnicianTab ? FontWeight.bold : FontWeight.w500,
                                      color: isTechnicianTab ? Colors.white : const Color(0xFF64748B),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 28),

                // Email/StudentID Input Field
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    isTechnicianTab ? 'อีเมลช่างเทคนิค' : 'รหัสนักศึกษา หรือ อีเมล',
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
                    hintText: isTechnicianTab ? 'เช่น poramet@mail.ch.com' : 'เช่น 674659129',
                    hintStyle: const TextStyle(color: Color(0xFF94A3B8), fontSize: 14),
                    prefixIcon: Icon(
                      isTechnicianTab ? Icons.email_outlined : Icons.person_outline,
                      color: const Color(0xFF64748B),
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
                      borderSide: BorderSide(
                        color: isTechnicianTab ? const Color(0xFF0F172A) : const Color(0xFF0265D8),
                        width: 1.5,
                      ),
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
                      borderSide: BorderSide(
                        color: isTechnicianTab ? const Color(0xFF0F172A) : const Color(0xFF0265D8),
                        width: 1.5,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 28),

                // Login Button
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _handleLogin,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isTechnicianTab ? const Color(0xFF0F172A) : const Color(0xFF0265D8),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                          )
                        : Text(
                            isTechnicianTab ? 'เข้าสู่ระบบสำหรับช่าง' : 'เข้าสู่ระบบ',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),
                const SizedBox(height: 20),

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
                const SizedBox(height: 20),

                // Google Login Button
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: OutlinedButton(
                    onPressed: () async {
                      final registered = AuthService.instance.registeredUser;
                      final isTech = _selectedRole == UserRole.technician;

                      if (isTech) {
                        final emailInput = _usernameController.text.trim();
                        final isTechEmail = AuthService.instance.isTechnicianEmail(emailInput);

                        if (!isTechEmail) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('อีเมลนี้ไม่มีสิทธิ์เข้าใช้งานในฐานะช่างเทคนิค กรุณาใช้อีเมลช่างเทคนิคที่ถูกต้อง'),
                              backgroundColor: Colors.red,
                            ),
                          );
                          return;
                        }

                        final nav = Navigator.of(context);
                        await AuthService.instance.login(
                          emailInput.isNotEmpty ? emailInput : 'poramet@mail.ch.com',
                          '123456',
                          role: UserRole.technician,
                        );
                        if (mounted) {
                          nav.pushReplacementNamed('/technician_main');
                        }
                      } else {
                        if (registered == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('ยังไม่มีบัญชีในระบบ กรุณาสมัครสมาชิกก่อนเข้าสู่ระบบ'),
                              backgroundColor: Colors.orange,
                            ),
                          );
                          _navigateToRegister();
                        } else {
                          final nav = Navigator.of(context);
                          await AuthService.instance.login(
                            registered.emailOrStudentId,
                            registered.password,
                            role: UserRole.student,
                          );
                          if (mounted) {
                            nav.pushReplacementNamed('/main');
                          }
                        }
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
                const SizedBox(height: 28),

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
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
