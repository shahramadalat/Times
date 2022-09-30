import 'dart:io';

class CheckConectivity {
  String url;
  CheckConectivity({
    required this.url,
  });
  Future<bool> GetConnection() async => await CheckUserConnection();

  Future<bool> CheckUserConnection() async {
    try {
      // we use asynchronus to make sure that the internet is active firstly
      final result = await InternetAddress.lookup(
          'https://timeapi.io/api/Time/current/zone?timeZone=$url');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;
      }
      return false;
    } on SocketException catch (_) {
      return false;
    }
  }
}
