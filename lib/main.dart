import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:times/model/Country.dart';
import 'package:times/pages/analog_clock.dart';
import 'package:times/pages/footer.dart';
import 'package:times/pages/glass_widget.dart';
import 'package:times/provider/glass_provider.dart';
import 'package:times/provider/key_animator.dart';
import 'package:times/services/countries.dart';
import 'package:times/pages/text_widget.dart';
import 'package:times/pages/country_selector.dart';

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

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<Countries> locations = Country.locations;
  Timer? _scrollDebounce;
  final ValueNotifier<String> _countryName = ValueNotifier('');
  final ValueNotifier<String> _time = ValueNotifier('');
  final ValueNotifier<String> _period = ValueNotifier('');
  final ValueNotifier<DateTime> _dateTime = ValueNotifier(DateTime.now());
  final double _twoPi = 2 * pi;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 2500),
    );
    _controller.forward();
    super.initState();
  }

  @override
  void dispose() {
    _scrollDebounce?.cancel();
    _countryName.dispose();
    _time.dispose();
    _period.dispose();
    _dateTime.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(fontFamily: 'rudaw'),
      home: Scaffold(
        persistentFooterAlignment: AlignmentDirectional.center,
        persistentFooterButtons: const [FooterWidget()],
        backgroundColor: const Color.fromARGB(225, 53, 66, 89),
        body: Card(
          elevation: 1,
          color: const Color.fromARGB(255, 53, 66, 89),
          margin: const EdgeInsets.symmetric(vertical: 35, horizontal: 10),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GlassWidget(),
                ValueListenableBuilder<String>(
                  valueListenable: _countryName,
                  builder: (_, value, __) => TextWidget(text: value, size: 24),
                ),

                //for creating some space between text and flag
                //for creating some space between text and flag
                CountrySelector(
                  locations: locations,
                  onCountrySelected: (instance) {
                    _countryName.value = instance.name;
                    _time.value = instance.time;
                    _period.value = instance.period;
                    _dateTime.value = DateTime.parse(instance.datetime);

                    if (context.read<KeyAnimator>().text == 't') {
                      context.read<KeyAnimator>().setter('f');
                    } else {
                      context.read<KeyAnimator>().setter('t');
                    }
                    context.read<GlassProvider>().setter(false);
                  },
                ),

                ValueListenableBuilder<String>(
                  valueListenable: _time,
                  builder: (_, timeValue, __) => ValueListenableBuilder<String>(
                    valueListenable: _period,
                    builder: (_, periodValue, __) => Column(
                      children: [
                        TextWidget(text: timeValue, size: 55, letterspacing: 7),
                        TextWidget(
                          text: periodValue,
                          size: 30,
                          letterspacing: 0,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                ValueListenableBuilder<DateTime>(
                  valueListenable: _dateTime,
                  builder: (_, value, __) {
                    final clock = AnalogWidget(date: value);
                    return AnimatedBuilder(
                      animation: _controller.view,
                      child: clock,
                      builder: (BuildContext context, Widget? child) {
                        return Transform.rotate(
                          angle: _controller.value * _twoPi,
                          child: child,
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
