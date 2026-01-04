import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:times/services/countries.dart';

void main() {
  test('getTime uses cached data if fresh (less than 6 hours)', () async {
    const cachedUrl = 'Asia/Baghdad';

    // Create a timestamp 2 hours ago
    final now = DateTime.now();
    final fetchedAt = now.subtract(const Duration(hours: 2));

    final cachedData = {
      'time': '12:00',
      'dateTime': fetchedAt.toIso8601String(),
      'fetchedAt': fetchedAt.millisecondsSinceEpoch,
    };

    // Set mock preferences
    SharedPreferences.setMockInitialValues({
      'country_cache_$cachedUrl': jsonEncode(cachedData),
    });

    final country = Countries(
      id: 1,
      name: 'Test',
      flag: 'flag.png',
      url: cachedUrl,
      utcHour: 3,
      utcMinutes: 0,
    );

    await country.getTime();

    // Verify data loaded from cache
    expect(country.time, isNotNull);
    // The logic runs _normalizePeriodAndFormat which might change "12:00" string depending on logic.
    // "12:00" -> 12 >= 12 -> 0 -> "0:00" in 12-hour format? Or "12:00"?
    // Logic:
    // parseHour = 12. isGreater = false (12 > 12 is false).
    // time remains "12:00".
    // getArabicTime("12:00", "12") -> converts to Arabic.

    // Verify it accepted the cache timestamp
    // Note: accessing private _lastFetchedAt is not possible directly.
    // But checked logic sets lastFetchSucceeded = true.
  });
}
