import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../services/countries.dart';

class CountrySelector extends StatefulWidget {
  final List<Countries> locations;
  final ValueChanged<Countries> onCountrySelected;

  const CountrySelector({
    super.key,
    required this.locations,
    required this.onCountrySelected,
  });

  @override
  State<CountrySelector> createState() => _CountrySelectorState();
}

class _CountrySelectorState extends State<CountrySelector> {
  Timer? _scrollDebounce;

  @override
  void dispose() {
    _scrollDebounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 170,
      child: Center(
        child: RotatedBox(
          quarterTurns: 3,
          child: ListWheelScrollView.useDelegate(
            onSelectedItemChanged: (value) {
              HapticFeedback.lightImpact();
              _scrollDebounce?.cancel();
              _scrollDebounce = Timer(
                const Duration(milliseconds: 300),
                () async {
                  // Handle infinite/circular index
                  final index = value % widget.locations.length;
                  final instance = widget.locations[index];
                  await instance.getTime();
                  if (!mounted) return;
                  widget.onCountrySelected(instance);
                },
              );
            },
            useMagnifier: true,
            magnification: 1.1,
            overAndUnderCenterOpacity: 0.7,
            diameterRatio: 2.7,
            perspective: 0.002,
            offAxisFraction: 0.0,
            squeeze: 0.8,
            itemExtent: 160,
            physics: const FixedExtentScrollPhysics(),
            childDelegate: ListWheelChildLoopingListDelegate(
              children: List<Widget>.generate(
                widget.locations.length,
                (index) => SizedBox(
                  height: 150,
                  width: 80,
                  child: RotatedBox(
                    quarterTurns: 1,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: Image.asset(
                        widget.locations[index].flag,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
