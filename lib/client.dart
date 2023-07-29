import 'dart:convert';
import 'package:dio/dio.dart';
import 'model.dart';

class WeatherApiClient {
  Future<WeatherForecast> request() async {
    String url =
        "https://opendata.cwb.gov.tw/fileapi/v1/opendataapi/F-C0032-001?Authorization=CWB-C37EF32D-4C6F-4D8E-9EB1-3C6CF6A25627&format=JSON";
    try {
      Response response = await Dio().get(url);
      final parsedData = jsonDecode(response.toString());
      final weather = WeatherForecast.fromJson(parsedData);
      return weather;
    } catch (e) {
      throw Exception('獲取天氣資料時出現錯誤：$e');
    }
  }
}
