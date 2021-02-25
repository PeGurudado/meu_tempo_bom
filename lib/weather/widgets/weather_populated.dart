import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_weather/weather/weather.dart';
import 'package:favorite_button/favorite_button.dart';
import 'package:flutter_weather/main.dart';

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

    if( fav == storage.getItem("city")[0] as String)
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
                  Text(getEmoji(), style: theme.textTheme.headline1.copyWith(
                    fontWeight: FontWeight.w200,
                  ),),
                  Text(
                    storage.getItem("city")[0] as String,
                    style: theme.textTheme.headline2.copyWith(
                      fontWeight: FontWeight.w200,
                    ),
                  ),
                  FavoriteButton(
                    isFavorite: isCityFavorite,
                    valueChanged: (bool isCityFavorite) {
                      String favoriteCity = null;
                      if(isCityFavorite == true)
                        favoriteCity = storage.getItem("city")[0] as String;
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
                    "Umidade Ar: "+ weather.getHumidity(),
                    style: theme.textTheme.headline5.copyWith(
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

    TimeOfDay now = TimeOfDay.now();

    if(now.hour > 6 && now.hour < 18)
      return '☀️';
    else
      return '🌙️';
  }
}



String getEmoji() {

  TimeOfDay now = TimeOfDay.now();

  if(now.hour > 6 && now.hour < 18)
    return '☀️';
  else
    return '🌙️';
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
  String getHumidity() {
    double humidity = storage.getItem("city")[4];

    return '''${humidity.toStringAsPrecision(2)}%''';
  }
}

extension on Weather {
  String getMaxTemperature() {
    double tempMax = storage.getItem("city")[3];

    return '''${tempMax.toStringAsPrecision(2)}°'C''';
  }
}


String heatIndex;

extension on Weather {
  String getHeatIndex() {
    double T = storage.getItem("city")[1], RH = storage.getItem("city")[4];

    T= (T * 9/5) + 32;

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
    HIf= (HIf -32) * 5/9;

    heatIndex = HIf.toStringAsPrecision(2);
    if (HIcheck == false)
      heatIndex = "Indefinido";
    return  heatIndex + '°C';
  }
}

extension on Weather {
  String getHeatIndexAlert() {

    if(heatIndex == "Indefinido")
      return 'Inválido';
    else if(double.parse(heatIndex) <= 27)
      return 'Normal';
    else if(double.parse(heatIndex) <= 32)
      return 'Cautela';
    else if(double.parse(heatIndex) <= 41)
      return 'Cautela Extrema';
    else if(double.parse(heatIndex) <= 54)
      return 'Perigo';
    else
      return 'Perigo Extremo';

  }
}