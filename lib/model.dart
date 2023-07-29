class WeatherForecast {
  late String sent;
  late List<LocationData> locations;

  WeatherForecast({
    required this.sent,
    required this.locations,
  });

  factory WeatherForecast.fromJson(Map<String, dynamic> json) {
    final cwbopendata = json['cwbopendata'] ?? {};
    final sent = cwbopendata['sent'] as String? ?? '';

    final locationElements = cwbopendata['dataset']['location'] as List<dynamic>? ?? [];
    final locations = locationElements
        .map<LocationData>((locationElement) => LocationData.fromJson(locationElement))
        .toList();

    return WeatherForecast(sent: sent, locations: locations);
  }

  List<TimeData> getWeatherDataByLocation(String locationName) {
    final location = locations.firstWhere(
          (location) => location.locationName == locationName,
      orElse: () => LocationData(locationName: '', elements: []), // Return an empty LocationData if not found
    );

    return location.elements.expand((element) => element.times).toList();
  }

}

class LocationData {
  late String locationName;
  late List<ElementData> elements;

  LocationData({
    this.locationName = '',
    this.elements = const [],
  });

  factory LocationData.fromJson(Map<String, dynamic> json) {
    final locationName = json['locationName'] as String? ?? '';
    final weatherElements = json['weatherElement'] as List<dynamic>? ?? [];
    final elements = weatherElements
        .map<ElementData>((element) => ElementData.fromJson(element))
        .toList();

    return LocationData(locationName: locationName, elements: elements);
  }
}

class ElementData {
  late String elementName;
  late List<TimeData> times;

  ElementData({
    this.elementName = '',
    this.times = const [],
  });

  factory ElementData.fromJson(Map<String, dynamic> json) {
    final elementName = json['elementName'] as String? ?? '';
    final timeElements = json['time'] as List<dynamic>? ?? [];
    final times = timeElements.map<TimeData>((time) => TimeData.fromJson(time)).toList();

    return ElementData(elementName: elementName, times: times);
  }
}

class TimeData {
  late String startTime;
  late String endTime;
  late String parameterName;
  late String parameterValue;

  TimeData({
    this.startTime = '',
    this.endTime = '',
    this.parameterName = '',
    this.parameterValue = '',
  });

  factory TimeData.fromJson(Map<String, dynamic> json) {
    final startTime = json['startTime'] as String? ?? '';
    final endTime = json['endTime'] as String? ?? '';
    final parameter = json['parameter'] as Map<String, dynamic>? ?? {};
    final parameterName = parameter['parameterName'] as String? ?? '';
    final parameterValue = parameter['parameterValue'] as String? ?? '';
    final parameterUnit = parameter['parameterUnit'] as String? ?? '';
    final formattedParameterValue = parameterUnit.isNotEmpty ? '$parameterValue $parameterUnit' : parameterValue;

    return TimeData(
      startTime: startTime,
      endTime: endTime,
      parameterName: parameterName,
      parameterValue: formattedParameterValue,
    );
  }
}
