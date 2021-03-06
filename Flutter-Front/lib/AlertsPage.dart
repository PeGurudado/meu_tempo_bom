import 'package:flutter/material.dart';
import 'package:flutter_weather/main.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_weather/alertRegister.dart';
import 'package:flutter_weather/weather/weather.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pedantic/pedantic.dart';




class AlertsPage extends StatefulWidget {
  AlertsPage._({Key key}) : super(key: key);

  static Route<String> route() {
    return MaterialPageRoute(builder: (_) => AlertsPage._());
  }

  @override
  State<AlertsPage> createState() => _AlertsPageState();


}



class _AlertsPageState extends State<AlertsPage> {


  // CollectionReference alerts
  //         = FirebaseFirestore.instance.collection('professores');
  // void SaveFirebase() async {
  // await FirebaseFirestore.instance.collection('Recife').doc('Aviso0')
  //     .set({"Tipo": "Desabamento", "Localizacao": "Rua quatro queijos macaricados"} as Map<String,dynamic>);
  // }

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

      body:  Column(children: <Widget>[
        Text('ALERTAS DE '+(storage.getItem("city")[0] as String),
          textAlign: TextAlign.center,
          style: TextStyle(
            height: 2,
            color: Colors.red,
            fontSize: 40,
          ),
        ),
        Text('__________________________________________________________________________'),
        Container(
            child: Wrap(
              children: [
                Text('- '+'QUEIMADAS'+' - '+
                    'Caiu um raio na arvore aqui da praca Kaki',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    height: 1.5,
                    color: Colors.black,
                    fontSize: 20,
                  ),
                ),
                Text('__________________________________________________________________________'),
              ],
            ),
        ),
        Container(
          child: Wrap(
            children: [
              Text('- '+'TERREMOTO'+' - '+
                  'Terremoto de magnitude 6, deve chegar agora de noite',
                textAlign: TextAlign.center,
                style: TextStyle(
                  height: 1.5,
                  color: Colors.black,
                  fontSize: 20,
                ),
              ),
              Text('__________________________________________________________________________'),
            ],
          ),
        ),
        Container(
          child: Wrap(
            children: [
              Text('- '+'HOMICÍDIO'+' - '+
                  'Assasino do sino atacou um cachorro aqui na avenida magalhoes',
                textAlign: TextAlign.center,
                style: TextStyle(
                  height: 1.5,
                  color: Colors.black,
                  fontSize: 20,
                ),
              ),
              Text('__________________________________________________________________________'),
            ],
          ),
        ),
        Container(
          child: Wrap(
            children: [
              Text('- '+'QUEIMADAS'+' - '+
                  'Caiu um raio na arvore aqui da praca Kaki',
                textAlign: TextAlign.center,
                style: TextStyle(
                  height: 1.5,
                  color: Colors.black,
                  fontSize: 20,
                ),
              ),
              Text('__________________________________________________________________________'),
            ],
          ),
        ),
        Container(
          child: Wrap(
            children: [
              Text('- '+'DESABAMENTO'+' - '+
                  'Um predio desabou aqui na Rua colve-flor',
                textAlign: TextAlign.center,
                style: TextStyle(
                  height: 1.5,
                  color: Colors.black,
                  fontSize: 20,
                ),
              ),
              Text('__________________________________________________________________________'),
            ],
          ),
        ),
        Container(
          child: Wrap(
            children: [
              Text('- '+'ENCHENTE'+' - '+
                  'Um caminhao bateu na barragem aqui na Rua sexta feira',
                textAlign: TextAlign.center,
                softWrap: true,
                style: TextStyle(
                  height: 1.5,
                  color: Colors.black,
                  fontSize: 20,
                ),
              ),
              Text('__________________________________________________________________________'),
            ],
          ),
          ),
      ]
      ),
      floatingActionButton: FlatButton(
        child: const Text("Adicionar alerta", textScaleFactor: 2,
            style: TextStyle( fontWeight: FontWeight.bold, color: Colors.red)
            ),
        height: 70,
        minWidth: MediaQuery.of(context).size.width - 32,
        onPressed: () async {
          print('Lista de alertas cheia');
          final city = await Navigator.of(context).push(AlertRegister.route());
          unawaited(context.read<WeatherCubit>().fetchWeather(city));
        },
      ),
    );
    // body: Center(
  }
}

