// ignore_for_file: unused_import

import 'package:senergy/Screens/Home/home.dart';
import 'package:senergy/Screens/LogIN/LogIn_Screen.dart';
import 'package:senergy/Screens/MyTrips/my_trips.dart';
import 'package:senergy/Screens/New_HAR/har_details.dart';
import 'package:senergy/Screens/Trip_Details/trip_details.dart';
import 'package:senergy/Screens/Trip_final/trip_final.dart';
import 'package:senergy/managers/trip_manager.dart';

import '../Screens/Action_Final/action_final.dart';
import '../Screens/Actions/actions.dart';
import '../Screens/HAR_Reports/har_reports.dart';
import '../Screens/Har_Final/har_final.dart';
import '../managers/Har_report_requ.dart';
import '../managers/auth_manager.dart';
import 'screens.dart';
import '../managers/app_state_manager.dart';
import 'package:flutter/material.dart';

class AppRouter extends RouterDelegate
    with ChangeNotifier, PopNavigatorRouterDelegateMixin {
  @override
  final GlobalKey<NavigatorState> navigatorKey;

  final AppStateManager appStateManager;
  final Auth_manager authmanager;
  final TripManager tripmanager;

  final HarReport_Manager harreportrequirements;

  AppRouter({
    required this.tripmanager,
    required this.appStateManager,
    required this.authmanager,
    required this.harreportrequirements,
  }) : navigatorKey = GlobalKey<NavigatorState>() {
    authmanager.addListener(notifyListeners);
    appStateManager.addListener(notifyListeners);
    // studentManager.addListener(notifyListeners);
  }

  @override
  void dispose() {
    authmanager.removeListener(notifyListeners);
    appStateManager.removeListener(notifyListeners);
    // studentManager.removeListener(notifyListeners);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      onPopPage: _handlePopPage,
      pages: [
        if (!authmanager.isLoggedIn) Login_Screen.page(),
        if (authmanager.isLoggedIn) Home.page(),
        if (authmanager.isLoggedIn && appStateManager.tripdetails == true)
          TripDetails.page(),
        if (authmanager.isLoggedIn && appStateManager.hardetails == true)
          HarDetails.page(),
        if (authmanager.isLoggedIn && appStateManager.mytrips == true)
          MyTrips.page(isadmin: authmanager.isAdmin!),
        if (authmanager.isLoggedIn &&
            appStateManager.mytrips == true &&
            appStateManager.singletrip == true)
          TripFinal.page(
              tripid: appStateManager.tripId, isadmin: authmanager.isAdmin!),
        if (authmanager.isLoggedIn && appStateManager.harreports == true)
          HarReports.page(isadmin: authmanager.isAdmin!),
        if (authmanager.isLoggedIn && appStateManager.harreportsactions == true)
          ActionsPage.page(isadmin: authmanager.isAdmin!),
        if (authmanager.isLoggedIn &&
            appStateManager.harreports == true &&
            appStateManager.singlehar == true)
          HarFinal.page(
              harid: appStateManager.harId, isadmin: authmanager.isAdmin!),
        if (authmanager.isLoggedIn &&
            appStateManager.harreportsactions == true &&
            appStateManager.singleaction == true)
          ActionFInal.page(
              actionid: appStateManager.actionId,
              isadmin: authmanager.isAdmin!),
      ],
    );
  }

  bool _handlePopPage(Route<dynamic> route, result) {
    if (!route.didPop(result)) {
      return false;
    }
    if (route.settings.name == Senergy_Screens.tripdetails) {
      appStateManager.gototripdetails(false);
    }
    if (route.settings.name == Senergy_Screens.hardetails) {
      appStateManager.gotohardetails(false);
    }
    if (route.settings.name == Senergy_Screens.mytrips) {
      appStateManager.gotomytrips(false);
    }
    if (route.settings.name == Senergy_Screens.harreports) {
      appStateManager.gotomyharReports(false);
    }
    if (route.settings.name == Senergy_Screens.actions) {
      appStateManager.gotomyactions(false);
    }
    if (route.settings.name == Senergy_Screens.tripfinal) {
      appStateManager.gotomysingletrips(false, 1);
    }
    if (route.settings.name == Senergy_Screens.harfinal) {
      appStateManager.gotomysinglehar(false, 1);
      appStateManager.clearaction();
      appStateManager.clearactoin();
    }
    if (route.settings.name == Senergy_Screens.actionfinal) {
      appStateManager.gotomysingleaction(false, 1);
      appStateManager.clearaction();
      appStateManager.clearactoin();
    }
    return true;
  }

  @override
  Future<void> setNewRoutePath(configuration) async => null;
}
