import 'package:dio/dio.dart';
import 'package:dusty_dust/component/card_title.dart';
import 'package:dusty_dust/component/category_cart.dart';
import 'package:dusty_dust/component/hourly_card.dart';
import 'package:dusty_dust/component/main_app_bar.dart';
import 'package:dusty_dust/component/main_card.dart';
import 'package:dusty_dust/component/main_drawer.dart';
import 'package:dusty_dust/component/main_stat.dart';
import 'package:dusty_dust/const/colors.dart';
import 'package:dusty_dust/const/data.dart';
import 'package:dusty_dust/model/stat_model.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() { // 생성자 함수. 위젯 생성될 때 최초 1회 실행
    // TODO: implement initState
    super.initState();
    fetchData();
  }

  fetchData()async{
    final response = await Dio().get(
      'http://apis.data.go.kr/B552584/ArpltnStatsSvc/getCtprvnMesureLIst',
      queryParameters: {
        'serviceKey': serviceKey,
        'returnType': 'json',
        'numOfRows': 30,
        'pageNo': 1,
        'itemCode': 'PM10',
        'dataGubun': 'HOUR',
        'searchCondition': 'WEEK',
      },
    );

    print(response.data['response']['body']['items'].map(
        (item) => StatModel.fromJson(json:item)
    ));
  }

  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: primaryColor,
        drawer: MainDrawer(),
        body: CustomScrollView(
          slivers: [
            // 플러터에서 스크롤되는 모든 것
            MainAppBar(),
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  CategoryCard(),
                  const SizedBox(
                    height: 16.0,
                  ),
                  HourlyCard()
                ],
              ),
            )
          ],
        ));
  }
}
