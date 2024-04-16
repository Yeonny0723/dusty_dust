import 'package:dusty_dust/model/stat_model.dart';
import 'package:dusty_dust/model/status_model.dart';
import 'package:dusty_dust/const/status_level.dart';

class DataUtils {
  // date 객체 yyyy-mm-dd:m 형태로 변환
  static String getTimeFromDateTime({required DateTime dateTime}) {
    return '${dateTime.year}-${dateTime.month}-${dateTime.day} ${getTimeFormat(
        dateTime.hour)}:${getTimeFormat(dateTime.minute)}';
  }

  static String getTimeFormat(int number) {
    return number.toString().padLeft(2, '0'); // 0보가 작으면 왼쪽에 2 추가
  }

  // itemCode 별 단위 반환 유틸함수
  static String getUnitFromItemCode({
    required ItemCode itemCode,
  }) {
    switch (itemCode) {
      case ItemCode.PM10:
        return '㎍/㎥';

      case ItemCode.PM25:
        return '㎍/㎥';

      default:
        return 'ppm';
    }
  }

  // 아이템 코드 지칭 명사 반환 함수
  static String getItemCodeKrString({
    required ItemCode itemCode,
  }) {
    switch (itemCode) {
      case ItemCode.PM10:
        return '미세먼지';

      case ItemCode.PM25:
        return '초미세먼지';

      case ItemCode.NO2:
        return '이산화질소';

      case ItemCode.O3:
        return '오존';

      case ItemCode.CO:
        return '일산화탄소';

      case ItemCode.SO2:
        return '아황산가스';
    }
  }

  // 현재 미세먼지 상태 판별 유틸함수
  static StatusModel getStatusFromItemCodeAndValue({
    required double value,
    required ItemCode itemCode,
  }) {
    return statusLevel.where(
            (status) {
          if(itemCode == ItemCode.PM10){
            return status.minFineDust < value;
          }else if(itemCode == ItemCode.PM25){
            return status.minUltraFineDust < value;
          }else if(itemCode == ItemCode.CO){
            return status.minCO < value;
          }else if(itemCode == ItemCode.O3){
            return status.minO3 < value;
          }else if(itemCode == ItemCode.NO2){
            return status.minNO2 < value;
          }else if(itemCode == ItemCode.SO2){
            return status.minSO2 < value;
          }else{
            throw Exception('알수없는 ItemCode입니다.');
          }
        }
    ).last;
  }
}
