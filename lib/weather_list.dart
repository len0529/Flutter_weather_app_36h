import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class WeatherList extends StatefulWidget {
  final List<String> timeRangeList;
  final List<String> parameterNameList;
  final String locationName;

  WeatherList({
    required this.timeRangeList,
    required this.parameterNameList,
    required this.locationName,
  });

  @override
  _WeatherListState createState() => _WeatherListState();
}

class _WeatherListState extends State<WeatherList> {
  int selectedPaddingIndex = 0; // 初始選擇第一組 Padding

  static const TextStyle _textStyle = TextStyle(
    color: Colors.white,
    fontSize: 18,
  );

  static const TextStyle _bigTitle = TextStyle(
    color: Colors.white,
    fontSize: 40,
  );

  @override
  Widget build(BuildContext context) {
    if (widget.timeRangeList.isEmpty || widget.parameterNameList.isEmpty) {
      // 如果 WeatherList 為空，返回一個空的 Container 作為替代
      return Container();
    }
    return SingleChildScrollView(
      child: Column(
        children: [
          ToggleButtons(
            isSelected: [0, 1, 2].map((index) => selectedPaddingIndex == index).toList(),
            onPressed: (index) {
              setState(() {
                selectedPaddingIndex = index;
              });
            },
            borderRadius: BorderRadius.circular(15),
            fillColor: Colors.blue,
            children: [
              "Now",
              "+12",
              "+24"
            ].map((label) => Text(
              label,
              style: GoogleFonts.montserrat(color: Colors.white),
            )).toList(),
          ),
          _buildWeatherDetails(),
        ],
      ),
    );
  }

  Widget _buildWeatherDetails() {
    final parameterStartIndex = selectedPaddingIndex + 3;
    final rainIndex = parameterStartIndex + 9;
    final comfortIndex = parameterStartIndex + 6;

    return Column(
      children: [
        Container(
          width: MediaQuery.of(context).size.width * 7 / 8,
          alignment: Alignment.centerLeft,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.locationName,
                style: _bigTitle,
              ),
              Padding(
                padding: EdgeInsets.only(left: 5.0),
                child: Text(
                  widget.timeRangeList[selectedPaddingIndex],
                  style: GoogleFonts.montserrat(
                    textStyle: Theme.of(context).textTheme.displayLarge,
                    fontSize: 15,
                    color: Colors.white,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 350),
        Container(
          width: MediaQuery.of(context).size.width * 7 / 8,
          alignment: Alignment.centerLeft,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${widget.parameterNameList[parameterStartIndex + 3]}~${widget.parameterNameList[parameterStartIndex]}°c',
                style: GoogleFonts.montserrat(
                  textStyle: Theme.of(context).textTheme.displayLarge,
                  fontSize: 68,
                  color: Colors.white,
                  fontWeight: FontWeight.w400,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    widget.parameterNameList[selectedPaddingIndex],
                    style: GoogleFonts.notoSans(
                      textStyle: Theme.of(context).textTheme.displayLarge,
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Column(
                children: [
                  Row(
                    children: [
                      _buildWeatherDetailIcon("assets/rain.png", widget.parameterNameList[rainIndex] + '%'),
                      _buildWeatherDetailIcon("assets/comfortable.png", widget.parameterNameList[comfortIndex]),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildWeatherDetailIcon(String assetPath, String text) {
    return Row(
      children: [
        Image.asset(
          assetPath,
          width: 28,
          height: 28,
        ),
        SizedBox(width: 7),
        Text(
          text,
          style: GoogleFonts.montserrat(
            textStyle: Theme.of(context).textTheme.displayLarge,
            fontSize: 20,
            color: Colors.white,
            fontWeight: FontWeight.w400,
          ),
        ),
        SizedBox(width: 15),
      ],
    );
  }
}
