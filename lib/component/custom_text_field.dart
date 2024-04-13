import 'package:calendar_scheduler/const/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatelessWidget {
  final String label;
  //true - 시간(time) / false - 내용(content)
  final bool isTime;

  const CustomTextField({required this.label, required this.isTime, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style:
                TextStyle(color: PRIMARY_COLOR, fontWeight: FontWeight.w600)),
        if(isTime) renderTextField(),
        if(!isTime) Expanded(child: renderTextField(),),
      ],
    );
  }

  Widget renderTextField(){
    return TextField(
      cursorColor: Colors.grey,
      maxLines: isTime? 1 : null,
      expands: !isTime, // = isTime ? false : true,
      keyboardType: isTime ? TextInputType.number : TextInputType.multiline,
      //타입 제한하기(여기에서는 컴퓨터 자판을 이용해도 숫자만 적힌다)
      inputFormatters: isTime ? [
        FilteringTextInputFormatter.digitsOnly
      ] : [],
      decoration: InputDecoration(
        border: InputBorder.none,
        filled: true,
        fillColor: Colors.grey[300],
      ),
    );
  }
}
