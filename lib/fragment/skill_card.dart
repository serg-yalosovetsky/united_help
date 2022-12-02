import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/appservice.dart';
const TextStyle timerStyle = TextStyle(
  fontSize: 18,
);
const optionStyle = TextStyle(fontSize: 20, fontWeight: FontWeight.bold);
const inactive_color = const Color(0xFFF0F3FF);
const active_color = const Color(0xFF0071d8);
const active_text_color = Colors.white;
const inactive_text_color = Colors.black;
const title_to_open_text_field = 'Інше';

// Widget buildSkillCard(String title, {required int id, bool active = false, var fun}) {
//   Widget padding = skill_card(title: title, id: id);
//   // if (fun != null)
//   //     return GestureDetector(
//   //            child: padding,
//   //            onTap: () {fun(active); print('click');},
//   //     );
//   // else
//       return padding;
// }

class buildSkillCard extends StatefulWidget {
  const buildSkillCard({
    Key? key,
    required this.title,
    required this.id,
    this.active,
    this.fun,

  }) : super(key: key);
  final String title;
  final int id;
  final bool? active;
  final fun;

  @override
  State<buildSkillCard> createState() => buildSkillCardState();
}

class buildSkillCardState extends State<buildSkillCard> {
  // bool is_active = false;
  late AppService _app_service;

  @override
  void initState() {
    _app_service = Provider.of<AppService>(context, listen: false);
    // if (_app_service.filter_city == widget.id){
    //      is_active = true;
    // } else {
    //   is_active = false;
    // }
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(13, 8, 0, 0),
        child: Container(
          decoration: BoxDecoration(
              border: Border.all(
                color: _app_service.filter_city == widget.id ? active_color : inactive_color,
              ),
              color: _app_service.filter_city == widget.id ? active_color : inactive_color,
              borderRadius: BorderRadius.all(Radius.circular(10))),
          // padding: const EdgeInsets.all(8),														padding: const EdgeInsets.all(8),
          padding: const EdgeInsets.all(15),
          child: Text(
            widget.title,
            style: TextStyle(
              fontSize: 18,
              color: _app_service.filter_city == widget.id ? active_text_color : inactive_text_color,
            ),
          ),
        ),
      ),
      onTap: () {
        setState(() {
          if (_app_service.filter_city != widget.id){
            // is_active = true;
            _app_service.filter_city = widget.id;
            if (widget.title == title_to_open_text_field) {
              _app_service.open_text_field_choose_other_city = true;
            } else {
              _app_service.open_text_field_choose_other_city = false;

            }
          } else {
            _app_service.filter_city = -1;
            // if (widget.title == title_to_open_text_field) {
            _app_service.open_text_field_choose_other_city = false;
            // }
            // is_active = false;
          }

          // is_active = !is_active;
        });
      },
    );
  }
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
