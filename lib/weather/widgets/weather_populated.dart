import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_weather/weather/weather.dart';
import 'package:weather_repository/weather_repository.dart'
    show WeatherCondition;
import 'package:favorite_button/favorite_button.dart';
import 'package:flutter_weather/main.dart';
import 'package:localstorage/localstorage.dart';
import 'package:flutter_weather/search/search.dart';

class WeatherPopulated extends StatelessWidget {
  const WeatherPopulated({
    Key key,
    @required this.weather,
    @required this.units,
    @required this.onRefresh,
  }) : super(key: key);

  final Weather weather;
  final TemperatureUnits units;
  final ValueGetter<Future<void>> onRefresh;


  bool updateFavoriteButton()
  {
    String fav = storage.getItem("favorito") as String;

    if( fav == weather.location)
      return true;
    else
      return false;
  }


  @override
  Widget build(BuildContext context) {
    bool isCityFavorite = updateFavoriteButton();
    final theme = Theme.of(context);
    return Stack(
      children: [
        _WeatherBackground(),
        RefreshIndicator(
          onRefresh: onRefresh,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            clipBehavior: Clip.none,
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 48),
                  _WeatherIcon(condition: weather.condition),
                  Text(
                    weather.location,
                    style: theme.textTheme.headline2.copyWith(
                      fontWeight: FontWeight.w200,
                    ),
                  ),
                  FavoriteButton(
                    isFavorite: isCityFavorite,
                    valueChanged: (bool isCityFavorite) {
                      String favoriteCity = null;
                      if(isCityFavorite == true)
                        favoriteCity = weather.location;
                      else
                        favoriteCity = null;

                      storage.setItem("favorito", favoriteCity);
                    },
                  ),
                  Text(
                    weather.getTemperature(),
                    style: theme.textTheme.headline3.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "Temp min: "+ weather.getMinTemperature(),
                    style: theme.textTheme.headline6.copyWith(
                      fontWeight: FontWeight.w100,
                    ),
                  ),
                  Text(
                    "Temp máx: "+ weather.getMaxTemperature(),
                    style: theme.textTheme.headline6.copyWith(
                      fontWeight: FontWeight.w100,
                    ),
                  ),
                  Text(
                    "Heat Index : "+ weather.getHeatIndex(),
                    style: TextStyle(height: 2,fontSize: 33),
                  ),
                  Text(
                    "Nível de alerta: "+ weather.getHeatIndexAlert(),
                    style: TextStyle(fontSize: 25),
                  ),
                  Text(
                    '''Atualizado as ${TimeOfDay.fromDateTime(weather.lastUpdated).format(context)}''',
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _WeatherIcon extends StatelessWidget {
  const _WeatherIcon({
    Key key,
    @required this.condition,
  }) : super(key: key);

  static const _iconSize = 100.0;

  final WeatherCondition condition;

  @override
  Widget build(BuildContext context) {
    return Text(
      condition.toEmoji,
      style: const TextStyle(fontSize: _iconSize),
    );
  }
}

extension on WeatherCondition {
  String get toEmoji {
    switch (this) {
      case WeatherCondition.clear:
        return '☀️';
      case WeatherCondition.rainy:
        return '🌧️';
      case WeatherCondition.cloudy:
        return '☁️';
      case WeatherCondition.snowy:
        return '🌨️';
      case WeatherCondition.unknown:
      default:
        return '❓';
    }
  }
}

class _WeatherBackground extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).primaryColor;
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: [0.25, 0.75, 0.90, 1.0],
          colors: [
            color,
            color.brighten(10),
            color.brighten(33),
            color.brighten(50),
          ],
        ),
      ),
    );
  }
}

extension on Color {
  Color brighten([int percent = 10]) {
    assert(1 <= percent && percent <= 100);
    final p = percent / 100;
    return Color.fromARGB(
      alpha,
      red + ((255 - red) * p).round(),
      green + ((255 - green) * p).round(),
      blue + ((255 - blue) * p).round(),
    );
  }
}

extension on Weather {
  String getTemperature() {
    double temp = storage.getItem("city")[1];

    return '''${temp.toStringAsPrecision(2)}°'C''';
  }
}

extension on Weather {
  String getMinTemperature() {
    double tempMin = storage.getItem("city")[2];


    return '''${tempMin.toStringAsPrecision(2)}°'C''';
  }
}

extension on Weather {
  String getMaxTemperature() {
    double tempMax = storage.getItem("city")[3];


    return '''${tempMax.toStringAsPrecision(2)}°'C''';
  }
}


double heatIndex;

extension on Weather {
  String getHeatIndex() {
    double T = storage.getItem("city")[1], RH = storage.getItem("city")[4];
    T= temperature.value;
    
    bool HIcheck;
    double HIf = 0;
    double HI = 0;

    HI = 1.1 * T - 10.3 + 0.047 * RH;
    if( HI < 80) 
    {
      HIcheck = true;
      HIf = HI;
    }else
    {
      HI = (-42.379 +
      2.04901523 * T +
      10.14333127 * RH -
      0.22475541 * T * RH -
      6.83783 * pow(10,-3) * pow(T,2) -
      5.481717 * pow(10,-2) * pow(RH,2) +
      1.22874 * pow(10,-3) * pow(T,2) * RH +
      8.5282 * pow(10,-4) * T * pow(RH,2) -
      1.99 * pow(10,-6) * pow(T,2) * pow(RH,2));
      if (T <= 80 && T <=112 && RH <= 13)
      {
        HIcheck = true;
        HIf = HI - (3.25 - 0.25 * RH) * ((17 - (T-95).abs())/17)*0.5;
      }
      else if (T <= 80 && T <= 87 && RH > 85)
      {
        HIcheck = true;
        HIf = HI + 0.02 * (RH -85) * (87-T);
      }
      else
        HIcheck = false;
    }

    heatIndex = HIf;
    return  '''${heatIndex.toStringAsPrecision(2)}°'C''';
  }
}

extension on Weather {
  String getHeatIndexAlert() {
    if(heatIndex <= 27)
      return 'Normal';
    else if(heatIndex <= 32)
      return 'Cautela';
    else if(heatIndex <= 41)
      return 'Cautela Extrema';
    else if(heatIndex <= 54)
      return 'Perigo';
    else
      return 'Perigo Extremo';

  }
}