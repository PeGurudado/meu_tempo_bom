import 'package:flutter/material.dart';
import 'package:flutter_weather/weather/weather.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

class ThemeCubit extends HydratedCubit<Color> {
  ThemeCubit() : super(defaultColor);

  static const defaultColor = Color(0xFFFFc107);

  void updateTheme(Weather weather) => emit(weather.toColor);

  @override
  Color fromJson(Map<String, dynamic> json) {
    return Color(int.parse(json['color'] as String));
  }

  @override
  Map<String, dynamic> toJson(Color state) {
    return <String, String>{'color': '${state.value}'};
  }
}

extension on Weather {
  Color get toColor {
    TimeOfDay now = TimeOfDay.now();

    if(now.hour > 6 && now.hour < 18)
      return Colors.amber;
    else
      return Colors.indigo;
    }
  }

