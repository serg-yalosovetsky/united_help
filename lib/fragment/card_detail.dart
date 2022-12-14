import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:united_help/fragment/skill_card.dart';
import '../fragment/bottom_navbar.dart';
import '../models/events.dart';
import '../services/show_nice_time.dart';

class card_detail extends StatelessWidget {
  const card_detail({
      Key? key,
    required this.event,
  }) : super(key: key);
  final Event event;

  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static const TextStyle timerStyle = TextStyle(
    fontSize: 18,
  );
  static const TextStyle timerBoldStyle =
      TextStyle(fontSize: 18, fontWeight: FontWeight.bold);

  Widget return_skills_card(List skills, [int skill_in_row = 2]) {
    List<Widget> columns = [];
    int i = 0;
    while (i <= skills.length/2.ceil()) {
      List<Widget> rows = [];
      if (i < skills.length) rows.add(buildCityCard(title: skills[i], id: 0));
      if (i + 1 < skills.length) rows.add(buildCityCard(title: skills[i+1], id: 0));
      Widget row_widget = Row(
        children: rows,
      );
      columns.add(row_widget);
      i = i +2;
    }
    return Column(children: columns);
  }



  @override
  Widget build(BuildContext context) {
    String employment_string = '';
    if (event.employment == 0)
      employment_string = 'Постійна зайнятість';
    else if (event.employment == 1)
      employment_string = show_nice_time(event.start_time, event.end_time);
    else if (event.employment == 2)
      employment_string = show_nice_time(event.start_time);

    Widget build_description(String text) {
      return Container(
        margin: const EdgeInsets.fromLTRB(20, 0, 8, 30),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Text(text, style: timerStyle,)
        ),
      );
    }
    Widget build_location(String text, IconData icon) {
     return Container(
        margin: const EdgeInsets.fromLTRB(20, 6, 8, 6),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(icon),
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
              child: Text(
                text,
                style: timerStyle,
              ),
            ),
          ],
        ),
      );
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
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20.0),
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(
                        minWidth: 70,
                        minHeight: 80,
                        maxWidth: double.infinity,
                        maxHeight: 450,
                      ),
                      child: Image(
                          image: CachedNetworkImageProvider(event.image),
                          fit: BoxFit.fitWidth
                      ),
                    ),
                  ),
                ),
                Container(
                  height: 800,
                  child: Column(
					mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      build_bold_left_text(event.name),
                      build_location('$employment_string', Icons.access_time),
                      build_location(event.location, Icons.location_on),
                      build_description(event.description),
                      Container(
                        margin: const EdgeInsets.fromLTRB(20, 0, 0, 30),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4.0),
                          child: Align(
							alignment: Alignment.centerLeft,
                            child: Text(
                              'Необхідні скіли',
                              style: timerBoldStyle,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        // height: 500,
                        // width: 500,
                        margin: const EdgeInsets.fromLTRB(20, 0, 8, 30),
                        child: return_skills_card(event.skills),
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
