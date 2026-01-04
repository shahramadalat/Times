import 'dart:math'; // for the math functions
import 'package:arabic_numbers/arabic_numbers.dart'; // for converting from english letter to arabic letter
import 'package:intl/intl.dart'; // for working with datetime and formatting purpose
import 'dart:async';

class Countries {
  int id; // for any case we need it, !not now
  String name; // country name
  String time = "";
  String period = "";
  String flag; // countries icon
  String datetime = "";
  String url; // location url for api endpoint
  int utcHour; // the country we want to get the time
  int utcMinutes;
  final double? latitude;
  final double? longitude;

  Countries({
    required this.id,
    required this.name,
    required this.flag,
    required this.url,
    required this.utcHour,
    required this.utcMinutes,
    this.latitude,
    this.longitude,
  });
  Future<void> getTime() async {
    // Fully offline: always compute time from utcHour/utcMinutes.
    _computeOffline();
    return;
  }

  // a method for converting english numbers to arabic
  String getArabicTime(String time, first) {
    first = ArabicNumbers().convert(first);
    String last = time.substring(max(time.length - 2, 0));
    last = ArabicNumbers().convert(last);
    if (time.length == 4) {
      first = '٠$first';
    }
    return '$first:$last';
  }

  void _computeOffline() {
    DateTime aTime = DateTime.now()
        .toLocal(); // getting the system current time
    Duration aUtc = DateTime.now().timeZoneOffset; // getting the system UTC
    // the formula for converting to the other country time
    DateTime result = aTime
        .subtract(aUtc)
        .add(Duration(hours: utcHour, minutes: utcMinutes));
    // converting by using intl library
    time = DateFormat.Hm().format(result).toString();
    datetime = result.toString();
    _normalizePeriodAndFormat();
  }

  void _normalizePeriodAndFormat() {
    String twoFirstString = time.substring(0, 2); // get the hour
    int parseHour = int.parse(twoFirstString); //parse the hour
    bool isGreater = parseHour > 12
        ? true
        : false; // check if greater than 12 ocklock
    if (isGreater) {
      parseHour = parseHour - 12; // if greater than tweleve mines it
      twoFirstString = parseHour.toString();
    }
    time = isGreater
        ? time.replaceRange(0, 2, parseHour.toString())
        : time; // if greater than 12 replace with smaller
    time = getArabicTime(time, twoFirstString); //convert to arabic numbers
    period = isGreater ? 'دوای نیوەڕۆ' : 'پێش نیوەڕۆ';
  }
}
