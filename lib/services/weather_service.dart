import 'dart:convert';

import 'package:flutter_weather_bg_null_safety/utils/weather_type.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:times/services/check_connection_service.dart';

class WeatherInfo {
  final WeatherType type;

  WeatherInfo(this.type);
}

class WeatherService {
  const WeatherService();

  // In-memory cache: key = "lat,lon", value = (WeatherInfo, timestamp)
  static final Map<String, ({WeatherInfo info, DateTime timestamp})> _cache =
      {};
  static const Duration _ttl = Duration(hours: 6);
  static const String _prefsPrefix = 'weather_cache_';

  Future<WeatherInfo?> fetchCurrentWeather({
    required double latitude,
    required double longitude,
  }) async {
    final key =
        '${latitude.toStringAsFixed(3)},${longitude.toStringAsFixed(3)}';
    final cached = _cache[key];

    // Check connection state once
    final bool isOnline = await CheckConnectionService.hasConnection();

    // If we have in-memory cache:
    if (cached != null) {
      final age = DateTime.now().difference(cached.timestamp);
      // When offline, always return last known value, regardless of age.
      if (!isOnline) {
        return cached.info;
      }
      // When online, use it if still within TTL.
      if (age <= _ttl) {
        return cached.info;
      }
    }

    // Try persistent cache (SharedPreferences)
    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getString('$_prefsPrefix$key');
    if (stored != null) {
      try {
        final Map<String, dynamic> jsonMap = json.decode(stored);
        final String typeName = jsonMap['type'] as String? ?? 'sunny';
        final String tsString = jsonMap['timestamp'] as String? ?? '';
        final DateTime ts =
            DateTime.tryParse(tsString) ??
            DateTime.fromMillisecondsSinceEpoch(0);

        final WeatherType type = WeatherType.values.firstWhere(
          (e) => e.name == typeName,
          orElse: () => WeatherType.sunny,
        );
        final info = WeatherInfo(type);
        final age = DateTime.now().difference(ts);

        if (!isOnline) {
          // Offline: always use last stored value, even if older than TTL.
          _cache[key] = (info: info, timestamp: ts);
          return info;
        }

        // Online: use only if still within TTL.
        if (age <= _ttl) {
          _cache[key] = (info: info, timestamp: ts);
          return info;
        }
      } catch (_) {
        // Corrupted cache entry; ignore and fall through to network.
      }
    }

    // If we reach here and we are offline, we have no usable cache; bail out.
    if (!isOnline) {
      return null;
    }

    final uri =
        Uri.https('api.open-meteo.com', '/v1/forecast', <String, String>{
          'latitude': latitude.toString(),
          'longitude': longitude.toString(),
          'current_weather': 'true',
        });

    final response = await http.get(uri);
    if (response.statusCode != 200) return null;

    final Map<String, dynamic> data = json.decode(response.body);
    final current = data['current_weather'] as Map<String, dynamic>?;
    if (current == null) return null;

    final int code = (current['weathercode'] as num?)?.toInt() ?? 0;
    final bool isDay = (current['is_day'] as num?) == 1;
    final WeatherType type = _mapWeatherCodeToType(code, isDay);
    final info = WeatherInfo(type);

    // Cache the result with current timestamp (memory + disk)
    final now = DateTime.now();
    _cache[key] = (info: info, timestamp: now);
    final cachePayload = <String, dynamic>{
      'type': type.name,
      'timestamp': now.toIso8601String(),
    };
    await prefs.setString('$_prefsPrefix$key', json.encode(cachePayload));

    return info;
  }

  WeatherType _mapWeatherCodeToType(int code, bool isDay) {
    // Clear sky
    if (code == 0) return isDay ? WeatherType.sunny : WeatherType.sunnyNight;

    // Mainly clear / partly cloudy
    if (code == 1 || code == 2) {
      return isDay ? WeatherType.cloudy : WeatherType.cloudyNight;
    }

    // Overcast
    if (code == 3) return WeatherType.overcast;

    // Fog / depositing rime fog
    if (code == 45 || code == 48) return WeatherType.foggy;

    // Drizzle (light / moderate / dense)
    if (code == 51 || code == 53 || code == 55) {
      return WeatherType.lightRainy;
    }

    // Freezing drizzle / freezing rain
    if (code == 56 || code == 57 || code == 66 || code == 67) {
      return WeatherType.middleRainy;
    }

    // Rain (slight / moderate / heavy)
    if (code == 61 || code == 63) return WeatherType.middleRainy;
    if (code == 65) return WeatherType.heavyRainy;

    // Snow fall (slight / moderate / heavy) and snow grains
    if (code == 71) return WeatherType.lightSnow;
    if (code == 73) return WeatherType.middleSnow;
    if (code == 75 || code == 77) return WeatherType.heavySnow;

    // Rain showers (slight / moderate / violent)
    if (code == 80) return WeatherType.lightRainy;
    if (code == 81) return WeatherType.middleRainy;
    if (code == 82) return WeatherType.heavyRainy;

    // Snow showers (slight / heavy)
    if (code == 85) return WeatherType.middleSnow;
    if (code == 86) return WeatherType.heavySnow;

    // Thunderstorm (with or without hail)
    if (code == 95 || code == 96 || code == 99) return WeatherType.thunder;

    // Fallback
    return isDay ? WeatherType.sunny : WeatherType.sunnyNight;
  }
}
