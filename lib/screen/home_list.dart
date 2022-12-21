import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:united_help/routes/routes.dart';
import 'package:united_help/screen/filter_screen.dart';

import '../fragment/bottom_navbar.dart';
import '../fragment/events_list.dart';
import '../fragment/switch_app_bar.dart';
import '../services/appservice.dart';

class HomeScreen extends StatefulWidget {
  final String event_query;
  const HomeScreen({
    super.key,
    this.event_query = '',
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}


class _HomeScreenState extends State<HomeScreen> {
  int selected_index = 0;
  bool selected_list = true;
  late AppService _app_service;

  @override
  Widget build(BuildContext context) {
    _app_service = Provider.of<AppService>(context, listen: false);

    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
        appBar: build_switch_app_bar(_app_service,
              fun: () {
                setState(() {
                if (_app_service.list_or_map == ListOrMap.list){
                  _app_service.list_or_map = ListOrMap.map;
                  context.go(APP_PAGE.home_map.to_path);
                } else {
                  _app_service.list_or_map = ListOrMap.list;
                  context.go(APP_PAGE.home_list.to_path);
                }
                });
              },
              to_filters: () {
                // context.go(APP_PAGE.filters.to_path);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FiltersCard(),
                  ),
                );
              },
        ),
        body: SafeArea(
          child: EventListScreen(event_query: widget.event_query,),
        ),
        bottomNavigationBar: buildBottomNavigationBar(),
      ),
    );
  }
}

