import 'package:dusty_dust/const/colors.dart';
import 'package:flutter/material.dart';

class MainAppBar extends StatelessWidget {
  const MainAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final ts = TextStyle( // 자주쓰는 폰트 색상 상수화
        color: Colors.white,
        fontSize: 30.0
    );
    return SliverAppBar(
      backgroundColor: primaryColor,
      expandedHeight: 500,
      // 스크롤 시 사라지게 할 수 있는 공간
      flexibleSpace: FlexibleSpaceBar(
          background: SafeArea(
            child: Container(
              margin: EdgeInsets.only(top:kToolbarHeight), // 자동 앱바 간격
              child: Column(
                children: [
                  Text('서울', style: ts.copyWith( // 구조분해할당
                    fontSize: 40.0,
                    fontWeight: FontWeight.w700,
                  ),),
                  Text(
                    DateTime.now().toString(),
                    style: ts.copyWith(
                      fontSize: 20.0,
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  Image.asset(
                    'asset/img/mediocre.png',
                    width: MediaQuery.of(context).size.width / 2,
                  ),
                  const SizedBox(height: 20.0),
                  Text('보통', style: ts.copyWith(
                    fontSize: 40.0,
                    fontWeight: FontWeight.w700,
                  ) ),
                  const SizedBox(height: 8.0),
                  Text('나쁘지 않네요!', style: ts.copyWith(
                    fontSize: 20.0,
                    fontWeight: FontWeight.w700,
                  ) )
                ],
              ),
            ),
          )
      ),
    );
  }
}
