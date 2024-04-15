import 'package:drift/drift.dart';

// Table {ID, CONTENT, DATE, STARTTIME, ENDTIME, COLORID, CREATEDAT}
class Schedule extends Table {
  // PRIMARY KEY
  //1
  //2
  //3 ...
  // autoIncrement : 값을 입력하지 않아도 자동으로 숫자 입력해줌 (중복이 생기지 않는 좋은 방법)
  IntColumn get id => integer().autoIncrement()();

  // 내용
  TextColumn get content => text()();

  // 일정 날짜
  DateTimeColumn get date => dateTime()();

  // 시작 시간
  IntColumn get startTime => integer()();

  // 끝 시간
  IntColumn get endTime => integer()();

  // Category Color Table ID
  IntColumn get colorId => integer()();

  // 생성날짜
  //clientDefault : return 값을 자동으로 넣어주기 때문에  autoIncrement와 같이 값을 넣어줄 필요가 없음
  //만약 값을 직접 테이블에 넣는다면 이건 default 값을 지정해주는 것이기 때문에 함수가 실행이 되지 않고, 입력한 값이 결과값이 된다.
  DateTimeColumn get createdAt => dateTime().clientDefault(() => DateTime.now())();
}