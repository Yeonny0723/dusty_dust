import 'package:dusty_dust/component/card_title.dart';
import 'package:dusty_dust/component/main_card.dart';
import 'package:dusty_dust/model/stat_model.dart';
import 'package:dusty_dust/utils/data_utils.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HourlyCard extends StatelessWidget {
  final Color darkColor;
  final Color lightColor;
  final String region;
  final ItemCode itemCode;

  const HourlyCard(
      {super.key,
      required this.darkColor,
      required this.lightColor,
      required this.region,
      required this.itemCode,
      });

  @override
  Widget build(BuildContext context) {
    return MainCard(
        backgroundColor: lightColor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CardTitle(title: '시간별 ${DataUtils.getItemCodeKrString(itemCode: itemCode)}', backgroundColor: darkColor),
            ValueListenableBuilder<Box>(valueListenable: Hive.box<StatModel>(itemCode.name).listenable(), builder: (context, box, widget)=>
              Column(children: box.values.map((stat) => renderRow(stat: stat)).toList()))
          ],
        ));
  }

  Widget renderRow({required StatModel stat}) {
    final status = DataUtils.getStatusFromItemCodeAndValue(
        value: stat.getLevelFromRegion(region), itemCode: stat.itemCode);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: Row(
        children: [
          // children 내 모든 child가 같은 너비를 갖도록 하려면 Expanded로 감쌈 (spaceBetween x)
          Expanded(child: Text('${stat.dataTime.hour}시')),
          Expanded(
            child: Image.asset(
              status.imagePath,
              height: 20.0,
            ),
          ),
          Expanded(
              child: Text(
            status.label,
            textAlign: TextAlign.right,
          ))
        ],
      ),
    );
  }
}
