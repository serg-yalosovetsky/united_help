
import 'package:flutter/material.dart';
import 'package:united_help/fragment/skill_card.dart';
import '../fragment/bottom_navbar.dart';
import '../main.dart';


var locations_state;
var employment_state;
var time_start_state;
var time_end_state;
var skills_state;

class filters extends StatefulWidget {
  const filters({
      Key? key,
    required this.time_start,
    required this.time_end,
    required this.locations,
    required this.employment,
    required this.skills,
  }) : super(key: key);
  final List time_start;
  final List time_end;
  final List locations;
  final List employment;
  final List skills;

  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static const TextStyle timerStyle = TextStyle(
    fontSize: 18,
  );
  static const TextStyle timerBoldStyle =
      TextStyle(fontSize: 18, fontWeight: FontWeight.bold);

  @override
  State<filters> createState() => _filtersState();
}

class _filtersState extends State<filters> {

  Widget return_skills_card(List skills,
          {
            int skill_in_row = 2,
            Widget? start_widget,
            List<bool>? active,
            var fun,
          }) {
    List<Widget> columns = [];
    int i = 0;
    print('skills.length ${skills.length}');
    print('skill_in_row ${skill_in_row}');
    print('skills.length/skill_in_row ${skills.length/skill_in_row}');
    print('(skills.length/skill_in_row).ceil() ${(skills.length/skill_in_row).ceil()}');
    while (i < (skills.length/skill_in_row).ceil()) {
      List<Widget> rows = [];
      if (start_widget != null) rows.add(start_widget);
      for (int j=0; j < skill_in_row; j++ ){
        print('i= $i     j= $j');
        int index = i * skill_in_row + j;
        if (index < skills.length) {
          if (fun != null) {

            Widget button = GestureDetector(
                child: buildSkillCard(title: skills[index], id: 0,
                    active: active?[index] ?? false),
                onTap: () {
                  print('click');
                  setState(() {
                    if (active![index] != null && active[index] == true)
                      active[index] = false;
                    else
                      active[index] = true;
                  });

                },
            );
            rows.add(button);
          }
          else
              rows.add(buildSkillCard(title: skills[index], id: 0,
                                      active: active?[index] ?? false));
        }
      }
      Widget row_widget = Row(
        children: rows,
      );
      columns.add(row_widget);
      i++;
    }
    return Column(children: columns);
  }
  @override
  void initState() {
    locations_state = List<bool>.generate(
      widget.locations.length,
          (int index) => false, growable: false,
    );
    employment_state = List<bool>.generate(
      widget.employment.length,
          (int index) => false, growable: false,
    );
    time_start_state = List<bool>.generate(
      widget.time_start.length,
          (int index) => false, growable: false,
    );
    time_end_state = List<bool>.generate(
      widget.time_end.length,
          (int index) => false, growable: false,
    );
    skills_state = List<bool>.generate(
      widget.skills.length,
          (int index) => false, growable: false,
    );
  }

  @override
  Widget build(BuildContext context) {

    void on_item_tap(bool active){
      print('click2 $active');
      setState(() {
        if (active)
          active = false;
        else
          active = true;
      });
    }
    return Scaffold(
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.all(10),
          child: Expanded(
            child: ListView(
              shrinkWrap: true,
              children: [

                Container(
                  height: 800,
                  child: Column(
					mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      build_bold_left_text(
                        'Локація',
                        padding: const EdgeInsets.fromLTRB(0, 0, 8, 20),
                      ),
                      Container(
                        // height: 500,
                        // width: 500,
                        margin: const EdgeInsets.fromLTRB(12, 0, 8, 12),
                        child: return_skills_card(
                            widget.locations,
                            skill_in_row: 4,
                            active: locations_state,
                            fun: on_item_tap,
                        ),
                      ),
                      build_bold_left_text(
                          'Зайнятість',
                          padding: const EdgeInsets.fromLTRB(0, 0, 8, 20),
                      ),
                      Container(
                        // height: 500,
                        // width: 500,
                        margin: const EdgeInsets.fromLTRB(12, 0, 8, 12),
                        child: return_skills_card(
                            widget.employment,
                            skill_in_row: 3,
                            active: employment_state,
                            fun: on_item_tap,
                        ),
                      ),
                      build_bold_left_text(
                        'Вміння',
                        padding: const EdgeInsets.fromLTRB(0, 0, 8, 20),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
                        child: const TextField(
                          obscureText: false,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius : BorderRadius.all(Radius.circular(16.0)),
                            ),
                            labelText: 'Робота з людьми, погрузка...',
                          ),
                        ),
                      ),
                      build_bold_left_text(
                          'Дата',
                          padding: const EdgeInsets.fromLTRB(0, 0, 8, 20),
                      ),
                      Container(
                        // height: 500,
                        // width: 500,
                        margin: const EdgeInsets.fromLTRB(12, 0, 8, 12),
                        child: return_skills_card(
                            widget.time_start,
                            active: time_start_state,
                            start_widget: Padding(
                              padding: const EdgeInsets.fromLTRB(8.0, 0, 0, 8.0),
                              child: Text('Початок', style: filters.timerBoldStyle,),
                            )
                        ),
                      ),
                      Container(
                        // height: 500,
                        // width: 500,
                        margin: const EdgeInsets.fromLTRB(12, 0, 8, 30),
                        child: return_skills_card(
                            widget.time_end,
                            active: time_end_state,
                            start_widget: Padding(
                              padding: const EdgeInsets.fromLTRB(8.0, 0, 0, 8.0),
                              child: Text('Кінець', style: filters.timerBoldStyle,),
                            )
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: buildBottomNavigationBar(),

    );
  }
}
