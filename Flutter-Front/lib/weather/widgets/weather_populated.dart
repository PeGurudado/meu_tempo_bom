import 'dart:math';
import 'package:toast/toast.dart';
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
    String fav2 = storage.getItem("favorito2") as String;
    String fav3 = storage.getItem("favorito3") as String;


    if( fav == storage.getItem("city")[0] as String ||
        fav2 == storage.getItem("city")[0] as String ||
        fav3 == storage.getItem("city")[0] as String)
      return true;
    else
      return false;
  }

  void HistoryValues()
  {
    if(storage.getItem("city") == null)
      return;

    List<dynamic> cityList =
      [storage.getItem("city")[1], storage.getItem("city")[4], storage.getItem("city")[9], storage.getItem("city")[2],
        storage.getItem("city")[3], storage.getItem("city")[5],storage.getItem("city")[6], storage.getItem("city")[7],
        storage.getItem("city")[8]] as List<dynamic>;
    Map<String,dynamic> hist = {};

    if(storage.getItem("historico") != null)
      hist = storage.getItem("historico") as Map<String,dynamic>;

    if(hist[ (storage.getItem("city")[0] as String) ] == null) {
      hist[(storage.getItem("city")[0] as String)] = [ cityList];
    }
    else {
      List<dynamic> histCity = hist[(storage.getItem(
          "city")[0] as String)] as List<dynamic>;

      if (histCity == null)
        return;
      histCity.add(cityList);

      hist[(storage.getItem("city")[0] as String)] = histCity;
    }

     storage.setItem("historico", hist);
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

                      if(favoriteCity == storage.getItem("favorito") || favoriteCity == storage.getItem("favorito2") || favoriteCity == storage.getItem("favorito3"))
                        print("ja favoritou");
                      else if(storage.getItem("favorito") == null)
                        storage.setItem("favorito", favoriteCity);
                      else if(storage.getItem("favorito2") == null)
                        storage.setItem("favorito2", favoriteCity);
                      else if(storage.getItem("favorito3") == null)
                        storage.setItem("favorito3", favoriteCity);
                      else
                      {
                        storage.setItem("favorito3",
                            storage.getItem("favorito2"));
                        storage.setItem("favorito2",
                            storage.getItem("favorito"));
                        storage.setItem("favorito", favoriteCity);
                      }

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
                  FlatButton(
                    onPressed: () => {
                    HistoryValues(),
                    Toast.show("Dados salvos no histórico.", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.BOTTOM),

                  },
                    child: Text( "💾",
                      textAlign: TextAlign.right, style: TextStyle(
                      height: 1,
                      color: Colors.amber,
                      fontWeight: FontWeight.bold,
                      fontSize: 35)
                    ),
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
    double HI = storage.getItem("city")[9];

    // HIf= (HIf -32) * 5/9;

    heatIndex = HI.toStringAsPrecision(2);
    if (HI==0)
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