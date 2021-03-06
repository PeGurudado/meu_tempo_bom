import 'package:flutter/material.dart';
import 'package:flutter_weather/main.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_weather/alertRegister.dart';
import 'package:flutter_weather/weather/weather.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pedantic/pedantic.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AlertsPage extends StatefulWidget {
  AlertsPage._({Key key}) : super(key: key);

  static Route<String> route() {
    return MaterialPageRoute(builder: (_) => AlertsPage._());
  }

  @override
  State<AlertsPage> createState() => _AlertsPageState();
}

List<dynamic> dadosCity = [];

class _AlertsPageState extends State<AlertsPage> {
  void SetAlertIndex() async {
    var citiesRef = await FirebaseFirestore.instance
        .collection((storage.getItem("city")[0] as String));

    int i = 0;
    while (i < 100) {
      i++;
      var res = await citiesRef.doc("Aviso${i}").get();
      print(res.data());
      print(i);
      if (res.data() == null) {
        storage.setItem(
            ("${(storage.getItem("city")[0] as String)}alertN"), i - 1);
        print(i);
        break;
      }
    }
  }

  void AlertsFromCity() async {
    var citiesRef = await FirebaseFirestore.instance
        .collection((storage.getItem("city")[0] as String));
    List<dynamic> dadosCityAlt = [];
    for (int i = 1;
        i <=
            (storage.getItem("${(storage.getItem("city")[0] as String)}alertN")
                as num);
        i++) {
      List<dynamic> listin = [];
      var res = await citiesRef.doc("Aviso${i}").get();
      listin.add(res.data()["Tipo"]);
      listin.add(res.data()["Localizacao"]);
      try {
        listin.add(res.data()["Descricao"]);
      } catch (RangeError) {
        listin.add("Sem descricao");
      }

      dadosCityAlt.add(listin);
    }
    dadosCity = dadosCityAlt;
    // print(dadosCity);
  }

  @override
  Widget build(BuildContext context) {
    SetAlertIndex();
    AlertsFromCity();
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
      body: ListView(children: <Widget>[
        Text(
          'ALERTAS DE ' + (storage.getItem("city")[0] as String),
          textAlign: TextAlign.center,
          style: TextStyle(
            height: 2,
            color: Colors.red,
            fontSize: 40,
          ),
        ),
        Text(
            '__________________________________________________________________________'),
        FlatButton(
          child: const Text("Recarregar",
              textScaleFactor: 2,
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red)),
          height: 70,
          minWidth: MediaQuery.of(context).size.width - 32,
          onPressed: () async {
            AlertsFromCity();
            Navigator.of(context).pop((storage.getItem("city")[0] as String));
            final city = await Navigator.of(context).push(AlertsPage.route());
            unawaited(context.read<WeatherCubit>().fetchWeather(city));
          },
        ),
        Container(
          child: Wrap(
            children: [
              if (dadosCity.length == 0)
                (Text(
                  "CARREGANDO DADOS... PORFAVOR RECARREGUE A PAGINA OU INSIRA ALGUM DADO",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    height: 1.5,
                    color: Colors.black,
                    fontSize: 18,
                  ),
                )),
              for (int i = 0; i < dadosCity.length; i++)
                (Text(
                  '\n- Tipo: ${(dadosCity[i][0] as String)} - Localizacao: ${(dadosCity[i][1] as String)} - Descricao: ${(dadosCity[i][2] as String)}',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    height: 1.25,
                    color: Colors.black,
                    fontSize: 23,
                  ),
                )),
            ],
          ),
        ),
        FlatButton(
          child: const Text("Adicionar alerta",
              textScaleFactor: 2,
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red)),
          height: 70,
          minWidth: MediaQuery.of(context).size.width - 32,
          onPressed: () async {
            AlertsFromCity();
            await Navigator.of(context).push(AlertRegister.route());
            unawaited(context
                .read<WeatherCubit>()
                .fetchWeather((storage.getItem("city")[0] as String)));
          },
        ),
      ]),
    );
    // body: Center(
  }
}
