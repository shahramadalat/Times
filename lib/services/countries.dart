import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart';
import 'package:arabic_numbers/arabic_numbers.dart';

class Countries {
  int id;
  String name;
  String time = "";
  String flag;
  String datetime = "";
  String url; // location url for api endpoint

  Countries(
      {required this.id,
      required this.name,
      required this.flag,
      required this.url});
  Future<void> getTime() async {
    // make the request
    try {
      Response response = await get(
          Uri.parse('https://timeapi.io/api/Time/current/zone?timeZone=$url'));
      Map data = jsonDecode(response.body);

      time = data['time'];
      datetime = data['dateTime'];

      String twoFirstString = time.substring(0, 2); // get the hour
      int parseHour = int.parse(twoFirstString); //parse the hour
      bool isGreater =
          parseHour > 12 ? true : false; // check if greater than 12 ocklock
      if (isGreater) {
        parseHour = parseHour - 12; // if greater than tweleve mines it
        twoFirstString = parseHour.toString();
      }
      time = isGreater
          ? time.replaceRange(0, 2, parseHour.toString())
          : time; // if greater than 12 replace with smaller
      time = getArabicTime(time, twoFirstString); //convert to arabic numbers
      time = isGreater ? '$time د.ن' : '$time پ.ن';
    } catch (e) {
      time = 'نەتوانرا کاتەکە دیاری بکرێ، تکایە هێڵی ئینتەرنێت با کراوە بێت.';
    }
  }

  String getArabicTime(String time, first) {
    first = ArabicNumbers().convert(first);
    String last = time.substring(max(time.length - 2, 0));
    last = ArabicNumbers().convert(last);
    if (time.length == 4) {
      first = '٠$first';
    }
    return '$first:$last';
  }
}
