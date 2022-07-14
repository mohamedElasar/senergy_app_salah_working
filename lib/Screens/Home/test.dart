import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:senergy/Navigation/screens.dart';
import 'package:senergy/managers/app_state_manager.dart';
import 'package:senergy/managers/auth_manager.dart';

import '../../constants.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:io';

final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);
  static MaterialPage page() {
    return MaterialPage(
      name: Senergy_Screens.homepath,
      key: ValueKey(Senergy_Screens.homepath),
      child: const Home(),
    );
  }

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        resizeToAvoidBottomInset: false,
        backgroundColor: kbackgroundColor2,
        body: (Column(
          children: [
            HomeTopPage(
              size: size,
            ),
            SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        child: Choice_container(
                          hinttext: 'TRIP REQUEST',
                          color: senergyColorg.withOpacity(0.5),
                          size: size,
                          fnc: () {
                            Provider.of<AppStateManager>(context, listen: false)
                                .gototripdetails(true);
                          },
                          active: true,
                        ),
                      ),
                      Choice_container(
                        hinttext: 'TRIPS',
                        color: senergyColorg.withOpacity(.5),
                        size: size,
                        fnc: () {
                          Provider.of<AppStateManager>(context, listen: false)
                              .gotomytrips(true);
                        },
                        active: true,
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        child: Choice_container(
                          hinttext: 'NEW QHSE',
                          color: senergyColorg.withOpacity(0.5),
                          size: size,
                          fnc: () {
                            Provider.of<AppStateManager>(context, listen: false)
                                .gotohardetails(true);
                          },
                          active: true,
                        ),
                      ),
                      Choice_container(
                        hinttext: 'QHSE REPORTS',
                        color: senergyColorg.withOpacity(.5),
                        size: size,
                        fnc: () {
                          Provider.of<AppStateManager>(context, listen: false)
                              .gotomyharReports(true);
                        },
                        active: true,
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
        )),
        drawer: Drawer(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    image: DecorationImage(
                      fit: BoxFit.scaleDown,
                      image: AssetImage(
                        'assets/images/senergy.png',
                      ),
                    ),
                  ),
                  height: 200,
                ),
              ),
              Expanded(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: <Widget>[
                    ListTile(
                      onTap: () {
                        Provider.of<AppStateManager>(context, listen: false)
                            .gototripdetails(true);
                      },
                      title: Padding(
                        padding: const EdgeInsets.all(1.0),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(5)),
                            border: Border.all(
                              color: senergyColorg,
                              width: 0.7,
                            ),
                          ),
                          height: 40,
                          child: Material(
                            // elevation: 5.0,
                            borderRadius: BorderRadius.circular(5.0),
                            child: const Center(
                              child: Text(
                                "Journy Request",
                                style: TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'AraHamah1964B-Bold',
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    ListTile(
                      title: Padding(
                        padding: const EdgeInsets.all(1.0),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(5)),
                            border: Border.all(
                              color: senergyColorg,
                              width: 0.7,
                            ),
                          ),
                          height: 40,
                          child: Material(
                            // elevation: 5.0,
                            borderRadius: BorderRadius.circular(5.0),
                            child: const Center(
                              child: Text(
                                "Trips",
                                style: TextStyle(
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'AraHamah1964B-Bold'),
                              ),
                            ),
                          ),
                        ),
                      ),
                      onTap: () {
                        Provider.of<AppStateManager>(context, listen: false)
                            .gotomytrips(true);
                      },
                    ),
                    ListTile(
                      title: Padding(
                        padding: const EdgeInsets.all(1.0),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.all(
                              Radius.circular(5),
                            ),
                            border: Border.all(
                              color: senergyColorg,
                              width: 0.7,
                            ),
                          ),
                          height: 40,
                          child: Material(
                            // elevation: 5.0,
                            borderRadius: BorderRadius.circular(5.0),
                            child: const Center(
                              child: Text(
                                "LOGOUT",
                                style: TextStyle(
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'AraHamah1964B-Bold'),
                              ),
                            ),
                          ),
                        ),
                      ),
                      onTap: () {
                        Provider.of<Auth_manager>(context, listen: false)
                            .logout();
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class HomeTopPage extends StatelessWidget {
  const HomeTopPage({Key? key, required this.size}) : super(key: key);
  final Size size;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      height: size.height * .1,
      width: size.width,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            onTap: () {
              _scaffoldKey.currentState!.openDrawer();
            },
            child: const Icon(
              Icons.menu,
              size: 30,
            ),
          ),
          const Text(
            'HOME',
            style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                fontFamily: 'AraHamah1964B-Bold',
                color: senergyColorb),
          ),
          InkWell(
            onTap: () async {
              // await showSearch(context: context, delegate: StudentSearch());
            },
            child: Row(
              children: [
                const Text('welcome ', style: TextStyle(color: senergyColorb)),
                Text(
                  Provider.of<Auth_manager>(context, listen: false)
                      .username!
                      .substring(0),
                  style: const TextStyle(
                      // fontFamily: 'GE-light',
                      color: senergyColorb,
                      fontSize: 15),
                ),
                // InkWell(
                //   onTap: () {},
                //   child: const Icon(
                //     Icons.search,
                //     size: 20,
                //     color: Colors.black87,
                //   ),
                // ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

// ignore: camel_case_types
class Choice_container extends StatelessWidget {
  const Choice_container(
      {Key? key,
      required this.size,
      required this.color,
      // required this.value,
      required this.fnc,
      required this.hinttext,
      required this.active,
      this.loading = false})
      : super(key: key);
  final String hinttext;
  final Size size;
  final Color color;

  // final String value;
  final Function() fnc;
  final bool active;
  final bool? loading;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(right: 6),
      margin: const EdgeInsets.all(1),
      alignment: Alignment.center,
      height: size.height * .6 * .14,
      // height: 40,
      width: size.width * .45,
      decoration: BoxDecoration(
        color: active ? color : color.withOpacity(.5),
        borderRadius: BorderRadius.circular(10),
      ),
      child: InkWell(
        onTap: active ? () => fnc() : null,
        child: SizedBox(
          width: size.width * .35,
          child: Center(
            child: Text(
              hinttext,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              softWrap: false,
              style: TextStyle(
                  fontFamily: 'AraHamah1964B-Bold',
                  fontSize: 25,
                  color: active ? Colors.black : Colors.black26),
            ),
          ),
        ),
      ),
    );
  }
}
