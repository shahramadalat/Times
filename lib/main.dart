import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:times/pages/splash_screen.dart';
import 'package:times/provider/glass_provider.dart';
import 'package:times/provider/key_animator.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => KeyAnimator()),
        ChangeNotifierProvider(create: (_) => GlassProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'rudaw'),
      home: const SplashScreen(),
    );
  }
}
