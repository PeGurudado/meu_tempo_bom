// import 'dart:html';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_weather/main.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_weather/AlertsPage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AlertRegister extends StatefulWidget {
  AlertRegister._({Key key}) : super(key: key);



  static Route<String> route() {
    return MaterialPageRoute(builder: (_) => AlertRegister._());
  }

  @override
  State<AlertRegister> createState() => _AlertRegisterState();

}

class _AlertRegisterState extends State<AlertRegister> {

  final TextEditingController _textController = TextEditingController();
  final TextEditingController _textControllerB = TextEditingController();
  final TextEditingController _textControllerC = TextEditingController();

  String get _text => _textController.text;
  String get _textB => _textControllerB.text;
  String get _textC => _textControllerB.text;

  File imageFile;

  @override
  void dispose() {
    _textController.dispose();
    _textControllerB.dispose();
    _textControllerC.dispose();
    super.dispose();
  }

  // void _ImgFromCamera() async {
  //   File _image = await ImagePicker.pickImage(
  //       source: ImageSource.camera, //imageQuality: 50
  //   );
  //   SetState(() {
  //     _image = image;
  //   });
  // }

  void _getFromCamera() async {
    PickedFile pickedFile = await ImagePicker().getImage(
      source: ImageSource.camera,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    if(pickedFile != null){
      setState(() {
        imageFile = File(pickedFile.path);
      });
    }
  }

  void _getFromGallery() async {
    PickedFile pickedFile = await ImagePicker().getImage(
    source: ImageSource.gallery,
    maxWidth: 1800,
    maxHeight: 1800,
  );
    if(pickedFile != null){
      setState(() {
        imageFile = File(pickedFile.path);
      });
    }
  }

  // CollectionReference alerts
  //         = FirebaseFirestore.instance.collection('professores');
  // void SaveFirebase() async {



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

        body: ListView(children: <Widget>[
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
                        labelText: 'Tipo de desastre',
                        hintText: 'Queimada, Enchente, Desabamento etc',
                        hintStyle: TextStyle(
                            color: Colors.grey,
                            fontSize: 25),
                      ),
                    ),
                ),
             ),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  style: TextStyle(color: Colors.black, fontSize: 25),
                  controller: _textControllerB,
                  decoration: const InputDecoration(
                    labelStyle: TextStyle(
                        color: Colors.black,
                        fontSize: 25),
                    labelText: 'Local do desastre',
                    hintText: 'Região, Bairro, Rua etc',
                    hintStyle: TextStyle(
                        color: Colors.grey,
                        fontSize: 25),
                  ),
                ),
              ),
            ),
          ],
        ),
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    style: TextStyle(color: Colors.black, fontSize: 25),
                    controller: _textControllerC,
                    decoration: const InputDecoration(
                      labelStyle: TextStyle(
                          color: Colors.black,
                          fontSize: 25),
                      labelText: 'Descricao do desastre',
                      hintText: 'Aconteceu da seguinte forma...',
                      hintStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: 25),
                    ),
                  ),
                ),
              ),
            ],
          ),
        Row(
            children: [
              Spacer(),
              FlatButton(
                child: const Text("🖼️", textScaleFactor: 5.75),
                height:80,
                minWidth: MediaQuery.of(context).size.width - 242,
                onPressed: () {
                  _getFromGallery();
                },
              ),
              FlatButton(
                child: const Text("📷", textScaleFactor: 5.75),
                height:80,
                minWidth: MediaQuery.of(context).size.width - 242,
                onPressed: () {
                  _getFromCamera();
                },
              ),
              Spacer(),
          ]
        ),
        FlatButton(
          child: const Text("Cadastrar", textScaleFactor: 1.75),
          height:80,
          minWidth: MediaQuery.of(context).size.width - 32,
          onPressed: () async {
              // print(_text);
              if(storage.getItem("${(storage.getItem("city")[0] as String)}alertN") != null)
                storage.setItem("${(storage.getItem("city")[0] as String)}alertN",storage.getItem("${(storage.getItem("city")[0] as String)}alertN")+1);
              else
                storage.setItem(("${(storage.getItem("city")[0] as String)}alertN"), 1);

              if(_text == "")
                _text.replaceAll("", "Indefinido");

              if(_textB == "")
                _textB.replaceAll("", "Indefinida");

              if(_textC == "")
                _textC.replaceAll("", "Indefinida");

              await FirebaseFirestore.instance.collection((storage.getItem("city")[0] as String)).doc('Aviso${storage.getItem(("${(storage.getItem("city")[0] as String)}alertN"))}')
                  .set({"Tipo": _text, "Localizacao": _textB, "Descricao" : _textC} as Map<String,dynamic>);
              Navigator.of(context).pop(storage.getItem("city")[0]);
              Navigator.of(context).pop(storage.getItem("city")[0]);
          },
        ),
      ],
      ),
      );
    }
}