import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:united_help/models/filter.dart';

import '../constants/colors.dart';
import '../constants/styles.dart';
import '../screen/new_event_screen.dart';
import '../providers/appservice.dart';
import '../providers/filters.dart';
const TextStyle timerStyle = TextStyle(
  fontSize: 18,
);

const title_to_open_text_field = 'Інше';

// Widget buildSkillCard(String title, {required int id, bool active = false, var fun}) {
//   Widget padding = skill_card(title: title, id: id);
//   // if (fun != null)
//   //     return GestureDetector(
//   //            child: padding,
//   //            onTap: () {fun(active); dPrint('click');},
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
                color: filters.city == widget.id ? ColorConstant.Volonterka_theme_color : ColorConstant.Background_for_chips,
              ),
              color: filters.city == widget.id ? ColorConstant.Volonterka_theme_color : ColorConstant.Background_for_chips,
              borderRadius: BorderRadius.all(Radius.circular(10))),
          // padding: const EdgeInsets.all(8),														padding: const EdgeInsets.all(8),
          padding: const EdgeInsets.all(15),
          child: Text(
            widget.title,
            style: TextStyle(
              fontSize: 18,
              color: filters.city == widget.id ? ColorConstant.active_text_color : ColorConstant.inactive_text_color,
            ),
          ),
        ),
      ),
      onTap: () {
        setState(() {

          if (filters.city != widget.id){
            filters.city = widget.id;
            if (widget.title == title_to_open_text_field) {
              filters.open_text_field_choose_other_city = true;
            } else {
              filters.open_text_field_choose_other_city = false;

            }
          } else {
            filters.city = -1;
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
              color: active != null && active! ? ColorConstant.Volonterka_theme_color : ColorConstant.Background_for_chips,
            ),
            color: active != null && active! ? ColorConstant.Volonterka_theme_color : ColorConstant.Background_for_chips,
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
                color: active != null && active! ? ColorConstant.active_text_color : ColorConstant.inactive_text_color,
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
            color: ColorConstant.Background_for_chips,
          ),
          color: ColorConstant.Background_for_chips,
          borderRadius: BorderRadius.all(Radius.circular(10))),
      // padding: const EdgeInsets.all(8),														padding: const EdgeInsets.all(8),
      padding: const EdgeInsets.all(15),
      child: Row(
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              color: ColorConstant.inactive_text_color,
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
              // dPrint(index);
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
              color: ColorConstant.Background_for_chips,
            ),
            color: ColorConstant.Background_for_chips,
            borderRadius: BorderRadius.all(Radius.circular(10))),
        // padding: const EdgeInsets.all(8),														padding: const EdgeInsets.all(8),
        padding: const EdgeInsets.all(15),
        child: Row(
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                color: ColorConstant.inactive_text_color,
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
    var color = filters.employment == str_to_employments(widget.title) ? ColorConstant.Volonterka_theme_color : ColorConstant.Background_for_chips;
    var text_color = filters.employment == str_to_employments(widget.title) ? ColorConstant.active_text_color : ColorConstant.inactive_text_color;
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
        style: StyleConstant.bold_header,
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
