enum ItemCode {
  // 미세먼지
  PM10,
  // 초미세먼지
  PM25,
  // 이산화질소
  NO2,
  // 오존
  O3,
  // 일산화탄소
  CO,
  // 이황산가스
  SO2,
}

class StatModel {
  final double daegu;
  final double chungnam;
  final double incheon;
  final double daejeon;
  final double gyeongbuk;
  final double sejong;
  final double gwangju;
  final double jeonbuk;
  final double gangwon;
  final double ulsan;
  final double jeonnam;
  final double seoul;
  final double busan;
  final double jeju;
  final double chungbuk;
  final double gyeongnam;
  final double gyeonggi;
  final DateTime dataTime;
  final ItemCode itemCode;

  StatModel({
    required this.daegu,
    required this.chungnam,
    required this.incheon,
    required this.daejeon,
    required this.gyeongbuk,
    required this.sejong,
    required this.gwangju,
    required this.jeonbuk,
    required this.gangwon,
    required this.ulsan,
    required this.jeonnam,
    required this.seoul,
    required this.busan,
    required this.jeju,
    required this.chungbuk,
    required this.gyeongnam,
    required this.gyeonggi,
    required this.dataTime,
    required this.itemCode,
  });

  StatModel.fromJson(
      {required Map<String, dynamic> json}) // json을 넣어주고 StatModel 형태로 변환하겠다
      : daegu = double.parse(json['daegu'] ?? '0'),
        // 숫자로 파싱
        chungnam = double.parse(json['chungnam'] ?? '0'),
        incheon = double.parse(json['incheon'] ?? '0'),
        daejeon = double.parse(json['daejeon'] ?? '0'),
        gyeongbuk = double.parse(json['gyeongbuk'] ?? '0'),
        sejong = double.parse(json['sejong'] ?? '0'),
        gwangju = double.parse(json['gwangju'] ?? '0'),
        jeonbuk = double.parse(json['jeonbuk'] ?? '0'),
        gangwon = double.parse(json['gangwon'] ?? '0'),
        ulsan = double.parse(json['ulsan'] ?? '0'),
        jeonnam = double.parse(json['jeonnam'] ?? '0'),
        seoul = double.parse(json['seoul'] ?? '0'),
        busan = double.parse(json['busan'] ?? '0'),
        jeju = double.parse(json['jeju'] ?? '0'),
        chungbuk = double.parse(json['chungbuk'] ?? '0'),
        gyeongnam = double.parse(json['gyeongnam'] ?? '0'),
        dataTime = DateTime.parse(json['dataTime']),
        itemCode = parseItemCode(json['itemCode']),
        gyeonggi = double.parse(json['gyeonggi'] ?? '0');

  static ItemCode parseItemCode(String raw) {
    // enum 타입을 반환하는 함수 선언
    if (raw == 'PM2.5') {
      // . <-을 이넘타입으로 선언할 수 없어서 예외처리
      return ItemCode.PM25;
    }

    return ItemCode.values.firstWhere((element) => element.name == raw);
    // element.name 형태로 객체에서 value를 꺼냄
  }

  double getLevelFromRegion(String region) {
    if (region == '서울') {
      return seoul;
    } else if (region == '경기') {
      return gyeonggi;
    } else if (region == '대구') {
      return daegu;
    } else if (region == '충남') {
      return chungnam;
    } else if (region == '인천') {
      return incheon;
    } else if (region == '대전') {
      return daejeon;
    } else if (region == '경북') {
      return gyeongbuk;
    } else if (region == '세종') {
      return sejong;
    } else if (region == '광주') {
      return gwangju;
    } else if (region == '전북') {
      return jeonbuk;
    } else if (region == '강원') {
      return gangwon;
    } else if (region == '울산') {
      return ulsan;
    } else if (region == '전남') {
      return jeonnam;
    } else if (region == '부산') {
      return busan;
    } else if (region == '제주') {
      return jeju;
    } else if (region == '충북') {
      return chungbuk;
    } else if (region == '경남') {
      return gyeongnam;
    } else {
      throw Exception('알수없는 지역입니다.');
    }
  }
}
