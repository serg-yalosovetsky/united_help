import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:united_help/fragment/skill_card.dart';
import 'package:united_help/fragment/welcome_button.dart';
import 'package:united_help/screen/register_email_confirmation.dart';
import 'package:united_help/services/appservice.dart';
import '../fragment/bottom_navbar.dart';
import '../models/events.dart';
import '../models/profile.dart';
import '../services/show_nice_time.dart';

class card_detail extends StatefulWidget {
  const card_detail({
      Key? key,
    required this.event,
    required this.owner,
    required this.skills_names,
  }) : super(key: key);
  final Event event;
  final UserProfile? owner;
  final Map<int, String> skills_names;

  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static const TextStyle timerStyle = TextStyle(
    fontSize: 18,
  );
  static const TextStyle timerBoldStyle =
      TextStyle(fontSize: 18, fontWeight: FontWeight.bold);

  @override
  State<card_detail> createState() => _card_detailState();
}

class _card_detailState extends State<card_detail> {
  @override
  Widget build(BuildContext context) {
    AppService app_service = Provider.of<AppService>(context, listen: false);
    String employment_string = '';
    if (widget.event.employment == 0)
      employment_string = 'Постійна зайнятість';
    else if (widget.event.employment == 1)
      employment_string = show_nice_time(widget.event.start_time, widget.event.end_time);
    else if (widget.event.employment == 2)
      employment_string = show_nice_time(widget.event.start_time);

    Widget build_description(String text) {
      return Container(
        margin: const EdgeInsets.fromLTRB(20, 0, 8, 30),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Text(text, style: card_detail.timerStyle,)
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
                style: card_detail.timerStyle,
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
                        image: CachedNetworkImageProvider(widget.event.image),
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
                    build_bold_left_text(widget.event.name),
                    build_location('$employment_string', Icons.access_time),
                    build_location(widget.event.location, Icons.location_on),
                    build_description(widget.event.description),
                    Container(
                      margin: const EdgeInsets.fromLTRB(16, 0, 0, 16),
                      child: Align(
							              alignment: Alignment.centerLeft,
                        child: Text(
                          'Необхідні скіли',
                          style: card_detail.timerBoldStyle,
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Wrap(
                        children: List<Widget>.generate(
                          widget.event.skills.length,
                            (index) => buildCityCard(title: widget.skills_names[widget.event.skills[index]] ?? '', id: widget.event.skills[index]),
                        ),
                      ),
                    ),
                    widget.owner != null ?
                    Column(
                      children: [
                        Container(
                          margin: const EdgeInsets.fromLTRB(16, 23, 0, 0),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Організатор',
                              style: card_detail.timerBoldStyle,
                            ),
                          ),
                        ),
                        Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(16, 23.0, 0, 0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    // crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        margin: EdgeInsets.only(right: 11),
                                        child: CircleAvatar(
                                          foregroundImage: CachedNetworkImageProvider(widget.owner?.profile.image ?? ''),
                                          radius: 25.0,
                                        ),
                                      ),
                                      Column(
                                        children: [
                                          Text(
                                            widget.owner?.profile.organization ?? '',
                                            style: TextStyle(
                                              fontSize: 17,
                                              fontWeight: FontWeight.w500,
                                              color: Color(0xFF002241),
                                            ),
                                          ),
                                          Text(
                                            widget.owner?.profile.url ?? '',
                                            style: TextStyle(
                                              fontSize: 17,
                                              fontWeight: FontWeight.w400,
                                              color: Color(0xFF748B9F),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  GestureDetector(
                                    onTap: () async {
                                      if (widget.owner != null) {
                                        bool new_is_me_subscribe_to = false;
                                        if (widget.owner?.profile.is_me_subscribe_to == null || !widget.owner!.profile.is_me_subscribe_to!)
                                            new_is_me_subscribe_to = true;
                                        else new_is_me_subscribe_to = false;

                                        setState(() {
                                          widget.owner?.profile.is_me_subscribe_to = new_is_me_subscribe_to;
                                        });
                                        await subscribe_unsubscribe_organizer(
                                          widget.owner?.profile.id ?? 0,
                                          new_is_me_subscribe_to,
                                          app_service,
                                      );
                                      }
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.only(right: 19.0),
                                      child: widget.owner?.profile.is_me_subscribe_to != null && widget.owner!.profile.is_me_subscribe_to! ?
                                                active_subscribe() :
                                                inactive_subscribe(),
                                    ),
                                  ),
                                ],
                              ),
                            ),


                            widget.owner?.user.phone!=null ? Container(
                              margin: const EdgeInsets.fromLTRB(16, 13, 0, 0),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(0, 0, 8, 0),
                                      child: Icon(
                                        Icons.phone_rounded,
                                        color: Color(0xff002241),
                                        size: 26,
                                      ),
                                    ),
                                    Text(
                                      widget.owner?.user.phone! ?? '',
                                      style: TextStyle(
                                          color: Color(0xff002241),
                                          fontSize: 18,
                                          fontWeight: FontWeight.w400
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ) : Container(),

                            widget.owner?.user.nickname!=null ? Container(
                              margin: const EdgeInsets.fromLTRB(16, 13, 0, 0),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(0, 0, 8, 0),
                                      child: Icon(
                                        Icons.telegram_rounded,
                                        color: Color(0xff29b6f6),
                                        size: 26,
                                      ),
                                    ),
                                    Text(
                                      widget.owner?.user.nickname ?? '',
                                      style: TextStyle(
                                          color: Color(0xff002241),
                                          fontSize: 18,
                                          fontWeight: FontWeight.w400
                                      ),
                                      // style: timerBoldStyle,
                                    ),
                                  ],
                                ),
                              ),
                            ) : Container(),


                          ],
                        ),
                      ],
                    ) : Container(),
                    welcome_button(
                      text: widget.event.subscribed ?
                      'Записано ' :
                      'Записатись ${widget.event.subscribed_members} з ${widget.event.required_members}',
                      icon_widget: widget.event.subscribed ? Icon(Icons.check) : null,
                      fun: () async {
                        setState(() {
                          widget.event.subscribed = !widget.event.subscribed;
                        });
                        await subscribe_unsubscribe_event(
                          widget.event.id,
                          widget.event.subscribed,
                          app_service,
                        );
                      },
                      active: true,
                      padding: [0, 31, 0, 0],

                    ),
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

class active_subscribe extends StatelessWidget {
  const active_subscribe({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44,
      height: 44,
      child: Icon(
        Icons.notifications,
        color: Colors.white,
        size: 28,
      ),
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Color(0xFF0071D8),
      ),
    );
  }
}

class inactive_subscribe extends StatelessWidget {
  const inactive_subscribe({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Icon(
      Icons.notifications,
      color: Color(0xFF0071D8),
      size: 28,
    );
  }
}