import 'package:dusty_dust/const/colors.dart';
import 'package:dusty_dust/model/stat_model.dart';
import 'package:dusty_dust/model/status_model.dart';
import 'package:dusty_dust/utils/data_utils.dart';
import 'package:flutter/material.dart';

class MainAppBar extends StatelessWidget {
  final String region;
  final StatusModel status;
  final StatModel stat;
  final DateTime dateTime;
  final bool isExpanded;

  const MainAppBar(
      {super.key,
      required this.region,
      required this.status,
      required this.stat,
      required this.dateTime,
      required this.isExpanded});

  @override
  Widget build(BuildContext context) {
    final ts = TextStyle(
        // 자주쓰는 폰트 색상 상수화
        color: Colors.white,
        fontSize: 30.0);
    return SliverAppBar(
      backgroundColor: status.primaryColor,
      title: // 스크롤 펼쳐짐 여부에 따라 앱바 타이틀 선택적 노출
          isExpanded ? null : Text('$region ${DataUtils.getTimeFromDateTime(dateTime: dateTime)}'),
      centerTitle: true,
      pinned: true, // appbar fixed
      expandedHeight: 500,
      // 스크롤 시 사라지게 할 수 있는 공간
      flexibleSpace: FlexibleSpaceBar(
          background: SafeArea(
        child: Container(
          margin: EdgeInsets.only(top: kToolbarHeight), // 자동 앱바 간격
          child: Column(
            children: [
              Text(
                region,
                style: ts.copyWith(
                  // 구조분해할당
                  fontSize: 40.0,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                DataUtils.getTimeFromDateTime(dateTime: stat.dataTime),
                style: ts.copyWith(
                  fontSize: 20.0,
                ),
              ),
              const SizedBox(height: 20.0),
              Image.asset(
                status.imagePath,
                width: MediaQuery.of(context).size.width / 2,
              ),
              const SizedBox(height: 20.0),
              Text(status.label,
                  style: ts.copyWith(
                    fontSize: 40.0,
                    fontWeight: FontWeight.w700,
                  )),
              const SizedBox(height: 8.0),
              Text(status.comment,
                  style: ts.copyWith(
                    fontSize: 20.0,
                    fontWeight: FontWeight.w700,
                  ))
            ],
          ),
        ),
      )),
    );
  }
}
