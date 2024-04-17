import 'package:dusty_dust/component/card_title.dart';
import 'package:dusty_dust/component/main_card.dart';
import 'package:dusty_dust/component/main_stat.dart';
import 'package:dusty_dust/const/colors.dart';
import 'package:dusty_dust/utils/data_utils.dart';
import 'package:flutter/material.dart';
import 'package:dusty_dust/model/stat_and_status_model.dart';

class CategoryCard extends StatelessWidget {
  final String region;
  final List<StatAndStatusModel> models;

  const CategoryCard({super.key, required this.region, required this.models});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 160,
      child: MainCard(child: LayoutBuilder(builder: (context, constraint) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CardTitle(title: '종류별 통계'),
            Expanded(
                child: ListView(
              scrollDirection: Axis.horizontal,
              physics:
                  PageScrollPhysics(), // 옆으로 스크롤 시 그 다음 페이지로 넘어가는 것처럼 보이게 함
              children: models
                  .map((model) => MainStat(
                      width: constraint.maxWidth /
                          3, // 한 슬라이드에 3개의 상태값이 들어가도록 제한하기 위해 현재 context width 의 1/3 너비 설정
                      category: DataUtils.getItemCodeKrString(
                          itemCode: model.itemCode),
                      imgPath: model.status.imagePath,
                      level: model.status.label,
                      stat:
                          '${model.stat.getLevelFromRegion(region)}${DataUtils.getUnitFromItemCode(itemCode: model.itemCode)}'))
                  .toList(),
              // List.generate(
              //   20,
              //   (index) => MainStat(
              //       width: constraint.maxWidth /
              //           3, // 한 슬라이드에 3개의 상태값이 들어가도록 제한하기 위해 현재 context width 의 1/3 너비 설정
              //       category: '미세먼지$index',
              //       imgPath: 'asset/img/best.png',
              //       level: '최채',
              //       stat: '0㎍/㎥'),
              // )),
            ))
          ],
        );
      })),
    );
  }
}
