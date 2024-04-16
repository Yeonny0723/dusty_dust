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
import 'package:dusty_dust/const/status_level.dart';
import 'package:dusty_dust/model/stat_model.dart';
import 'package:dusty_dust/repository/stat_repository.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override

  Future<List<StatModel>> fetchData() async {
    final statModels = await StatRepository.fetchData();
    return statModels;
  }

  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: primaryColor,
        drawer: MainDrawer(),
        body: FutureBuilder<List<StatModel>>(
          future: fetchData(),
          builder: (context, snapshot) {
            if (snapshot.hasError){ // 에러 발생
              return Center(
                child: Text('에러 발생!'),
              );
            }

            if (!snapshot.hasData){ // 데이터 로딩 중 (connectionState로 확인하면 연결할 때마다 로딩바 듬)
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            List<StatModel> stats = snapshot.data!;
            StatModel recentStat = stats[0];

            // 1 - 5, 6 - 10, 11 - 15
            // 7이 어떤 범위에 속하는가? 최솟값 1,6,11 기준 7보다 작은 값 중 가장 큰 값 선택
            final status = statusLevel.where((element) => element.minFineDust < recentStat.seoul).last;

            return CustomScrollView(
              slivers: [
                // 플러터에서 스크롤되는 모든 것
                MainAppBar(
                  stat: recentStat,
                  status: status,
                ),
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
            );
          },
        ));
  }
}
