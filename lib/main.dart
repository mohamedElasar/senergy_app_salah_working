// ignore_for_file: unused_field

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:senergy/Screens/splashScreen/splash_screen.dart';
import 'package:senergy/managers/Har_report_requ.dart';
import './managers/auth_manager.dart';
import './managers/trip_manager.dart';
import 'Navigation/app_router.dart';
import 'managers/app_state_manager.dart';
import 'managers/har_text_manager.dart';
import 'managers/trip_text_manager.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'firebase_options.dart';

Future<void> _messageHandler(RemoteMessage message) async {
  // print('background message ${message.notification!.body}');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseMessaging.onBackgroundMessage(_messageHandler);
  FirebaseMessaging.onMessageOpenedApp.listen((message) {
    // print('Message clicked!');
    FirebaseMessaging.onMessage.listen((RemoteMessage event) {
      // Provider.of<AppStateManager>(context,)
      // print("message recieved");
      // print(event.notification!.body);
      // print(event.data.values);
    });
  });
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(new MyApp());
  });
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  final _appStateManager = AppStateManager();
  // ignore: non_constant_identifier_names
  final _auth_Manager = Auth_manager();
  // ignore: non_constant_identifier_names
  final _trip_manager = TripManager();

  final _harreportrequirements = HarReport_Manager();

  AppRouter GetRouter() {
    return AppRouter(
      appStateManager: _appStateManager,
      authmanager: _auth_Manager,
      tripmanager: _trip_manager,
      harreportrequirements: _harreportrequirements,
    );
  }

  late final Future? myFuture = _auth_Manager.tryAutoLogin();

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => _appStateManager),
        // ChangeNotifierProvider(create: (context) => TripTextManager()),
        ChangeNotifierProvider(create: (context) => _auth_Manager),
        ChangeNotifierProxyProvider<Auth_manager, TripManager>(
          create: (ctx) => _trip_manager,
          update: (ctx, auth, prevtrip) => prevtrip!
            // ignore: unnecessary_null_comparison
            ..receiveToken(auth, prevtrip == null ? [] : prevtrip.trips!),
        ),
        ChangeNotifierProxyProvider<Auth_manager, HarReport_Manager>(
          create: (ctx) => _harreportrequirements,
          update: (ctx, auth, prevtrip) => prevtrip!
            // ignore: unnecessary_null_comparison
            ..receiveToken(auth, prevtrip == null ? [] : prevtrip.data!),
        ),
        ChangeNotifierProvider(create: (context) => TripTextManager()),
        ChangeNotifierProvider(create: (context) => HarTextManager()),
      ],
      child: Consumer<Auth_manager>(
        builder: (ctx, auth, _) => MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: FutureBuilder(
            future: myFuture,
            builder: (context, datasnapshot) =>
                datasnapshot.connectionState == ConnectionState.waiting
                    ? const SplashScreen()
                    : Router(
                        routerDelegate: GetRouter(),
                        backButtonDispatcher: RootBackButtonDispatcher(),
                      ),
          ),
        ),
      ),
    );
  }
}
