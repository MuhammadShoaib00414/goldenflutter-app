import 'package:flutter/material.dart';
import 'package:goldexia_fx/providers/links_provider.dart';
import 'package:goldexia_fx/providers/signal_list_provider.dart';
import 'package:goldexia_fx/services/local_db/user_session.dart';
import 'package:goldexia_fx/views/screens/user/user_dashboard_screen.dart';
import 'package:goldexia_fx/views/screens/on_boarding_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/utils.dart';
import 'auth_provider.dart';

final user = UserSession.currentUser;
final role = user!.user!.role ?? 'user';

Future<Widget> initializeScreen() async {
  final pref = await SharedPreferences.getInstance();
  final seen = pref.getBool('onboarding_seen') ?? false;
  if (seen) {
    return UserDashboardScreen();
  } else {
    return OnBoardingScreen();
  }
}

final authProvider = Provider.of<AuthProvider>(Nav.context, listen: false);
final linksProvider = Provider.of<LinksProvider>(Nav.context, listen: false);
final signalProvider = Provider.of<SignalProvider>(Nav.context, listen: false);

class AppProviders {
  static List<ChangeNotifierProvider> providers = [
    ChangeNotifierProvider<AuthProvider>(create: (context) => AuthProvider()),
    ChangeNotifierProvider<LinksProvider>(create: (context) => LinksProvider()),
    ChangeNotifierProvider<SignalProvider>(
      create: (context) => SignalProvider(),
    ),
  ];
}
