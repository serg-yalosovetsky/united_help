import 'package:flutter/material.dart';
const TextStyle timerStyle = TextStyle(
  fontSize: 18,
);
const optionStyle = TextStyle(fontSize: 20, fontWeight: FontWeight.bold);

const inactive_color = const Color(0xFFF0F3FF);
const active_color = const Color(0xFF0071d8);
const active_text_color = Colors.white;
const inactive_text_color = Colors.black;

Widget buildSkillCard(String title, [bool active = false, var fun]) {
  Color get_color(bool active, [String type = 'background']){
    if (active) {
      if (type == 'background'){
        return active_color;
      }
      else {
        return active_text_color;
      }
    }
    else {
      if (type == 'background'){
        return inactive_color;
      }
      else {
        return inactive_text_color;
      }
    }
  }
  Widget padding = Padding(
    padding: const EdgeInsets.all(8.0),
    child: Container(
      decoration: BoxDecoration(
          border: Border.all(
            color: get_color(active, 'background'),

          ),
          color: get_color(active, 'background'),
          borderRadius: BorderRadius.all(Radius.circular(10))),
      // padding: const EdgeInsets.all(8),														padding: const EdgeInsets.all(8),
      padding: const EdgeInsets.all(15),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          color: get_color(active, 'font'),
        ),
      ),
    ),
  );
  // if (fun != null)
  //     return GestureDetector(
  //            child: padding,
  //            onTap: () {fun(active); print('click');},
  //     );
  // else
      return padding;
}


Widget build_bold_left_text(String title, {padding}) {

  Widget container = Container(
    margin: const EdgeInsets.fromLTRB(20, 20, 10, 0),
    child: Align(
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: optionStyle,
      ),
    ),
  );
  if (padding == null) return container;
  else {
    return Padding(
      padding: padding,
      child: container,
    );
  }
}
