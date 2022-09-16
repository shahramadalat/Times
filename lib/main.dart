import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:times/pages/analog_clock.dart';
import 'package:times/services/countries.dart';
import 'package:times/pages/text_widget.dart';

void main() {
  runApp(MaterialApp(
    theme: ThemeData(fontFamily: 'rudaw'),
    home: const MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
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

  var countryname = 'بەریتانیا';
  String time = '';
  DateTime datetime = DateTime.now();
  String flag = 'icons/flags/png/us.png';
  bool firstTime = true;

  List<Countries> locations = [
    Countries(
        id: 1,
        name: 'بەریتانیا',
        flag: 'icons/flags/png/gb.png',
        url: 'Europe/London'),
    Countries(
        id: 1,
        name: 'ئەمریکا + کەنەدا',
        flag: 'icons/flags/png/us.png',
        url: 'America/New_York'),
    Countries(
        id: 1,
        name: 'عێراق',
        flag: 'icons/flags/png/iq.png',
        url: 'Asia/Baghdad'),
    Countries(
        id: 1,
        name: 'هیندستان',
        flag: 'icons/flags/png/in.png',
        url: 'Asia/Colombo'),
    Countries(
        id: 1, name: 'تورکیا', flag: 'icons/flags/png/tr.png', url: 'Turkey'),
    Countries(
        id: 1,
        name: 'سوید',
        flag: 'icons/flags/png/se.png',
        url: 'Europe/Stockholm'),
    Countries(
        id: 1,
        name: 'یابان',
        flag: 'icons/flags/png/jp.png',
        url: 'Asia/Tokyo'),
    Countries(
        id: 1,
        name: 'چین',
        flag: 'icons/flags/png/cn.png',
        url: 'Asia/Ulaanbaatar'),
    Countries(
        id: 1,
        name: 'ئەڵمانیا',
        flag: 'icons/flags/png/de.png',
        url: 'Europe/Berlin'),
    Countries(
        id: 1,
        name: 'میسر',
        flag: 'icons/flags/png/eg.png',
        url: 'Africa/Cairo'),
    Countries(
        id: 1,
        name: 'فەڕەنسا',
        flag: 'icons/flags/png/fr.png',
        url: 'Europe/Paris'),
    Countries(
        id: 1,
        name: 'سعودیا',
        flag: 'icons/flags/png/sa.png',
        url: 'Asia/Riyadh'),
    Countries(
        id: 1,
        name: 'نەرویج',
        flag: 'icons/flags/png/no.png',
        url: 'Europe/Oslo'),
    Countries(
        id: 1,
        name: 'یۆنان',
        flag: 'icons/flags/png/gr.png',
        url: 'Europe/Athens'),
    Countries(
        id: 1,
        name: 'ئەفغانستان',
        flag: 'icons/flags/png/af.png',
        url: 'Asia/Kabul'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      persistentFooterAlignment: AlignmentDirectional.center,
      persistentFooterButtons: [
        Text(
          '0751 231 9423',
          style: TextStyle(color: Colors.white),
        ),
        Text(
          'بۆ پشتگیریکردنمان لەڕێگەی فاستپەی',
          style: TextStyle(color: Colors.white70, fontSize: 12),
        ),
        IconButton(
            color: Colors.blueGrey[600],
            onPressed: () {
              Clipboard.setData(ClipboardData(text: '07512319423')).then(
                (_) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: Colors.blueGrey[700],
                      content: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextWidget(text: 'کۆپی کرا', size: 12),
                          SizedBox(height: 20),
                          Icon(
                            Icons.check,
                            color: Colors.lightGreen,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
            icon: Icon(Icons.copy))
      ],
      backgroundColor: Colors.blueGrey[900],
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
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
                        datetime = DateTime.parse(locations[value].datetime);
                        _controller.value = _controller.value * 2 * pi;
                      });
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
            //for choosing between two text if its first time or not
            LayoutBuilder(builder: (context, constraints) {
              if (firstTime) {
                firstTime = false;
                return TextWidget(
                  text: 'ئاڵاکان بجوڵێنە',
                  size: 18,
                );
              } else {
                return TextWidget(text: time, size: 55, letterspacing: 7);
              }
            }),

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
    );
  }
}
