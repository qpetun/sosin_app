import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:sosin_app/transactions.dart';
import 'firebase_options.dart';
import 'auth_gate.dart';
import 'home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Инициализация Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Темное приложение',
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: const Color(0xFF4A90E2),
        scaffoldBackgroundColor: const Color(0xFF1E1E1E), // Светлее темный фон
        colorScheme: ColorScheme.dark(
          primary: const Color(0xFF4A90E2),
          secondary: const Color(0xFF50E3C2),
        ),
        textTheme: const TextTheme(
          headlineSmall: TextStyle(color: Color(0xFFFFFFFF), fontSize: 24),
          bodyMedium: TextStyle(color: Color(0xFFB0B0B0), fontSize: 16),
        ),
        buttonTheme: ButtonThemeData(
          buttonColor: const Color(0xFF4A90E2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          textTheme: ButtonTextTheme.primary,
        ),
      ),


      initialRoute: '/',
      routes: {
        '/': (context) => const AuthGate(),
        '/home': (context) => HomeScreen(),
        '/transactions': (context) => const MyHomePage(),
      },
    );
  }
}
