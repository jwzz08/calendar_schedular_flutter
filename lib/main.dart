import 'package:calendar_scheduler/database/drift_database.dart';
import 'package:calendar_scheduler/screen/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:drift/drift.dart';

const DEFAULT_COLORS = [
  //빨강
  'F44336',
  //주황
  'FF9800',
  //노랑
  'FFEB3B',
  //초록
  'FCAF50',
  //파랑
  '2196F3',
  //남색
  '3F51B5',
  //보라
  '9C27B0',
];

void main() async {
  //원래 runapp이 실행이 되면 이 문장은 자동으로 실행이 됨. 플러터 프레임워크가 준비가 된 상태인지 확인.
  // 하지만 여기에서는 runapp 이전에 초기화를 해주는 문장이 있기 때문에 처음에 적어주고 시작한다.
  WidgetsFlutterBinding.ensureInitialized();

  await initializeDateFormatting();

  final database = LocalDatabase();

  final colors = await database.getCategoryColors();

  //colors가 비어있으면 default_colors에 있는 색깔을 하나씩 넣어줌
  if (colors.isEmpty) {
    for (String hexCode in DEFAULT_COLORS) {
      await database.createCategoryColor(CategoryColorsCompanion(
        hexCode: Value(hexCode),
      ));
    }
  }

  runApp(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          fontFamily: 'NotoSans',
        ),
        home: HomeScreen(),
      )
  );
}