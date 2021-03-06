import 'package:equatable/equatable.dart';
// import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_weather/app.dart';
import 'package:flutter_weather/weather_bloc_observer.dart';
import 'package:flutter_weather/weather/widgets/widgets.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:weather_repository/weather_repository.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:localstorage/localstorage.dart';


LocalStorage storage;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final FirebaseApp _initialization = await Firebase.initializeApp();

  storage = LocalStorage('localstorage_app');
  HydratedBloc.storage = await HydratedStorage.build();
  EquatableConfig.stringify = kDebugMode;
  Bloc.observer = WeatherBlocObserver();

  await FirebaseFirestore.instance.collection('Recife').doc('Aviso0')
      .set({"Tipo": "Desabamento", "Localizacao": "Rua quatro queijos macaricados"} as Map<String,dynamic>);

  runApp(WeatherApp(weatherRepository: WeatherRepository()));
}



