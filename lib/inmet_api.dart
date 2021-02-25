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

  String _baseUrl = 'https://8w93l0f9mc.execute-api.us-east-1.amazonaws.com/default/API-REST-INMET';

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

      print(citiesMap[i]);

      if(citiesMap[i]["TEM_MIN"] != null)
        tempMin = double.parse(citiesMap[i]["TEM_MIN"]);
      else
        tempMin = 0;

      if(citiesMap[i]["TEM_MAX"] != null)
        tempMax = double.parse(citiesMap[i]["TEM_MAX"]);
      else
        tempMax = 0;

      if(citiesMap[i]["TEM_INS"] != null)
        temp = double.parse(citiesMap[i]["TEM_INS"]);
      else
        temp = 0;

      if(citiesMap[i]["UMD_INS"] != null)
        humidity = double.parse(citiesMap[i]["UMD_INS"]);
      else
        humidity = 0;

      var infosList = [cityName, temp, tempMin, tempMax, humidity];
      print(infosList);
      storage.setItem("city",infosList);

      break;
    }
  }

  if(found == false)
    storage.setItem("city",null);
}