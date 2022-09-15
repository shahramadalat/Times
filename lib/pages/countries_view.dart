import 'package:analog_clock/analog_clock.dart';
import 'package:flutter/material.dart';
import 'package:times/services/countries.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
        name: 'ئەمریکا - نیو یۆرک',
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
    return Column(
      children: [
        Text(
          countryname,
          style: const TextStyle(
            fontSize: 24,
            fontFamily: 'rudaw',
            color: Colors.white,
          ),
        ),
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
            return Text('ئاڵاکان بجوڵێنە',
                style: const TextStyle(
                  fontSize: 18,
                  fontFamily: 'rudaw',
                  color: Colors.white,
                ));
          } else {
            return Text(time,
                style: const TextStyle(
                  fontSize: 55,
                  letterSpacing: 7,
                  fontFamily: 'rudaw',
                  color: Colors.white,
                ));
          }
        }),
        Container(
          height: 200,
          width: 200,
          child: AnalogClock(
            tickColor: Colors.white70,
            minuteHandColor: Colors.white54,
            hourHandColor: Colors.white70,
            showDigitalClock: false,
            digitalClockColor: Colors.white60,
            showSecondHand: false,
            datetime: datetime,
            showNumbers: false,
          ),
        ),
      ],
    );
  }
}
