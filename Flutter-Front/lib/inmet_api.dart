import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:localstorage/localstorage.dart';
import 'package:flutter_weather/main.dart';
import 'package:requests/requests.dart';


Future<List<dynamic>> inmetGetInfos(String name) async
{
  // final String postsURL = "https://thingsboard.cloud/api/v1/v3krhovXisGUkHiXHhmf";
  //
  // Future<List<Post>> getPosts() async {
  //   Response res = await get(postsURL);
  //
  //   if (res.statusCode == 200) {
  //     List<dynamic> body = jsonDecode(res.body);
  //   }}}
  //   /////////////////////////////////////////////////////////


//
  String cityName;
  double tempMin, tempMax, temp, humidity, radiation, wind, heatIndex;
  String data;
  int hora;

  String desiredCity = name.toUpperCase();

  String _baseUrl = 'https://8w93l0f9mc.execute-api.us-east-1.amazonaws.com/default/API-REST-INMET';
//
//___________________

  String URL = 'https://thingsboard.cloud/api/v1/v3krhovXisGUkHiXHhmf';
  // print('https://thingsboard.cloud/api/v1/v3krhovXisGUkHiXHhmf/attributes?clientKeys=${cityName.toString()}&sharedKeys=shared1');
// //def getRecords( nomeCidade):
// //     return req('GET', URL + "/attributes?clientKeys="+nomeCidade+"&sharedKeys=shared1").read()
//
//   print(URL+"/attributes?clientKeys="+cityName+"&sharedKeys=shared1");
  var r = await Requests.get("${URL.toString()}/attributes?clientKeys=${desiredCity.toString()}&sharedKeys=shared1");
  r.raiseForStatus();
  String body = r.content();

  var keydict= json.decode(body)['client'];
  if (keydict == null)
      storage.setItem("city",null);
  else{

    var listCity= keydict[desiredCity];

    print(listCity);
      cityName = desiredCity as String;



      if(listCity[3] != null)
        tempMin = listCity[3];
      else
        tempMin = 0;

      if(listCity[4]  != null)
        tempMax = listCity[4];
      else
        tempMax = 0;

      if(listCity[0] != null)
        temp = ((listCity[0] -32) * 5/9);
      else
        temp = 0;

      if(listCity[1]  != null)
        humidity = listCity[1];
      else
        humidity = 0;

      if(listCity[2]  != null)
        heatIndex = listCity[2];
      else
        heatIndex = 0;

      if(listCity[5] != null)
        radiation = double.parse(listCity[5].toString()) ;

      else
        radiation = 0;

      if(listCity[6] != null)
        wind = listCity[6];
      else
        wind = 0;

      if (listCity[7] != null)
        data= listCity[7];
      else
        data='Indefinido';

  if (listCity[8] != null)
    hora= listCity[8];
  else
    hora=0;

      var infosList = [cityName, temp, tempMin, tempMax, humidity, radiation, wind, data, hora, heatIndex];
      storage.setItem("city",infosList);

  }
}

