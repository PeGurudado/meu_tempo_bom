import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_weather/search/search.dart';
import 'package:flutter_weather/theme/theme.dart';
import 'package:flutter_weather/FavPage.dart';
import 'package:flutter_weather/AlertsPage.dart';
import 'package:flutter_weather/HistoryPage.dart';
import 'package:flutter_weather/ForecastPage.dart';
import 'package:flutter_weather/theme/cubit/theme_cubit.dart';
import 'package:flutter_weather/weather/weather.dart';
import 'package:pedantic/pedantic.dart';
import 'package:flutter_weather/main.dart';
import 'package:weather_repository/weather_repository.dart';
import'package:flutter_weather/AlertsPage.dart';
import 'package:localstorage/localstorage.dart';

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
            IconButton(icon: Icon(Icons.settings_sharp, color: Colors.white,),
                // onPressed: onPressed
            )
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
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Text('Meu Tempo Bom', style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: Colors.white)),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
              ),
            ),
            ListTile(
              leading: Icon(Icons.favorite),
              title: Text('Favoritos' , style: TextStyle(fontSize: 25)),
              onTap: () async {
                  final city = await Navigator.of(context).push(FavPage.route());
                unawaited(context.read<WeatherCubit>().fetchWeather(city));
              }
            ),
            if(storage.getItem("city") != null)
            (
              ListTile(
                  leading: Icon(Icons.grain),
                  title: Text('Simulações ML' , style: TextStyle(fontSize: 25)),
                  onTap: () async {
                    storage.setItem("prevision", null);
                    final city = await Navigator.of(context).push(ForecastPage.route());
                    unawaited(context.read<WeatherCubit>().fetchWeather(city));
                  }
              )
            ),
            if(storage.getItem("city") != null)
            (
              ListTile(
                  leading: Icon(Icons.warning_amber_sharp),
                  title: Text('Alertas' , style: TextStyle(fontSize: 25)),
                  onTap: () async {
                    dadosCity = [];
                    final city = await Navigator.of(context).push(AlertsPage.route());
                    unawaited(context.read<WeatherCubit>().fetchWeather(city));
                  }
              )
            ),
            if(storage.getItem("city") != null)
              (
                  ListTile(
                      leading: Icon(Icons.format_indent_increase),
                      title: Text('Histórico' , style: TextStyle(fontSize: 25)),
                      onTap: () async {
                        final city = await Navigator.of(context).push(HistPage.route());
                        unawaited(context.read<WeatherCubit>().fetchWeather(city));
                      }
                  )
              ),
          ],
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
