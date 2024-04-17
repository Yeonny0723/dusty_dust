import 'package:dusty_dust/component/card_title.dart';
import 'package:dusty_dust/component/main_card.dart';
import 'package:flutter/material.dart';

class HourlyCard extends StatelessWidget {
  final Color darkColor;
  final Color lightColor;
  const HourlyCard(
      {super.key, required this.darkColor, required this.lightColor});

  @override
  Widget build(BuildContext context) {
    return MainCard(
        backgroundColor: lightColor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CardTitle(title: '시간별 미세먼지', backgroundColor: darkColor),
            Column(
                children: List.generate(24, (index) {
              final now = DateTime.now();
              final hour = now.hour;
              int currentHour = hour - index;

              if (currentHour < 0) {
                currentHour += 24;
              }
              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                child: Row(
                  children: [
                    // children 내 모든 child가 같은 너비를 갖도록 하려면 Expanded로 감쌈 (spaceBetween x)
                    Expanded(child: Text('$currentHour시')),
                    Expanded(
                      child: Image.asset(
                        'asset/img/good.png',
                        height: 20.0,
                      ),
                    ),
                    Expanded(
                        child: Text(
                      '좋음',
                      textAlign: TextAlign.right,
                    ))
                  ],
                ),
              );
            }))
          ],
        ));
  }
}
