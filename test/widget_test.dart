import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:weather_app_36h/weather_app.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


void main() {
  testWidgets('Shows an error message when the search text is empty', (WidgetTester tester) async {
    // Build the WeatherApp widget.
    await tester.pumpWidget(ProviderScope(child: MaterialApp(home: WeatherApp())));


    // Find the search button.
    final searchButton = find.byIcon(Icons.search);

    // Tap on the search button.
    await tester.tap(searchButton);

    // Trigger a frame.
    await tester.pump();

    // Check if the error snackbar is shown with the correct text.
    expect(find.text('請輸入欲查詢地點'), findsOneWidget);
  });
}
