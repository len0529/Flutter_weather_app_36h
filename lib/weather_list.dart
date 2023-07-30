import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:weather_app_36h/transition_animate.dart';
import 'package:flutter/services.dart';

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
  int lastSelectedPaddingIndex = 0;

  static const TextStyle _bigTitle = TextStyle( //縣市標題
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
              HapticFeedback.lightImpact();
              setState(() {
                lastSelectedPaddingIndex = selectedPaddingIndex;  // Update last selected index before changing the current one
                selectedPaddingIndex = index;
              });
            },
            borderRadius: BorderRadius.circular(15),
            fillColor: Colors.lightBlue,
            children: [
              "Now",
              "+12",
              "+24"
            ].map((label) => Text(
              label,
              style: GoogleFonts.montserrat(color: Colors.white),
            )).toList(),
          ),
          Container(  //縣市標題
            width: MediaQuery.of(context).size.width * 7 / 8,
            alignment: Alignment.centerLeft,
            child: Text(
              widget.locationName,
              style: _bigTitle,
            ),
          ),

          AnimatedSwitcher(  //下方轉場動畫
            duration: Duration(milliseconds: 700),
            child: _buildWeatherDetails(),
            transitionBuilder: (Widget child, Animation<double> animation) {
              var begin = selectedPaddingIndex > lastSelectedPaddingIndex ? Offset(2, 0.0) : Offset(-2, 0.0);  //檢查index大小關係
              var end = Offset.zero;
              var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: Curves.ease));

              return MySlideTransition(
                child: child,
                position: tween.animate(animation),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildWeatherDetails() {
    final parameterStartIndex = selectedPaddingIndex + 3;  //依照回傳列表取值
    final rainIndex = parameterStartIndex + 9;
    final comfortIndex = parameterStartIndex + 6;

    return Column(
      key: ValueKey<int>(selectedPaddingIndex), // Add key to ensure new widget is built on toggle switch
      children: [
        Container(
          width: MediaQuery.of(context).size.width * 7 / 8,
          alignment: Alignment.centerLeft,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
        SizedBox(height: 370),
        Container(
          width: MediaQuery.of(context).size.width * 7 / 8,
          alignment: Alignment.centerLeft,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${widget.parameterNameList[parameterStartIndex + 3]}~${widget.parameterNameList[parameterStartIndex]}°c', //氣溫
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
                    widget.parameterNameList[selectedPaddingIndex], //天氣描述
                    style: GoogleFonts.notoSans(
                      textStyle: Theme.of(context).textTheme.displayLarge,
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
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
        SizedBox(width: 18),
      ],
    );
  }
}
