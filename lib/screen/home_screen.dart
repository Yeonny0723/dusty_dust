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
import 'package:hive_flutter/hive_flutter.dart';

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
  Future<void> fetchData() async {
    try {
      final now = DateTime.now();
      final fetchTime =
      DateTime(now.year, now.month, now.day, now.hour); // 재요청이 일어난 시간
      final box = Hive.box(ItemCode.PM10.name);
      final recent = box.values.last as StatModel; // 저장된 시간

      if (recent.dataTime.isAtSameMomentAs(fetchTime)) {
        // 이미 과거 요청이 일어난 적이 있다면
        print('이미 최신 데이터가 있습니다.');
        return; // 재호출을 막음
      }

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

        final allKeys = box.keys.toList();
        if (allKeys.length > 24) {
          final deleteKeys =
          allKeys.sublist(0, allKeys.length - 24); // javascript slice와 동일
          // 호춯 결과값이 배열에 추가되므로, 이전 호출한 데이터인 끝에서 24개의 데이터는 삭제한다.
          box.deleteAll(deleteKeys);
        }
      }
    } on DioError catch (e){ // Dio (네트워크 라이브러리) 오류만 잡겠다
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('인터넷 연결이 원할하지 않습니다.')),
      );
    }
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
    return ValueListenableBuilder(
      valueListenable: Hive.box<StatModel>(ItemCode.PM10.name).listenable(),
      builder: (context, box, widget) {
        // PM10 (미세먼지)

        final recentStat = box.values.toList().last as StatModel;
        // 미세먼지 최근 데이터의 현재 상태
        // 1 - 5, 6 - 10, 11 - 15
        // 7이 어떤 범위에 속하는가? 최솟값 1,6,11 기준 7보다 작은 값 중 가장 큰 값 선택
        final status = DataUtils.getStatusFromItemCodeAndValue(
            value: recentStat.getLevelFromRegion(region),
            itemCode: ItemCode.PM10);

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
              child: RefreshIndicator(
                onRefresh: () async {
                  await fetchData();
                },
                child: CustomScrollView(
                  controller: scrollController,
                  slivers: [
                    // 플러터에서 스크롤되는 모든 것
                    MainAppBar(
                      isExpanded: isExpanded,
                      region: region,
                      stat: recentStat,
                      status: status,
                      dateTime: recentStat.dataTime,
                    ),
                    SliverToBoxAdapter(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          CategoryCard(
                            region: region,
                            darkColor: status.darkColor,
                            lightColor: status.lightColor,
                          ),
                          const SizedBox(
                            height: 16.0,
                          ),
                          ...ItemCode.values.map((itemCode) {
                            // [] 안에 [] 가 위치한 경우 오류가 나기 때문에 spread operator로 풀어주는 작업 필요
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 16.0),
                              child: HourlyCard(
                                darkColor: status.darkColor,
                                lightColor: status.lightColor,
                                itemCode: itemCode,
                                region: region,
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
              ),
            ));
      },
    );
  }
}
