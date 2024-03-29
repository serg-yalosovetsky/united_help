import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:united_help/routes/routes.dart';
import 'package:united_help/screen/filter_screen.dart';
import 'package:united_help/screen/my_events_history.dart';

import '../fragment/bottom_navbar.dart';
import '../fragment/build_app_bar.dart';
import '../fragment/events_list.dart';
import '../fragment/events_list_organizer.dart';
import '../fragment/switch_app_bar.dart';
import '../providers/appservice.dart';

class MyEventsScreen extends StatefulWidget {
  const MyEventsScreen({super.key});

  @override
  State<MyEventsScreen> createState() => _MyEventsScreenState();
}


class _MyEventsScreenState extends State<MyEventsScreen> {
  int selected_index = 0;
  bool selected_list = true;
  late AppService _app_service;

  @override
  Widget build(BuildContext context) {
    _app_service = Provider.of<AppService>(context, listen: false);
    bool is_organizer = _app_service.role == Roles.organizer;
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
        appBar: _app_service.organizer_has_no_events ?
                buildAppBar(null, 'Новий івент',) :
                build_switch_app_bar(
                      _app_service,
                      fun: () {
                        setState(() {
                        if (_app_service.actual_or_history == SwitchEnum.first){
                          _app_service.actual_or_history = SwitchEnum.second;
                          context.go(APP_PAGE.my_events_history.to_path);
                        } else {
                          _app_service.actual_or_history = SwitchEnum.first;
                          context.go(APP_PAGE.my_events.to_path);
                        }
                        });
                      },
                    map_or_history: 'history',
                ),
        body: SafeArea(
          child: is_organizer ? EventListOrganizerScreen(event_query: 'created',):
                                EventListScreen(event_query: 'subscribed'),
        ),
        bottomNavigationBar: buildBottomNavigationBar(),
        floatingActionButton: is_organizer ? FloatingActionButton(
          onPressed: () { context.go(APP_PAGE.new_events_choose_help_or_job.to_path); },
          child: Icon(Icons.add),
        ) : Container(),
      ),
    );
  }
}

