import 'package:equatable/equatable.dart';
import 'package:flutter_weather/weather/weather.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:flutter_weather/inmet_api.dart';
import 'package:flutter_weather/main.dart';
import 'package:weather_repository/weather_repository.dart'
    show WeatherRepository;

part 'weather_cubit.g.dart';
part 'weather_state.dart';

String gCity;

Future<void> getCityInfos(String iCity) async {
  await inmetGetInfos(iCity);
}

class WeatherCubit extends HydratedCubit<WeatherState> {
  WeatherCubit(this._weatherRepository) : super(const WeatherState());

  final WeatherRepository _weatherRepository;

  Future<void> fetchWeather(String city) async {
    gCity = city;
    if (city == null || city.isEmpty) return;

    emit(state.copyWith(status: WeatherStatus.loading));

    await getCityInfos(city);

    if (storage.getItem("city") != null)
      emit(state.copyWith(status: WeatherStatus.success));
    else
      emit(state.copyWith(status: WeatherStatus.failure));

    await inmetGetInfos(city);

    if (storage.getItem("city") != null)
      state.copyWith(status: WeatherStatus.success);
    else
    {
      print("falhou a cidade");
      emit(state.copyWith(status: WeatherStatus.failure));
    }
  }

  Future<void> refreshWeather() async {
    if (!state.status.isSuccess) return;

    await getCityInfos(gCity);

    if(storage.getItem("city") != null)
      emit(state.copyWith(status: WeatherStatus.success));
    else
      emit(state.copyWith(status: WeatherStatus.failure));

  }

  @override
  WeatherState fromJson(Map<String, dynamic> json) =>
      WeatherState.fromJson(json);

  @override
  Map<String, dynamic> toJson(WeatherState state) => state.toJson();
}

  @override
  WeatherState fromJson(Map<String, dynamic> json) {
    throw UnimplementedError();
  }

  @override
  Map<String, dynamic> toJson(WeatherState state) {
    throw UnimplementedError();
  }