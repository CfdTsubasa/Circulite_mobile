import 'package:flutter/material.dart';
import 'dart:async';
import 'package:circulite/utils/theme.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // 3秒後にログイン画面に遷移
    Timer(
      const Duration(seconds: 3),
      () => Navigator.pushReplacementNamed(context, '/login'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // アプリロゴ
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: CirculiteTheme.primaryColor,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.groups,
                color: Colors.white,
                size: 60,
              ),
            ),
            const SizedBox(height: 20),
            
            // アプリ名
            const Text(
              'Circulite',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: CirculiteTheme.primaryColor,
              ),
            ),
            
            const SizedBox(height: 10),
            
            // キャッチフレーズ
            const Text(
              '新しい仲間と、新しい世界を。',
              style: TextStyle(
                fontSize: 16,
                color: CirculiteTheme.textSecondaryColor,
              ),
            ),
            
            const SizedBox(height: 40),
            
            // ローディングインジケーター
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                CirculiteTheme.primaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
