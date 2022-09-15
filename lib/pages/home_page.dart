import 'package:flutter/material.dart';
import 'package:times/pages/countries_view.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const HomePage(),
        ],
      ),
    );
  }
}
