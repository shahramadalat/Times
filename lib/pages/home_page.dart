import 'dart:async';
import 'dart:math';
import 'dart:ui';
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
import 'package:arabic_numbers/arabic_numbers.dart';
import 'package:flutter_weather_bg_null_safety/bg/weather_bg.dart';
import 'package:flutter_weather_bg_null_safety/utils/weather_type.dart';
import 'package:times/services/weather_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<Countries> locations = Country.locations;
  Timer? _scrollDebounce;
  Timer? _timer;
  final ValueNotifier<String> _countryName = ValueNotifier('');
  final ValueNotifier<String> _time = ValueNotifier('');
  final ValueNotifier<String> _period = ValueNotifier('');
  final ValueNotifier<DateTime> _dateTime = ValueNotifier(DateTime.now());
  final ValueNotifier<bool> _isLoading = ValueNotifier(false);
  final ValueNotifier<WeatherType?> _weatherType = ValueNotifier(null);
  final WeatherService _weatherService = const WeatherService();
  Countries? _currentSelected;
  final double _twoPi = 2 * pi;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _controller.forward();

    // Note: Cache warming is now done in SplashScreen, but we can keep this or remove it.
    // If we land here, we assume data is ready or we can fetch lazily.
    // Ideally, we start the clock immediately.

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_currentSelected != null) {
        _dateTime.value = _dateTime.value.add(const Duration(seconds: 1));
        _updateDisplayStrings();
      }
    });

    super.initState();
  }

  void _updateDisplayStrings() {
    if (_currentSelected == null) return;

    final dt = _dateTime.value;
    final hour = dt.hour;
    final isPm = hour >= 12;
    final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);

    // Format: "HH:mm" (Arabic numerals)
    final arabicNumbers = ArabicNumbers();
    final hourStr = displayHour < 10
        ? '٠${arabicNumbers.convert(displayHour)}'
        : arabicNumbers.convert(displayHour);
    final minuteStr = dt.minute < 10
        ? '٠${arabicNumbers.convert(dt.minute)}'
        : arabicNumbers.convert(dt.minute);

    _time.value = '$hourStr:$minuteStr';
    _period.value = isPm ? 'دوای نیوەڕۆ' : 'پێش نیوەڕۆ';
  }

  @override
  void dispose() {
    _scrollDebounce?.cancel();
    _timer?.cancel();
    _countryName.dispose();
    _time.dispose();
    _period.dispose();
    _dateTime.dispose();
    _isLoading.dispose();
    _weatherType.dispose();
    _controller.dispose();
    super.dispose();
  }

  Widget _buildTimeStatusItem(String text, Color color, bool isActive) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isActive
            ? color.withOpacity(0.4)
            : Colors.black.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isActive ? color : Colors.white24,
          width: isActive ? 2 : 1,
        ),
        boxShadow: isActive
            ? [
                BoxShadow(
                  color: color.withOpacity(0.3),
                  blurRadius: 8,
                  spreadRadius: 1,
                ),
              ]
            : [],
      ),
      child: Text(
        text,
        style: TextStyle(
          color: isActive ? Colors.white : Colors.white.withOpacity(0.6),
          fontSize: 13,
          fontWeight: isActive ? FontWeight.w900 : FontWeight.w500,
          shadows: isActive
              ? [
                  const Shadow(
                    color: Colors.black26,
                    offset: Offset(0, 1),
                    blurRadius: 2,
                  ),
                ]
              : [],
        ),
      ),
    );
  }

  Widget _buildTimeOfDayStatusRow(int hour) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(25),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildTimeStatusItem(
              'خۆرهەڵاتن',
              Colors.amberAccent,
              hour >= 5 && hour < 8,
            ),
            const SizedBox(width: 6),
            _buildTimeStatusItem(
              'ڕۆژ',
              Colors.lightBlueAccent,
              hour >= 8 && hour < 17,
            ),
            const SizedBox(width: 6),
            _buildTimeStatusItem(
              'خۆرئاوابوون',
              Colors.deepOrangeAccent,
              hour >= 17 && hour < 20,
            ),
            const SizedBox(width: 6),
            _buildTimeStatusItem(
              'شەو',
              Colors.indigoAccent,
              hour >= 20 || hour < 5,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<DateTime>(
      valueListenable: _dateTime,
      builder: (context, dateTime, _) {
        final size = MediaQuery.of(context).size;
        return Stack(
          children: [
            ValueListenableBuilder<WeatherType?>(
              valueListenable: _weatherType,
              builder: (_, type, __) {
                if (type == null) {
                  return Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color(0xFF0f0c29),
                          Color(0xFF302b63),
                          Color(0xFF24243e),
                        ],
                      ),
                    ),
                  );
                }
                return WeatherBg(
                  weatherType: type,
                  width: size.width,
                  height: size.height,
                );
              },
            ),
            Scaffold(
              backgroundColor: Colors.transparent,
              persistentFooterAlignment: AlignmentDirectional.center,
              persistentFooterButtons: const [FooterWidget()],
              body: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 35,
                    horizontal: 15,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.2),
                            width: 1.5,
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const GlassWidget(),
                            ValueListenableBuilder<String>(
                              valueListenable: _countryName,
                              builder: (_, value, __) => Column(
                                children: [TextWidget(text: value, size: 24)],
                              ),
                            ),
                            CountrySelector(
                              locations: locations,
                              onCountrySelected: (instance) async {
                                _isLoading.value = true;
                                _currentSelected = instance;
                                _countryName.value = instance.name;

                                await instance.getTime();

                                _time.value = instance.time;
                                _period.value = instance.period;

                                if (instance.datetime.isNotEmpty) {
                                  _dateTime.value = DateTime.parse(
                                    instance.datetime,
                                  );
                                }

                                if (instance.latitude != null &&
                                    instance.longitude != null) {
                                  final weather = await _weatherService
                                      .fetchCurrentWeather(
                                        latitude: instance.latitude!,
                                        longitude: instance.longitude!,
                                      );
                                  _weatherType.value = weather?.type;
                                } else {
                                  _weatherType.value = null;
                                }

                                if (context.mounted) {
                                  if (context.read<KeyAnimator>().text == 't') {
                                    context.read<KeyAnimator>().setter('f');
                                  } else {
                                    context.read<KeyAnimator>().setter('t');
                                  }
                                  context.read<GlassProvider>().setter(false);
                                }

                                _controller.reset();
                                _controller.forward();
                                _isLoading.value = false;
                              },
                            ),
                            ValueListenableBuilder<bool>(
                              valueListenable: _isLoading,
                              builder: (_, isLoading, __) {
                                if (isLoading) {
                                  return const Padding(
                                    padding: EdgeInsets.all(20.0),
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                    ),
                                  );
                                }
                                return ValueListenableBuilder<String>(
                                  valueListenable: _time,
                                  builder: (_, timeValue, __) => Column(
                                    children: [
                                      TextWidget(
                                        text: timeValue,
                                        size: 55,
                                        letterspacing: 7,
                                      ),
                                      if (timeValue.isNotEmpty)
                                        _buildTimeOfDayStatusRow(dateTime.hour),
                                    ],
                                  ),
                                );
                              },
                            ),
                            const SizedBox(height: 20),
                            AnimatedBuilder(
                              animation: _controller.view,
                              builder: (BuildContext context, Widget? child) {
                                return AnalogWidget(
                                  date: _dateTime.value,
                                  rotationAngle: _controller.value * _twoPi,
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
