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
  static const int _pageSize = 5;
  List<Countries> _visibleLocations = const [];
  bool _isLoadingMore = false;

  @override
  void initState() {
    super.initState();
    _visibleLocations = widget.locations.take(_pageSize).toList();
  }

  @override
  void didUpdateWidget(covariant CountrySelector oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.locations != widget.locations &&
        widget.locations.isNotEmpty) {
      _visibleLocations = widget.locations.take(_pageSize).toList();
    }
  }

  void _maybeLoadMore(int selectedIndex) {
    if (_isLoadingMore) return;
    // If user scrolls near the end, append next page.
    final threshold = _visibleLocations.length - 2;
    if (selectedIndex < threshold) return;
    if (_visibleLocations.length >= widget.locations.length) return;

    _isLoadingMore = true;
    final nextEnd = (_visibleLocations.length + _pageSize).clamp(
      0,
      widget.locations.length,
    );
    setState(() {
      _visibleLocations = widget.locations
          .take(nextEnd)
          .toList(growable: false);
    });
    _isLoadingMore = false;
  }

  @override
  void dispose() {
    _scrollDebounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_visibleLocations.isEmpty && widget.locations.isNotEmpty) {
      _visibleLocations = widget.locations.take(_pageSize).toList();
    }

    return SizedBox(
      height: 170,
      child: Center(
        child: RotatedBox(
          quarterTurns: 3,
          child: ListWheelScrollView(
            onSelectedItemChanged: (value) {
              HapticFeedback.lightImpact();
              _maybeLoadMore(value);
              _scrollDebounce?.cancel();
              _scrollDebounce = Timer(
                const Duration(milliseconds: 300),
                () async {
                  final instance = _visibleLocations[value];
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
            children: List<Widget>.generate(
              _visibleLocations.length,
              (index) => SizedBox(
                height: 150,
                width: 80,
                child: RotatedBox(
                  quarterTurns: 1,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: Image.asset(
                      _visibleLocations[index].flag,
                      fit: BoxFit.cover,
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
