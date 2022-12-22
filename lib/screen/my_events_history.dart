import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:united_help/routes/routes.dart';
import 'package:united_help/screen/filter_screen.dart';

import '../fragment/bottom_navbar.dart';
import '../fragment/build_app_bar.dart';
import '../fragment/events_list.dart';
import '../fragment/events_list_history.dart';
import '../fragment/events_list_organizer.dart';
import '../fragment/switch_app_bar.dart';
import '../services/appservice.dart';
import 'my_events_organizer.dart';

class MyEventsHistoryScreen extends StatefulWidget {
  const MyEventsHistoryScreen({super.key});

  @override
  State<MyEventsHistoryScreen> createState() => _MyEventsHistoryScreenState();
}


class _MyEventsHistoryScreenState extends State<MyEventsHistoryScreen> {
  int selected_index = 0;
  bool selected_list = true;
  late AppService _app_service;

  @override
  Widget build(BuildContext context) {
    _app_service = Provider.of<AppService>(context, listen: false);

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
                  to_filters: null,
                map_or_history: false,
            ),
        body: SafeArea(
          child: EventListHistoryScreen(event_query: 'finished',),
        ),
        bottomNavigationBar: buildBottomNavigationBar(),
        floatingActionButton: FloatingActionButton(
          onPressed: () { context.go(APP_PAGE.new_events_choose_help_or_job.to_path); },
          child: Icon(Icons.add),
        ),
      ),
    );
  }
}

