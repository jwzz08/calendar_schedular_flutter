import 'package:calendar_scheduler/component/custom_text_field.dart';
import 'package:calendar_scheduler/const/colors.dart';
import 'package:calendar_scheduler/model/category_color.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:calendar_scheduler/database/drift_database.dart';
import 'package:drift/drift.dart' show Value;

class ScheduleBottomSheet extends StatefulWidget {
  final DateTime selectedDate;

  const ScheduleBottomSheet({required this.selectedDate, Key? key})
      : super(key: key);

  @override
  State<ScheduleBottomSheet> createState() => _ScheduleBottomSheetState();
}

class _ScheduleBottomSheetState extends State<ScheduleBottomSheet> {
  final GlobalKey<FormState> formKey = GlobalKey();

  int? startTime;
  int? endTime;
  String? content;
  int? selectedColorId;

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return GestureDetector(
      //아무 곳이나 누르면 키보드 닫히게(내려가게) 하기 위해 gestureDetector 사용.
      onTap: () {
        FocusScope.of(context).requestFocus((FocusNode()));
      },
      child: SafeArea(
        child: Container(
          height: MediaQuery.of(context).size.height / 2 + bottomInset,
          color: Colors.white,
          child: Padding(
            padding: EdgeInsets.only(bottom: bottomInset),
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 16.0),
              child: Form(
                key: formKey,
                //form에 입력을 할 때 실시간으로 검증해준다
                autovalidateMode: AutovalidateMode.always,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _Time(onStartSaved: (String? val) {
                      startTime = int.parse(val!);
                    }, onEndSaved: (String? val) {
                      endTime = int.parse(val!);
                    }),
                    SizedBox(
                      height: 16.0,
                    ),
                    _Content(
                      onSaved: (String? val) {
                        content = val;
                      },
                    ),
                    SizedBox(
                      height: 16.0,
                    ),
                    FutureBuilder<List<CategoryColor>>(
                        future: GetIt.I<LocalDatabase>().getCategoryColors(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData &&
                              selectedColorId == null &&
                              snapshot.data!.isNotEmpty) {
                            selectedColorId = snapshot.data![0].id;
                          }

                          return _ColorPicker(
                              colorIdSetter: (int id) {
                                setState(() {
                                  selectedColorId = id;
                                });
                              },
                              selectedColorId: selectedColorId,
                              colors: snapshot.hasData ? snapshot.data! : []);
                        }),
                    SizedBox(
                      height: 8.0,
                    ),
                    _SaveButton(onPressed: onSavePressed),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void onSavePressed() async {
    //formKey는 생성을 했는데 Form 위젯과 결합을 안했을 때 currentState가 null이 될 수 있다.
    //form 위젯 안에 formkey를 넣어주기만 해도 절대 null이 될 수 없다.
    if (formKey.currentState == null) {
      return;
    }

    //모든 textformfield에서 null값이 return이 되면(오류가 없으면)
    //formKey.currentState!.validate() 값이 true가 나온다.
    //오류가 뜨면 String 값으로 return을 해주고 formKey.currentState!.validate()은 false가 된다.
    if (formKey.currentState!.validate()) {
      print('에러가 없습니다');
      formKey.currentState!.save();

      final key = await GetIt.I<LocalDatabase>().createSchedule(SchedulesCompanion(
        date: Value(widget.selectedDate),
        startTime: Value(startTime!),
        endTime: Value(endTime!),
        content: Value(content!),
        colorId: Value(selectedColorId!),
      ));

      Navigator.of(context).pop();

    } else {
      print('에러가 있습니다.');
    }
  }
}

class _Time extends StatelessWidget {
  final FormFieldSetter<String>? onStartSaved;
  final FormFieldSetter<String>? onEndSaved;

  const _Time({required this.onStartSaved, required this.onEndSaved, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
            child: CustomTextField(
          label: '시작 시간',
          isTime: true,
          onSaved: onStartSaved,
        )),
        SizedBox(
          width: 16.0,
        ),
        Expanded(
            child: CustomTextField(
          label: '마감 시간',
          isTime: true,
          onSaved: onEndSaved,
        )),
      ],
    );
  }
}

class _Content extends StatelessWidget {
  final FormFieldSetter<String>? onSaved;

  const _Content({required this.onSaved, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: CustomTextField(
      label: '내용',
      isTime: false,
      onSaved: onSaved,
    ));
  }
}

typedef ColorIdSetter = void Function(int id);

class _ColorPicker extends StatelessWidget {
  final List<CategoryColor> colors;
  final int? selectedColorId;
  final ColorIdSetter colorIdSetter;

  const _ColorPicker(
      {required this.colorIdSetter,
      required this.selectedColorId,
      required this.colors,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8.0,
      runSpacing: 10.0,
      children: colors
          .map((e) => GestureDetector(
                child: renderColor(e, selectedColorId == e.id),
                onTap: () {
                  colorIdSetter(e.id);
                },
              ))
          .toList(),
    );
  }

  Widget renderColor(CategoryColor color, bool isSelected) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Color(
          int.parse('FF${color.hexCode}', radix: 16),
        ),
        border: isSelected
            ? Border.all(
                color: Colors.black,
                width: 4.0,
              )
            : null,
      ),
      width: 32.0,
      height: 32.0,
    );
  }
}

class _SaveButton extends StatelessWidget {
  final VoidCallback? onPressed;

  const _SaveButton({Key? key, required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
            child: ElevatedButton(
                onPressed: onPressed,
                style: ElevatedButton.styleFrom(primary: PRIMARY_COLOR),
                child: Text('저장'))),
      ],
    );
  }
}
