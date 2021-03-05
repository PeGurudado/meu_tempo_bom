import 'package:equatable/equatable.dart';
// import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_weather/app.dart';
import 'package:flutter_weather/weather_bloc_observer.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:weather_repository/weather_repository.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'package:localstorage/localstorage.dart';
// import 'package:firebase/firebase.dart';
// import 'package:firebase/firestore.dart' as fs;

LocalStorage storage;

void main() async {



  // initializeApp(
  //     apiKey: "YourApiKey",
  //     authDomain: "YourAuthDomain",
  //     databaseURL: "YourDatabaseUrl",
  //     projectId: "YourProjectId",
  //     appId: "YourAppId",
  //     storageBucket: "YourStorageBucket");
  //
  // fs.Firestore store = firestore();
  // fs.CollectionReference ref = store.collection('messages');
  //
  // ref.onSnapshot.listen((querySnapshot) {
  //   querySnapshot.docChanges().forEach((change) {
  //     if (change.type == "added") {
  //       // Do something with change.doc
  //     }
  //   });
  // });

  storage = LocalStorage('localstorage_app');
  WidgetsFlutterBinding.ensureInitialized();
  EquatableConfig.stringify = kDebugMode;
  Bloc.observer = WeatherBlocObserver();
  HydratedBloc.storage = await HydratedStorage.build();

  runApp(WeatherApp(weatherRepository: WeatherRepository()));
}



