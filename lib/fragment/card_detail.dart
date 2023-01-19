import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:united_help/fragment/skill_card.dart';
import '../fragment/bottom_navbar.dart';
import '../models/events.dart';
import '../models/profile.dart';
import '../services/show_nice_time.dart';

class card_detail extends StatelessWidget {
  const card_detail({
      Key? key,
    required this.event,
    required this.owner,
    required this.skills_names,
  }) : super(key: key);
  final Event event;
  final Profile? owner;
  final Map<int, String> skills_names;

  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static const TextStyle timerStyle = TextStyle(
    fontSize: 18,
  );
  static const TextStyle timerBoldStyle =
      TextStyle(fontSize: 18, fontWeight: FontWeight.bold);


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
    print(owner?.image);
    return Scaffold(
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.all(10),
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
                      margin: const EdgeInsets.fromLTRB(16, 0, 0, 16),
                      child: Align(
							              alignment: Alignment.centerLeft,
                        child: Text(
                          'Необхідні скіли',
                          style: timerBoldStyle,
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Wrap(
                        children: List<Widget>.generate(
                          event.skills.length,
                            (index) => buildCityCard(title: skills_names[event.skills[index]] ?? '', id: event.skills[index]),
                        ),
                      ),
                    ),
                    owner != null ?
                    Column(
                      children: [
                        Container(
                          margin: const EdgeInsets.fromLTRB(16, 23, 0, 0),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Організатор',
                              style: timerBoldStyle,
                            ),
                          ),
                        ),
                        Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(16, 23.0, 0, 0),
                              child: Row(
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(right: 11),
                                    child: CircleAvatar(
                                      foregroundImage: CachedNetworkImageProvider(owner?.image ?? ''),
                                      radius: 25.0,
                                    ),
                                  ),
                                  Column(
                                    children: [
                                      Text(owner?.name ?? 'Гум штаб Тернопіль'),
                                      Text(owner?.url ?? 'ternopil.help.com.ua'),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ) : Container(),
            ],

          ),
          ),
          ],
          ),
      ),
    ),
    bottomNavigationBar: buildBottomNavigationBar(),
    );
  }
}
