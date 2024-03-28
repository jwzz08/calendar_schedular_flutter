import 'package:calendar_scheduler/screen/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  //원래 runapp이 실행이 되면 이 문장은 자동으로 실행이 됨. 플러터 프레임워크가 준비가 된 상태인지 확인.
  // 하지만 여기에서는 runapp 이전에 초기화를 해주는 문장이 있기 때문에 처음에 적어주고 시작한다.
  WidgetsFlutterBinding.ensureInitialized();

  await initializeDateFormatting();

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