import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:localstorage/localstorage.dart';
import 'package:flutter_weather/main.dart';


Future<List<dynamic>> inmetGetInfos(String name) async
{
  String cityName;
  double tempMin, tempMax, temp, humidity;

  String desiredCity = name.toUpperCase();

  String _baseUrl = 'https://jdc9tuwgp6.execute-api.us-east-1.amazonaws.com/a/API-REST-INMET';

  var client = new http.Client();
  var lista = await client.read(_baseUrl);
  var citiesMap = json.decode(lista) as List<dynamic>;


  bool found = false;
  for(int i = 0; i < citiesMap.length; i++)
  {
    if(citiesMap[i]["DC_NOME"] == desiredCity)
    {
      found = true;

      cityName = citiesMap[i]["DC_NOME"] as String;

      tempMin = double.parse(citiesMap[i]["TEM_MIN"]);
      tempMax = double.parse(citiesMap[i]["TEM_MAX"]);
      temp = double.parse(citiesMap[i]["TEM_INS"]);

      humidity = double.parse(citiesMap[i]["UMD_INS"]);

      var infosList = [cityName, temp, tempMin, tempMax, humidity];
      print(infosList);
      storage.setItem("city",infosList);

      break;
    }
  }

  if(found == false)
    storage.setItem('city', null);

}