import 'package:flutter/material.dart';
import 'package:flutter_weather/main.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';




class FavPage extends StatefulWidget {
  FavPage._({Key key}) : super(key: key);

  static Route<String> route() {
    return MaterialPageRoute(builder: (_) => FavPage._());
  }

  @override
  State<FavPage> createState() => _FavPageState();
}

class _FavPageState extends State<FavPage> {

  @override
  Widget build(BuildContext context) {

    String favoriteCity = storage.getItem("favorito") as String;
    String favoriteCity2 = storage.getItem("favorito2") as String;
    String favoriteCity3 = storage.getItem("favorito3") as String;
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
          const Text('Favoritos',
            textAlign: TextAlign.center,
            style: TextStyle(
              height: 3.25,
              color: Colors.black,
              fontSize: 49,
            ),
          ),
          Row(
            children: [
              Spacer(),
              if(favoriteCity != null)
              (
                FlatButton(
                  onPressed: () => {
                    Navigator.of(context).pop(favoriteCity),
                    Navigator.of(context).pop(favoriteCity),
                  },
                  child: Text( favoriteCity,
                      textAlign: TextAlign.center, style: TextStyle(
                        height: 2.5,
                        color: Colors.amber,
                        fontWeight: FontWeight.bold,
                        fontSize: 35)
                  ),
                )
              ),
              Spacer()
          ]),
          Row(
            children: [
              Spacer(),
              if(favoriteCity2 != null)
              (
                FlatButton(
                  onPressed: () => {
                    Navigator.of(context).pop(favoriteCity2),
                    Navigator.of(context).pop(favoriteCity2),
                  },
                child: Text( favoriteCity2,
                  textAlign: TextAlign.center, style: TextStyle(
                  height: 2.5,
                  color: Colors.amber,
                  fontWeight: FontWeight.bold,
                  fontSize: 35)
                ),
               )
              ),
              Spacer()
          ]),
              Row(
                children: [
              Spacer(),
              if(favoriteCity3 != null)
              (
                FlatButton(
                  onPressed: () => {
                    Navigator.of(context).pop(favoriteCity3),
                    Navigator.of(context).pop(favoriteCity3),
                  },
                  child: Text( favoriteCity3,
                    textAlign: TextAlign.center, style: TextStyle(
                    height: 2.5,
                    color: Colors.amber,
                    fontWeight: FontWeight.bold,
                    fontSize: 35)
                  ),
                )
              ),
              Spacer()
              ]),
            ],
          ),
    );
    // body: Center(
  }
}
