// weather_state.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weather_app_36h/client.dart';
import 'package:weather_app_36h/model.dart';

final weatherProvider = StateNotifierProvider<WeatherState, WeatherForecast?>((ref) => WeatherState());

class WeatherState extends StateNotifier<WeatherForecast?> {
  WeatherState() : super(null);

  String searchText = '';
  List<String> timeRangeList = [];
  List<String> parameterNameList = [];
  String error = '';
  bool isSearched = false;

  Future<void> fetchWeather(String searchText) async {
    try {
      final newWeather = await WeatherApiClient().request();
      List<TimeData> timeDataList = newWeather.getWeatherDataByLocation(searchText);
      timeRangeList = timeDataList.map((data) {
        //整理天氣格式
        var timeStart = data.startTime.split("T")[0].substring(5, ) + " " + data.startTime.split("T")[1].substring(0, 5);
        var timeEnd = data.endTime.split("T")[0].substring(5, ) + " " + data.endTime.split("T")[1].substring(0, 5);
        return '$timeStart - $timeEnd';
      }).toList();
      parameterNameList = timeDataList.map((data) => data.parameterName).toList();
      state = newWeather;
    } catch (e) {
      // 處理錯誤
      error = '獲取天氣資料時出現錯誤：$e';
    }
  }
}

final performSearchProvider = FutureProvider.autoDispose.family<WeatherForecast?, String>((ref, searchText) async {
  if (searchText.isEmpty) {
    // 如果搜尋框為空，則不搜尋
    return Future.value(null);
  }
  try {
    ref.read(weatherProvider.notifier).searchText = searchText;
    await ref.read(weatherProvider.notifier).fetchWeather(searchText);
    return ref.watch(weatherProvider);
  } catch (e) {
    // 處理錯誤
    ref.read(weatherProvider.notifier).error = '獲取天氣資料時出現錯誤：$e';
    return null;
  }
});
