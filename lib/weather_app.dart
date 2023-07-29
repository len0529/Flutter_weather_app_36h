import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weather_app_36h/weather_list.dart';
import 'package:weather_app_36h/weather_state.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class WeatherApp extends ConsumerWidget {
  WeatherApp({Key? key}) : super(key: key);

  final searchController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/background_image2.jpg"),
              fit: BoxFit.cover,
            ),
          ),
          child: Center(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(30),
                  child: Row(
                    children: [
                      //輸入框 & 搜尋
                      Expanded(
                        child: TextField(
                          controller: searchController,
                          style: const TextStyle(color: Colors.white),
                          decoration: const InputDecoration(
                            hintText: "請輸入地點",
                            hintStyle: TextStyle(color: Colors.grey),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                          ),
                          onSubmitted: (_) {
                            FocusScope.of(context).unfocus();
                          },
                        ),
                      ),
                      SizedBox.fromSize(
                        size: const Size(50, 50),
                        child: ClipOval(
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              splashColor: Colors.grey,
                              onTap: () {
                                FocusScope.of(context).unfocus();
                                //檢查是否非空
                                if (searchController.text.isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text("請輸入欲查詢地點"),
                                      duration: Duration(seconds: 4),
                                    ),
                                  );
                                } else {
                                  ref.read(weatherProvider.notifier).isSearched = true;
                                  ref.read(weatherProvider.notifier).searchText = searchController.text;
                                }
                              },
                              child: const Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Icon(
                                    Icons.search,
                                    size: 40,
                                    color: Colors.white,
                                  ), // <-- Icon
                                ],
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                ref.watch(performSearchProvider(searchController.text)).when(
                  data: (weather) {
                    //初始狀態
                    if(ref.read(weatherProvider.notifier).timeRangeList.isEmpty &&
                        !ref.read(weatherProvider.notifier).isSearched){
                      return Container(
                        width: MediaQuery.of(context).size.width,
                        height: 600, // 添加高度参数
                        alignment: Alignment.center,
                        child: const Text(
                          "歡迎",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 50,),
                        ),
                      );
                    }
                    else if(ref.read(weatherProvider.notifier).timeRangeList.isEmpty &&
                        ref.read(weatherProvider.notifier).isSearched){
                      return Container(
                        width: MediaQuery.of(context).size.width,
                        height: 600, // 添加高度参数
                        alignment: Alignment.center,
                        child: const Text(
                          "查無此地點，請檢查輸入內容",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 25,),
                        ),
                      );
                    }
                    else {
                      return Expanded(
                        child: WeatherList(
                          timeRangeList: ref.read(weatherProvider.notifier).timeRangeList,
                          parameterNameList: ref.read(weatherProvider.notifier).parameterNameList,
                          locationName: ref.read(weatherProvider.notifier).searchText,
                        ),
                      );
                    }
                  },
                  loading: () => const SpinKitThreeBounce(
                    color: Colors.grey,
                    size: 40.0,
                  ),
                  error: (error, stack) {
                    ref.read(weatherProvider.notifier).isSearched = false;
                    return Text('Error: ${ref.read(weatherProvider.notifier).error}');
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
