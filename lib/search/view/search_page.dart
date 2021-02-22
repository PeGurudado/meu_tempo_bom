import 'package:flutter/material.dart';
import 'package:flutter_weather/main.dart';

class SearchPage extends StatefulWidget {
  SearchPage._({Key key}) : super(key: key);

  static Route<String> route() {
    return MaterialPageRoute(builder: (_) => SearchPage._());
  }

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _textController = TextEditingController();

  String get _text => _textController.text;
  List<String> strArr = [ null, null, null, null, null];
  List<dynamic> ult;


  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    ult = storage.getItem("ultimos") as List<dynamic>;

    if( ult == null )
      storage.setItem("ultimos", strArr);
    else {
      for(var i = 0 ; i < 5 ; i++)
      (
        strArr[i] = ult[i] as String
      );
    }

    String favoriteCity = storage.getItem("favorito") as String;
    return Scaffold(
      appBar: AppBar(title: const Text('Procurar Cidade', style: TextStyle(fontSize: 25),),),
      body:  Column(children: <Widget>[
        Row(
          children: [
            Spacer(),
            const Text(
              'Favorito: ',
              textAlign: TextAlign.center,
              style: TextStyle(
                height: 2,
                color: Colors.black,
                fontSize: 29,
              ),
            ),
            if(favoriteCity != null)
              (
                  FlatButton(
                    onPressed: () => {
                      Navigator.of(context).pop( favoriteCity )},
                    child: Text( favoriteCity,
                        textAlign: TextAlign.center, style: TextStyle(
                          height: 2,
                          color: Colors.black,
                          fontSize: 29,
                        )),
                  )
              ),
            Spacer(),
          ],
        ),
          Row(
          children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    style: TextStyle(color: Colors.black, fontSize: 25),
                  controller: _textController,
                  decoration: const InputDecoration(
                    labelStyle: TextStyle(
                        color: Colors.black,
                        fontSize: 25),
                    labelText: 'Cidade',
                    hintText: 'Recife',
                    hintStyle: TextStyle(
                        color: Colors.grey,
                        fontSize: 25),
                ),
                ),
              ),
            ),
            IconButton(
              key: const Key('searchPage_search_iconButton'),
              icon: const Icon(Icons.search, size:35),
              onPressed: () => {
                    strArr.insert( strArr.length , _text),
                    strArr.removeAt(0),
                    print(storage.getItem("ultimos")),
                    storage.setItem("ultimos",strArr),
                    print(storage.getItem("ultimos")[4]),
                    Navigator.of(context).pop(_text) }

            ),
          ],
          ),

        //Espaco entre rows
        Text(
          "",
          style: TextStyle(
            fontSize: 25,
          ),
        ),
        //Espaco entre rows

          Text(
          "Buscas recentes: ",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black,
              fontSize: 25,
            ),
          ),
          Expanded(
            child: ListView (
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if(strArr[4] != null)
              (
                FlatButton(
                  onPressed: () => Navigator.of(context).pop( strArr[4]),
                  child: Text( strArr[4],
                      textAlign: TextAlign.center, textScaleFactor: 1.6),)
              ),
              if(strArr[3] != null)
              (
                FlatButton(
                  onPressed: () => Navigator.of(context).pop( strArr[3]),
                  child: Text(  strArr[3],
                      textAlign: TextAlign.center, textScaleFactor: 1.6),
                )
              ),
              if(strArr[2] != null)
              (
                FlatButton(
                  onPressed: () => Navigator.of(context).pop( strArr[2]),
                  child: Text( strArr[2],
                      textAlign: TextAlign.center, textScaleFactor: 1.6),
                )
              ),
            if(strArr[1] != null)
            (
              FlatButton(
                onPressed: () => Navigator.of(context).pop( strArr[1]),
                child: Text( strArr[1],
                    textAlign: TextAlign.center, textScaleFactor: 1.6),
              )
            ),
            if(strArr[0] != null)
            (
              FlatButton(
                onPressed: () => Navigator.of(context).pop( strArr[0]),
                child: Text( strArr[0],
                    textAlign: TextAlign.center, textScaleFactor: 1.6),
              )
            ),
            ],
          ),
          ),
      ],
    ),
    );
  }
}
