import 'package:flutter/material.dart';
import 'package:circulite/screens/splash.dart';
import 'package:circulite/screens/login.dart';
import 'package:circulite/screens/signup.dart';
import 'package:circulite/screens/profile.dart';
import 'package:circulite/screens/hobby.dart';
import 'package:circulite/screens/matching.dart';
import 'package:circulite/screens/community.dart';
import 'package:circulite/screens/chat.dart';
import 'package:circulite/screens/event.dart';
import 'package:circulite/screens/home.dart';
import 'package:circulite/utils/theme.dart';

void main() {
  runApp(const CirculiteApp());
}

class CirculiteApp extends StatelessWidget {
  const CirculiteApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Circulite',
      debugShowCheckedModeBanner: false,
      theme: CirculiteTheme.lightTheme,
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/login': (context) => const LoginScreen(),
        '/signup': (context) => const SignupScreen(),
        '/profile-creation': (context) => const ProfileCreationScreen(),
        '/hobby-selection': (context) => const HobbySelectionScreen(),
        '/matching': (context) => const MatchingScreen(),
        '/community': (context) => const CommunityScreen(),
        '/chat': (context) => const ChatScreen(),
        '/event': (context) => const EventScreen(),
        '/home': (context) => const HomeScreen(),
      },
    );
  }
}
