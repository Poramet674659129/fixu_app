import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/main_screen.dart';
import 'screens/status_tracking_screen.dart';
import 'screens/report_screen.dart';
import 'screens/history_screen.dart';
import 'screens/news_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/technician/technician_main_screen.dart';

void main() {
  runApp(const FixUApp());
}

class FixUApp extends StatelessWidget {
  const FixUApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FixU - แอปแจ้งซ่อมในมหาวิทยาลัย',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        primaryColor: const Color(0xFF0265D8),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF0265D8),
          primary: const Color(0xFF0265D8),
        ),
        scaffoldBackgroundColor: const Color(0xFFF8FAFC),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Color(0xFF0F172A),
          elevation: 0,
        ),
      ),
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/main': (context) => const MainScreen(),
        '/technician_main': (context) => const TechnicianMainScreen(),
        '/status': (context) => const StatusTrackingScreen(),
        '/report': (context) => const ReportScreen(),
        '/history': (context) => const HistoryScreen(),
        '/news': (context) => const NewsScreen(),
        '/settings': (context) => const SettingsScreen(),
      },
    );
  }
}
