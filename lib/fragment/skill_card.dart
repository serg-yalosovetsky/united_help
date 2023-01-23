import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:united_help/models/filter.dart';

import '../screen/new_event_screen.dart';
import '../providers/appservice.dart';
import '../providers/filters.dart';
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

class buildCityCard extends StatefulWidget {
  const buildCityCard({
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
  State<buildCityCard> createState() => buildCityCardState();
}

class buildCityCardState extends State<buildCityCard> {
  // late AppService _app_service;
  late Filters filters;

  @override
  void initState() {
    // _app_service = Provider.of<AppService>(context, listen: false);
    filters = Provider.of<Filters>(context, listen: false);

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
                color: filters.filter_city == widget.id ? active_color : inactive_color,
              ),
              color: filters.filter_city == widget.id ? active_color : inactive_color,
              borderRadius: BorderRadius.all(Radius.circular(10))),
          // padding: const EdgeInsets.all(8),														padding: const EdgeInsets.all(8),
          padding: const EdgeInsets.all(15),
          child: Text(
            widget.title,
            style: TextStyle(
              fontSize: 18,
              color: filters.filter_city == widget.id ? active_text_color : inactive_text_color,
            ),
          ),
        ),
      ),
      onTap: () {
        setState(() {

          if (filters.filter_city != widget.id){
            filters.filter_city = widget.id;
            if (widget.title == title_to_open_text_field) {
              filters.open_text_field_choose_other_city = true;
            } else {
              filters.open_text_field_choose_other_city = false;

            }
          } else {
            filters.filter_city = -1;
            // if (widget.title == title_to_open_text_field) {
            filters.open_text_field_choose_other_city = false;
            // }
            // is_active = false;
          }

          // is_active = !is_active;
        });
      },
    );
  }
}



class buildSkillCard extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(13, 8, 0, 0),
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(
              color: active != null && active! ? active_color : inactive_color,
            ),
            color: active != null && active! ? active_color : inactive_color,
            borderRadius: BorderRadius.all(Radius.circular(10))),
        // padding: const EdgeInsets.all(8),														padding: const EdgeInsets.all(8),
        padding: const EdgeInsets.all(15),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                color: active != null && active! ? active_text_color : inactive_text_color,
              ),
            ),
            GestureDetector(
                onTap: () {
                  if (fun != null) fun(title);
                },
                child: Icon(Icons.clear),
            ),
          ],
        ),
      ),
    );
  }
}



Widget buildSkillCard3({
    required String title,
    required int id,
    required AppService app_service,
    fun,
  } ){
  return Padding(
    padding: const EdgeInsets.fromLTRB(13, 8, 0, 0),
    child: Container(
      decoration: BoxDecoration(
          border: Border.all(
            color: inactive_color,
          ),
          color: inactive_color,
          borderRadius: BorderRadius.all(Radius.circular(10))),
      // padding: const EdgeInsets.all(8),														padding: const EdgeInsets.all(8),
      padding: const EdgeInsets.all(15),
      child: Row(
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              color: inactive_text_color,
            ),
          ),
          GestureDetector(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(6.0, 0, 0, 0),
              child: const Icon(
                Icons.cancel_outlined,
                size: 15,
              ),
            ),
            onTap: () {

              // var index = app_service.skills.indexOf(title);
              // print(index);
              // if (index >= 0)
              //   app_service.skills.removeAt(index);
              fun();
            },
          ),
        ],
      ),
    ),
  );
}


class buildSkillCard2 extends StatelessWidget {
  const buildSkillCard2({
    Key? key,
    required this.title,
    required this.id,
    required this.app_service,
    this.fun,

  }) : super(key: key);
  final String title;
  final int id;
  final AppService app_service;
  final fun;


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(13, 8, 0, 0),
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(
              color: inactive_color,
            ),
            color: inactive_color,
            borderRadius: BorderRadius.all(Radius.circular(10))),
        // padding: const EdgeInsets.all(8),														padding: const EdgeInsets.all(8),
        padding: const EdgeInsets.all(15),
        child: Row(
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                color: inactive_text_color,
              ),
            ),
            GestureDetector(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(6.0, 0, 0, 0),
                child: const Icon(
                  Icons.cancel_outlined,
                  size: 15,
                ),
              ),
              onTap: () {
                  // print('skillcard ${title}');
                  // var index = app_service.skills.indexOf(title);
                  // print(index);
                  // if (index >= 0)
                  //   app_service.skills.removeAt(index);
                  // print(app_service.skills);
                  fun(title);
              },
            ),
          ],
        ),
      ),
    );
  }



}

class buildEmploymentCard extends StatefulWidget {
  const buildEmploymentCard({
    Key? key,
    required this.title,
    this.active,
    this.fun,

  }) : super(key: key);
  final String title;
  final bool? active;
  final fun;

  @override
  State<buildEmploymentCard> createState() => buildEmploymentCardState();
}

class buildEmploymentCardState extends State<buildEmploymentCard> {
  // late AppService _app_service;
  late Filters filters;

  @override
  void initState() {
    // _app_service = Provider.of<AppService>(context, listen: false);
    filters = Provider.of<Filters>(context, listen: false);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    var color = filters.employment == str_to_employments(widget.title) ? active_color : inactive_color;
    var text_color = filters.employment == str_to_employments(widget.title) ? active_text_color : inactive_text_color;
    return GestureDetector(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(13, 8, 0, 0),
        child: Container(
          decoration: BoxDecoration(
              border: Border.all(
                color: color,
              ),
              color: color,
              borderRadius: BorderRadius.all(Radius.circular(10))),
          padding: const EdgeInsets.all(15),
          child: Text(
            widget.title,
            style: TextStyle(
              fontSize: 18,
              color: text_color,
            ),
          ),
        ),
      ),
      onTap: () {
        setState(() {
          if (filters.employment != str_to_employments(widget.title)){
            filters.employment = str_to_employments(widget.title);
          } else {
            filters.employment = null;
          }
        });
      },
    );
  }
}


Widget build_bold_left_text(String title, {padding}) {

  Widget container = Container(
    margin: const EdgeInsets.fromLTRB(8, 8, 0, 0),
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
