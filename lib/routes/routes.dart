import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../constants.dart';
import '../screen/account_screen.dart';
import '../screen/example.dart';
import '../screen/home.dart';
import '../screen/map.dart';
import '../services/login_state.dart';

final GoRouter go_router = GoRouter(
  routes: [
    GoRoute(
      path: "/",
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: "/account",
      builder: (context, state) => const AccountScreen(),
    ),
    GoRoute(
      path: "/map",
      builder: (context, state) => const GoogleMapScreen(),
    ),
    GoRoute(
      path: "/example",
      builder: (context, state) => ExampleScreen(),
    ),
  ],
);