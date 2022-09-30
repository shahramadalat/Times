import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:times/model/Country.dart';
import 'package:times/pages/analog_clock.dart';
import 'package:times/pages/footer.dart';
import 'package:times/pages/glass_widget.dart';
import 'package:times/provider/glass_provider.dart';
import 'package:times/provider/key_animator.dart';
import 'package:times/services/check_connection_service.dart';
import 'package:times/services/countries.dart';
import 'package:times/pages/text_widget.dart';

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
  List<Countries> locations = Country.locations;

  @override
  void initState() {
    _controller = AnimationController(
        vsync: this, duration: Duration(milliseconds: 2500));
    _controller.forward();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  var countryname = '';
  String time = '';
  DateTime datetime = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(fontFamily: 'rudaw'),
      home: Scaffold(
        persistentFooterAlignment: AlignmentDirectional.center,
        persistentFooterButtons: [
          FooterWidget(),
        ],
        backgroundColor:
            //  Colors.blueGrey[700],
            // Color.fromARGB(255, 104, 110, 43),
            Color.fromARGB(225, 53, 66, 89),
        body: Card(
          elevation: 1,
          color:
              //  Colors.blueGrey[500],
              Color.fromARGB(255, 53, 66, 89),
          margin: EdgeInsets.symmetric(vertical: 35, horizontal: 10),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GlassWidget(),
                TextWidget(text: countryname, size: 24),
                //for creating some space between text and flag

                SizedBox(
                  height: 150,
                  child: Center(
                    child: RotatedBox(
                      quarterTurns: 3,
                      child: ListWheelScrollView(
                        onSelectedItemChanged: (value) async {
                          Countries instance = locations[value];
                          await instance.getTime();
                          setState(() {
                            countryname = locations[value].name;
                            time = locations[value].time;
                            datetime =
                                DateTime.parse(locations[value].datetime);

                            if (context.read<KeyAnimator>().text == 't') {
                              context.read<KeyAnimator>().setter('f');
                            } else {
                              context.read<KeyAnimator>().setter('t');
                            }
                          });
                          context.read<GlassProvider>().setter(false);
                        },
                        useMagnifier: true,
                        offAxisFraction: 0.25,
                        squeeze: 0.9,
                        itemExtent: 100,
                        physics: const FixedExtentScrollPhysics(),
                        children: List<Widget>.generate(
                          locations.length,
                          (index) => Container(
                            height: 100,
                            width: 100,
                            color: Colors.transparent,
                            child: RotatedBox(
                              quarterTurns: 1,
                              child: Image.asset(locations[index].flag,
                                  package: 'country_icons'),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                TextWidget(text: time, size: 55, letterspacing: 7),

                AnimatedBuilder(
                  animation: _controller.view,
                  child: AnalogWidget(date: datetime),
                  builder: (BuildContext context, Widget? child) {
                    return Transform.rotate(
                      angle: _controller.value * 2 * pi,
                      child: child,
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
