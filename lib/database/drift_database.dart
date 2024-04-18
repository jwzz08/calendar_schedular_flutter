//import는 private 값들을 불러올 수 없음
import 'dart:io';

import 'package:drift/native.dart';
import 'package:drift/drift.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

import '../model/category_color.dart';
import '../model/schedule.dart';

//part는 private 값까지 불러올 수 있다.
//.g.dart -> 여기에서 g는 generate 즉, 자동으로 생성됐다라는 뜻이다.
//이건 drift_database.g.dart 파일을 자동으로 생성되게 해줄 것
part 'drift_database.g.dart';

@DriftDatabase(
  tables: [
    Schedules,
    CategoryColors,
  ],
)
//_$LocalDatabase 는 drift_database.g.dart 파일이 생성이 되면 Drift가 class로 만들어 줄 것임.
// _$LocalDatabase 은 private 임에도 불구하고 불러올 수 있는 이유는 part로 불러왔기 때문.
class LocalDatabase extends _$LocalDatabase {
  LocalDatabase() : super(_openConnection());

  //insert query
  //insert를 하면 자동으로 insert 한 값의 PRIMARY KEY(ID)를 return 받을 수 있음
  Future<int> createSchedule(SchedulesCompanion data) => into(schedules).insert(data);

  //Future은 단발적임. 즉 요청을 하면 한 번 받을 수 있음.
  Future<int> createCategoryColor(CategoryColorsCompanion data) => into(categoryColors).insert(data);

  //stream + watch를 사용하게 되면 값이 업데이트 될 때마다 계속 받을 수 있음
  Stream<List<Schedule>> watchSchedules() => select(schedules).watch();

  //select query
  //select는 값들을 순차적으로 string으로 받을 수 있기도 하고, Future로 값들을 한꺼번에 받을 수도 있음
  //1. 값을 한꺼번에 가져오는 방법(category color들만 먼저 가져오는 방법)
  Future<List<CategoryColor>> getCategoryColors() => select(categoryColors).get();

  @override
  //테이블의 구조 자체가 변경될 때마다 schemaVerision을 올려줘야한다.(row 바뀔 때 말고)
  int get schemaVersion => 1;
}

LazyDatabase _openConnection(){
  return LazyDatabase( () async {
    final dbFolder = await getApplicationDocumentsDirectory();
    //dbFolder의 path에 'db.sqlite'라는 파일을 생성 -> file이라는 변수에 저장
    final file = File(p.join(dbFolder.path, 'db.sqlite'));
    return NativeDatabase(file);
  } );
}