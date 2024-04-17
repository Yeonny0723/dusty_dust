import 'package:dusty_dust/main.dart';
import 'package:dusty_dust/utils/test2_screen.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class TestScreen extends StatefulWidget {
  const TestScreen({Key? key}) : super(key: key);

  @override
  State<TestScreen> createState() => _TestScreenState();
}

// Hive DB 활용 예제. 클라이언트에서 생성된 상태를 관리할 수 있음.
// UI(화면)를 다루는 데이터와 관계없는 데이터를 관리할 수 있겠다.
// 화면이 바뀌어도 유지됨. 글로벌 상태관리의 시작!
class _TestScreenState extends State<TestScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('TestScreen'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ValueListenableBuilder<Box>(  // 데이터가 변경되었을 때를 감지하는 리스너 등록
            // hive.flutter 지원 함수로 stream 빌더와 유사한 기능
            valueListenable: Hive.box(testBox).listenable(), // testBox는 테이블명이라 생각
            builder: (context, box, widget) {
              return Column(
                children: box.values
                    .map(
                      (e) => Text(e.toString()),
                )
                    .toList(),
              );
            },
          ),
          ElevatedButton(
            onPressed: () {
              final box = Hive.box(testBox);
              print('keys : ${box.keys.toList()}'); // 테이블의 키 가져오기
              print('values : ${box.values.toList()}'); // 테이블의 값 가져오기
            },
            child: Text(
              '박스 프린트하기!',
            ),
          ),
          ElevatedButton(
            onPressed: () {
              final box = Hive.box(testBox);

              // 데이터를 생성하거나
              // 업데이트할때
              box.put(1000, '새로운 데이터!!!');
            },
            child: Text(
              '데이터 넣기!',
            ),
          ),
          ElevatedButton(
            onPressed: () {
              final box = Hive.box(testBox);

              print(box.getAt(3)); // Hive는 데이터 넣을 때 key 기준 자동 정렬함. 인덱스로 데이터 꺼내기.
            },
            child: Text(
              '특정 값 가져오기!',
            ),
          ),
          ElevatedButton(
            onPressed: () {
              final box = Hive.box(testBox);

              box.deleteAt(2);
            },
            child: Text(
              '삭제하기!',
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => Test2Screen(),
                ),
              );
            },
            child: Text(
              '다음화면!',
            ),
          ),
        ],
      ),
    );
  }
}
