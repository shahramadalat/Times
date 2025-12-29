import 'dart:convert'; // for converting purpose like jsonDecode function
import 'dart:math'; // for the math functions
import 'package:http/http.dart'; // for working with http
import 'package:arabic_numbers/arabic_numbers.dart'; // for converting from english letter to arabic letter
import 'package:intl/intl.dart'; // for working with datetime and formatting purpose
import 'package:times/services/check_connection_service.dart'; // a class for check if the server respondes or not

class Countries {
  int id; // for any case we need it, !not now
  String name; // country name
  String time = "";
  String flag; // countries icon
  String datetime = "";
  String url; // location url for api endpoint
  int utcHour; // the country we want to get the time
  int utcMinutes;

  Countries({
    required this.id,
    required this.name,
    required this.flag,
    required this.url,
    required this.utcHour,
    required this.utcMinutes,
  });
  Future<void> getTime() async {
    // make the request
    try {
      // check the connection before using the api
      CheckConectivity checkConectivity = CheckConectivity(url: url);
      // return if we are online or offline
      bool IsActive = await checkConectivity.GetConnection();
      if (IsActive) {
        GetTimOnline(true);
      } else {
        GetTimOnline(false);
      }
    } catch (e) {
      time = 'نەتوانرا کاتەکە دیاری بکرێت.';
    }
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

  void GetTimOnline(bool isActive) async {
    if (isActive) {
      // making a request by using http of dart
      Response response = await get(
          Uri.parse('https://timeapi.io/api/Time/current/zone?timeZone=$url'));
      Map data = jsonDecode(response.body); //
      time = data['time'];
      datetime = data['dateTime'];
    } else {
      DateTime aTime =
          DateTime.now().toLocal(); // getting the system current time
      Duration aUtc = DateTime.now().timeZoneOffset; // getting the system UTC
      // the formula for converting to the other country time
      DateTime result = aTime
          .subtract(aUtc)
          .add(Duration(hours: utcHour, minutes: utcMinutes));
      // converting by using intl library
      time = DateFormat.Hm().format(result).toString();
      datetime = result.toString();
    }

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
  }
}
