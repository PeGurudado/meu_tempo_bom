import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_weather/search/search.dart';
import 'package:flutter_weather/theme/theme.dart';
import 'package:flutter_weather/weather/weather.dart';
import 'package:pedantic/pedantic.dart';
import 'package:weather_repository/weather_repository.dart';

class WeatherPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => WeatherCubit(context.read<WeatherRepository>()),
      child: WeatherView(),
    );
  }
}

class WeatherView extends StatelessWidget {

  IconData favoriteIcon;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: <Widget>[
            Spacer(),
            const Text('Meu Tempo Bom', style: TextStyle(fontSize: 25)),
            Spacer(),
          ],
        ),
      ),
      body: Center(
        child: BlocConsumer<WeatherCubit, WeatherState>(
          listener: (context, state) {
            if (state.status.isSuccess) {
              context.read<ThemeCubit>().updateTheme(state.weather);
            }
          },
          builder: (context, state) {
            switch (state.status) {
              case WeatherStatus.initial:
                return const WeatherEmpty();
              case WeatherStatus.loading:
                return const WeatherLoading();
              case WeatherStatus.success:
                return WeatherPopulated(
                  onRefresh: () =>
                      context.read<WeatherCubit>().refreshWeather(),
                  weather: state.weather,
                  units: state.temperatureUnits,
                );
              case WeatherStatus.failure:
              default:
                return const WeatherError();
            }
          },
        ),
      ),
      floatingActionButton: FlatButton(
        child: const Text("Procurar", textScaleFactor: 1.75),
        height: 100,
        minWidth: MediaQuery.of(context).size.width - 32,
        onPressed: () async {
          final city = await Navigator.of(context).push(SearchPage.route());
           unawaited(context.read<WeatherCubit>().fetchWeather(city));
        },
      ),
    );
  }
}
