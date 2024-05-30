import 'package:flutter/widgets.dart';
import 'package:shop_app/helpCenter.dart';
import 'package:shop_app/screens/settings/settings_screen.dart';
 
import 'screens/profile/profile_screen.dart';
import 'screens/notifications/notifications_screen.dart';

// We use name route
// All our routes will be available here
final Map<String, WidgetBuilder> routes = {
   ProfileScreen.routeName: (context) => const ProfileScreen(),
  Settings.routeName: (context) => Settings(),
  NotScreen.routeName: (context) => const NotScreen(),
  HelpScreen.routeName: (context) => const HelpScreen(),
};
