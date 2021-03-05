import 'package:flutter/material.dart';
import 'package:flutter_weather/main.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';




class HistPage extends StatefulWidget {
  HistPage._({Key key}) : super(key: key);

  static Route<String> route() {
    return MaterialPageRoute(builder: (_) => HistPage._());
  }

  @override
  State<HistPage> createState() => _HistPageState();
}

class _HistPageState extends State<HistPage> {

  List<int> nums = [];
  Map<String,dynamic> hist;
  List<dynamic> timeHist;

  @override
  Widget build(BuildContext context) {

    if(storage.getItem("historico") != null && storage.getItem("historico")
    [(storage.getItem("city")[0] as String)] != null)
      nums = List<int>.generate(storage.getItem("historico")
      [(storage.getItem("city")[0] as String)].length as int,
              (int index) => index);

    if(nums == null)
      nums = [];

    if(storage.getItem("historico") != null)
      hist = storage.getItem("historico") as Map<String,dynamic> ;
    else
      hist = {};

    timeHist = hist[(storage.getItem("city")[0] as String)] as List<dynamic>;


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
      body:  ListView(children: <Widget>[
        Text('HISTÓRICO DE '+ (storage.getItem("city")[0] as String),
          textAlign: TextAlign.center,
          style: TextStyle(
            height: 2.25,
            color: Colors.black,
            fontSize: 39,
          ),
        ),

        if(nums.length == 0)
          Text("Historico vazio!",
            textAlign: TextAlign.center,
            style: TextStyle(
              height: 3.25,
              color: Colors.red,
              fontWeight: FontWeight.bold,
              fontSize: 39,
            ),
          ),
        for( int i = nums.length - 1;i >= 0; i--)
        (
          Container(
            child: Wrap(
              children: [
                // Spacer(),
                Text(( "Data: "+timeHist[i][7]+", Hora: "+((timeHist[i][8]/100)-2).toString()+
                    ", Temperatura: "+timeHist[i][0].toString()+", Temperatura min. : "+
                    timeHist[i][3].toString()+", Temperatura max. : "+
                    timeHist[i][4].toString()+", Umidade: "+
                timeHist[i][1].toString()+", Heat Index: "+
                    timeHist[i][2].toString()+ "\n"),
                  textAlign: TextAlign.center,

                  style: TextStyle(
                    height: 1,
                    color: Colors.black,
                    fontSize: 24,
                  ),
                ),
                // Spacer()
              ]
            )
          )
        ),
      ],
      ),
    );
    // body: Center(
  }
}
