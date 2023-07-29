class WeatherForecast {
  String sent;
  List<LocationData> locations;

  WeatherForecast({
    required this.sent,
    required this.locations,
  });

  factory WeatherForecast.fromJson(Map<String, dynamic> json) {
    String sent = json['cwbopendata']['sent'] ?? '';

    List<LocationData> locations = [];
    var locationElements = json['cwbopendata']['dataset']['location'];
    for (var locationElement in locationElements) {
      String locationName = locationElement['locationName'] ?? '';
      List<ElementData> elements = [];
      for (var element in locationElement['weatherElement'] ?? []) {
        String elementName = element['elementName'] ?? '';
        List<TimeData> times = [];
        for (var time in element['time'] ?? []) {
          String startTime = time['startTime'] ?? '';
          String endTime = time['endTime'] ?? '';
          String parameterName = time['parameter']['parameterName'] ?? '';
          String parameterValue = time['parameter']['parameterValue'] ?? '';
          // Check if 'parameterUnit' exists, if yes, append it to 'parameterValue'
          String parameterUnit = time['parameter']['parameterUnit'] ?? '';
          if (parameterUnit.isNotEmpty) {
            parameterValue += ' $parameterUnit';
          }
          times.add(TimeData(
            startTime: startTime,
            endTime: endTime,
            parameterName: parameterName,
            parameterValue: parameterValue,
          ));
        }
        elements.add(ElementData(elementName: elementName, times: times));
      }
      locations.add(LocationData(locationName: locationName, elements: elements));
    }

    return WeatherForecast(sent: sent, locations: locations);
  }
  List<TimeData> getWeatherDataByLocation(String locationName) {
    List<TimeData> result = [];
    for (var location in locations) {
      if (location.locationName == locationName) {
        for (var element in location.elements) {
          result.addAll(element.times);
        }
        break;
      }
    }
    return result;
  }
}

class LocationData {
  String locationName;
  List<ElementData> elements;

  LocationData({
    required this.locationName,
    required this.elements,
  });
}

class ElementData {
  String elementName;
  List<TimeData> times;

  ElementData({
    required this.elementName,
    required this.times,
  });
}

class TimeData {
  String startTime;
  String endTime;
  String parameterName;
  String parameterValue;

  TimeData({
    required this.startTime,
    required this.endTime,
    required this.parameterName,
    required this.parameterValue,
  });
}
