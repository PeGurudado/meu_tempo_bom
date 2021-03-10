import 'package:flutter/material.dart';
import 'package:flutter_weather/main.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_weather/weather/weather.dart';
import 'package:pedantic/pedantic.dart';




class ForecastPage extends StatefulWidget {
  ForecastPage._({Key key}) : super(key: key);

  static Route<String> route() {
    return MaterialPageRoute(builder: (_) => ForecastPage._());
  }

  @override
  State<ForecastPage> createState() => _ForecastPageState();
}

class _ForecastPageState extends State<ForecastPage> {

  void globalRadFactor()
  {
    double glo_rad = storage.getItem("city")[5];

    if(glo_rad > 700)
      storage.setItem("prevision", '☔');
    else
      storage.setItem("prevision", '🌂');
  }

  void umdFactor()
  {
    double humidity = storage.getItem("city")[4];

    if(humidity > 68)
      storage.setItem("prevision", '☔');
    else
      storage.setItem("prevision", '🌂');
  }

  void windFactor()
  {
    double wind = storage.getItem("city")[6];

    if(wind > 155)
      storage.setItem("prevision", '☔');
    else
      storage.setItem("prevision", '🌂');
  }


  @override
  Widget build(BuildContext context) {

    String forecast = storage.getItem("prevision") as String;
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
      body:  Column(children: <Widget>[
        Text('PREVISÃO DE '+ (storage.getItem("city")[0] as String),
          textAlign: TextAlign.center,
          style: TextStyle(
            height: 2,
            color: Colors.black,
            fontSize: 43,
          ),
        ),
        if(storage.getItem("prevision") != null)
        (
              Text( forecast ,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    // height: 2,
                    color: Colors.black,
                    fontSize: 100,
                  )
              )
        ),
        if(storage.getItem("prevision") ==  '☔')
        (
          Text( 'Vai chover !' ,
            textAlign: TextAlign.center,
            style: TextStyle(
              // height: 2,
              color: Colors.black,
              fontSize: 35,
            )
          )
        )
        else if(storage.getItem("prevision") ==  '🌂')
        (
            Text( 'Não vai chover !' ,
                textAlign: TextAlign.center,
                style: TextStyle(
                  // height: 2,
                  color: Colors.black,
                  fontSize: 35,
                )
            )
        )
        else
        (
          Text( '*Selecione o fator para a previsão*',
              textAlign: TextAlign.center,
              style: TextStyle(
              // height: 2,
              color: Colors.black,
              fontSize: 30,
            ),
          )
        ),
        Text('______________________________',
          textAlign: TextAlign.center,
          style: TextStyle(
            // height: 2,
            color: Colors.black,
            fontSize: 35,
          ),
        ),
        Row(
            children: [
              Spacer(),
              FlatButton(
                onPressed: () async {
                  globalRadFactor();
                  Navigator.of(context).pop((storage.getItem("city")[0] as String));
                  final city = await Navigator.of(context).push(ForecastPage.route());
                  unawaited(context.read<WeatherCubit>().fetchWeather(city));
                },
                child: Text( 'Fator Radiacao Global',
                    textAlign: TextAlign.center, style: TextStyle(
                        height: 2,
                        color: Colors.amber,
                        fontWeight: FontWeight.bold,
                        fontSize: 35)
                ),
              ),
              Spacer()
        ]),
        Row(
            children: [
              Spacer(),
              FlatButton(
                onPressed: () async {
                  umdFactor();
                  Navigator.of(context).pop((storage.getItem("city")[0] as String));
                  final city = await Navigator.of(context).push(ForecastPage.route());
                  unawaited(context.read<WeatherCubit>().fetchWeather(city));
                },
                child: Text( 'Fator Umidade no Ar',
                    textAlign: TextAlign.center, style: TextStyle(
                        height: 2,
                        color: Colors.amber,
                        fontWeight: FontWeight.bold,
                        fontSize: 35)
                ),
              ),
              Spacer()
            ]),
        Row(
            children: [
              Spacer(),
              FlatButton(
                onPressed: () async {
                  windFactor();
                  Navigator.of(context).pop((storage.getItem("city")[0] as String));
                  final city = await Navigator.of(context).push(ForecastPage.route());
                  unawaited(context.read<WeatherCubit>().fetchWeather(city));
                },
                child: Text( 'Fator vento',
                    textAlign: TextAlign.center, style: TextStyle(
                        height: 2,
                        color: Colors.amber,
                        fontWeight: FontWeight.bold,
                        fontSize: 35)
                ),
              ),
              Spacer()
        ]),
      ],
      ),
    );
    // body: Center(
  }
}
