import 'package:flutter/material.dart';
import 'package:times/pages/home_page.dart';

void main() {
  runApp(MaterialApp(
    theme: ThemeData(fontFamily: 'rudaw'),
    home: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[900],
      body: const Home(),
    );
  }
}
