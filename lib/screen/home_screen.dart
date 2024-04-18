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
import 'package:dusty_dust/model/stat_and_status_model.dart';
import 'package:dusty_dust/model/stat_model.dart';
import 'package:dusty_dust/repository/stat_repository.dart';
import 'package:dusty_dust/screen/regions.dart';
import 'package:dusty_dust/utils/data_utils.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String region = regions[0];
  bool isExpanded = true;
  ScrollController scrollController = ScrollController();

  @override
  initState() {
    super.initState();
    // 스크롤 컨트롤러 최초 등록
    scrollController.addListener(scrollListener);
    fetchData();
  }

  @override
  dispose() {
    // 비렌더링시 리스터 삭제 (메모리 관리)
    scrollController.removeListener(scrollListener);
    scrollController.dispose();
    super.dispose();
  }

  @override
  Future<Map<ItemCode, List<StatModel>>> fetchData() async {
    List<Future> futures = []; // 모든 Promise (future)를 담은 배열
    for (ItemCode itemCode in ItemCode.values) {
      futures.add(
        StatRepository.fetchData(
          itemCode: itemCode,
        ),
      );
    }

    final results = await Future.wait(futures); // 모든 Future가 완료될 때까지 기다림

    // Hive에 데이터 넣기
    for (int i = 0; i < results.length; i++) {
      final key = ItemCode.values[i]; // itemcode
      final value = results[i]; // List<StatModel>

      final box = Hive.box<StatModel>(key.name);

      for (StatModel stat in value) {
        box.put(stat.dataTime.toString(), stat); // dataTime은 중복 저장될 수 없다
      }
    }
    return ItemCode.values.fold<Map<ItemCode, List<StatModel>>>({},
        (previousValue, itemCode) {
      final box = Hive.box<StatModel>(itemCode.name);
      previousValue.addAll({
        itemCode: box.values.toList(),
      });
      return previousValue;
    });
  }

  scrollListener() {
    bool isExpanded = scrollController.offset <
        (500 - kToolbarHeight); // 현재 스크롤을 얼만큼 했는지 알 수 있음
    if (isExpanded != this.isExpanded) {
      setState(() {
        this.isExpanded = isExpanded;
      });
    }
  }

  Widget build(BuildContext context) {
    return FutureBuilder<Map<ItemCode, List<StatModel>>>(
      future: fetchData(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          // 에러 발생
          return Scaffold(
            body: Center(
              child: Text('에러 발생!'),
            ),
          );
        }

        if (!snapshot.hasData) {
          // 데이터 로딩 중 (connectionState로 확인하면 연결할 때마다 로딩바 듬)
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        Map<ItemCode, List<StatModel>> stats = snapshot.data!;
        StatModel pm10RecentStat = stats[ItemCode.PM10]![0];

        // 미세먼지 최근 데이터의 현재 상태
        // 1 - 5, 6 - 10, 11 - 15
        // 7이 어떤 범위에 속하는가? 최솟값 1,6,11 기준 7보다 작은 값 중 가장 큰 값 선택
        final status = DataUtils.getStatusFromItemCodeAndValue(
            value: pm10RecentStat.seoul, itemCode: ItemCode.PM10);

        final ssModel = stats.keys.map((key) {
          final value = stats[key];
          final stat = value![0];

          return StatAndStatusModel(
              itemCode: key,
              status: DataUtils.getStatusFromItemCodeAndValue(
                  value: stat.getLevelFromRegion(region), itemCode: key),
              stat: stat);
        }).toList();

        return Scaffold(
            drawer: MainDrawer(
              darkColor: status.darkColor,
              lightColor: status.lightColor,
              selectedRegion: region,
              onRegionTap: (String region) {
                setState(() {
                  this.region = region;
                  Navigator.of(context).pop(); // drawer 닫기
                });
              },
            ),
            body: Container(
              color: status.primaryColor,
              child: CustomScrollView(
                controller: scrollController,
                slivers: [
                  // 플러터에서 스크롤되는 모든 것
                  MainAppBar(
                    isExpanded: isExpanded,
                    region: region,
                    stat: pm10RecentStat,
                    status: status,
                    dateTime: pm10RecentStat.dataTime,
                  ),
                  SliverToBoxAdapter(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        CategoryCard(
                          region: region,
                          models: ssModel,
                          darkColor: status.darkColor,
                          lightColor: status.lightColor,
                        ),
                        const SizedBox(
                          height: 16.0,
                        ),
                        ...stats.keys.map((itemCode) {
                          // [] 안에 [] 가 위치한 경우 오류가 나기 때문에 spread operator로 풀어주는 작업 필요
                          final stat = stats[itemCode]!;
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 16.0),
                            child: HourlyCard(
                              darkColor: status.darkColor,
                              lightColor: status.lightColor,
                              category: DataUtils.getItemCodeKrString(
                                  itemCode: itemCode),
                              region: region,
                              stats: stat,
                            ),
                          );
                        }).toList(),
                        const SizedBox(
                          height: 16.0,
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ));
      },
    );
  }
}
