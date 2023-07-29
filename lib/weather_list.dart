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

  static const TextStyle textStyle = TextStyle(
    color: Colors.white,
    fontSize: 18,
  );

  static const TextStyle bigTitle = TextStyle(
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
                style: bigTitle,
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
                widget.parameterNameList[selectedPaddingIndex + 3 + 3] + '~' + widget.parameterNameList[selectedPaddingIndex + 3] + '°c',
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: 1,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Image.asset(
                          "assets/rain.png",
                          width: 28,
                          height: 28,
                        ),
                        Text(
                          widget.parameterNameList[selectedPaddingIndex + 3 + 9]+'%',
                          style: GoogleFonts.montserrat(
                            textStyle: Theme.of(context).textTheme.displayLarge,
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Image.asset(
                          "assets/comfortable.png",
                          width: 25,
                          height: 25,
                        ),
                        SizedBox(width: 7),
                        Text(
                          widget.parameterNameList[selectedPaddingIndex + 3 + 6],
                          style: textStyle,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
