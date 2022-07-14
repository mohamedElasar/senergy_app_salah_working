import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:senergy/Navigation/screens.dart';
import 'package:senergy/managers/app_state_manager.dart';
import 'package:senergy/managers/auth_manager.dart';
import 'dart:convert';
import 'dart:async';

import '../../constants.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:badges/badges.dart';

import '../../managers/Har_report_requ.dart';

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
  StreamController _streamController = StreamController();
  Timer? _timer;

  Future getData(String id, String token) async {
    var url = Uri.http('10.0.2.2:5000', '/api/har/actions/reports/count/$id');

    var response = await http.get(
      url,
      headers: {
        'Accept': 'application/json',
        HttpHeaders.authorizationHeader: 'Bearer $token'
      },
    );
    final responseData = json.decode(response.body);

    dynamic count = responseData;

    //Add your data to stream
    _streamController.add(count);
  }

  @override
  void dispose() {
    //cancel the timer
    if (_timer!.isActive) _timer!.cancel();

    super.dispose();
  }

  bool _isloading = false;
  String? id;
  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () async {
      id = Provider.of<Auth_manager>(context, listen: false).userid.toString();
      String token =
          Provider.of<Auth_manager>(context, listen: false).token.toString();
      setState(() {
        _isloading = true;
      });
      getData(id!, token);
      try {
        await Provider.of<HarReport_Manager>(context, listen: false).get_advs();
      } catch (e) {
        print(e);
      }
      setState(() {
        _isloading = false;
      });

      //Check the server every 5 seconds
      _timer =
          Timer.periodic(Duration(seconds: 5), (timer) => getData(id!, token));
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        // backgroundColor: senergyColorb.withOpacity(.),
        body: (StreamBuilder(
          stream: _streamController.stream,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              return Column(
                children: [
                  HomeTopPage(
                    size: size,
                    badgeContent: snapshot.data['count'].toString(),
                    userid: id.toString(),
                  ),
                  const SizedBox(height: 10),
                  _isloading
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : CarouselSlider(
                          options: CarouselOptions(
                            // viewportFraction: .9,
                            autoPlay: true,
                            aspectRatio: 2.0,
                            enlargeCenterPage: true,
                          ),
                          items: Provider.of<HarReport_Manager>(context,
                                  listen: false)
                              .advs!
                              .map((item) => Container(
                                    // padding: EdgeInsets.all(10),
                                    margin: const EdgeInsets.all(5.0),
                                    child: ClipRRect(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(5.0)),
                                        child: Stack(
                                          children: <Widget>[
                                            Image.network(
                                                'http://10.0.2.2:5000/' +
                                                    item.image!,
                                                fit: BoxFit.cover,
                                                width: 1000.0),
                                            // Positioned(
                                            //   bottom: 10,
                                            //   left: 0.0,
                                            //   right: 0.0,
                                            //   child: Container(
                                            //     height: 10,
                                            //     decoration: const BoxDecoration(
                                            //       gradient: LinearGradient(
                                            //         colors: [
                                            //           Colors.black12,
                                            //           Colors.black26
                                            //           // senergyColorb,
                                            //           // senergyColorg,
                                            //         ],
                                            //         begin: Alignment.bottomCenter,
                                            //         end: Alignment.topCenter,
                                            //       ),
                                            //     ),
                                            //     padding: const EdgeInsets.symmetric(
                                            //         vertical: 10.0, horizontal: 20.0),
                                            //     // child: Text(
                                            //     //   item.title,
                                            //     //   style: TextStyle(
                                            //     //     color: Colors.white,
                                            //     //     fontSize: 20.0,
                                            //     //     fontWeight: FontWeight.bold,
                                            //     //   ),
                                            //     // ),
                                            //   ),
                                            // ),
                                          ],
                                        )),
                                  ))
                              .toList(),
                        ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: Container(
                      decoration: const BoxDecoration(
                          color: kbackgroundColor2,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20.0),
                              topRight: Radius.circular(20.0))),
                      // padding: EdgeInsets.only(top: 20, left: 20, right: 20),
                      child: Column(
                        children: [
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              InkWell(
                                child: Choice_container(
                                  hinttext: 'TRIP REQUEST',
                                  color: senergyColorg.withOpacity(0.5),
                                  size: size,
                                  fnc: () {
                                    Provider.of<AppStateManager>(context,
                                            listen: false)
                                        .gototripdetails(true);
                                  },
                                  active: true,
                                ),
                              ),
                              !Provider.of<Auth_manager>(context, listen: false)
                                      .isAdmin!
                                  ? Choice_container(
                                      hinttext: 'TRIPS',
                                      color: senergyColorg.withOpacity(.5),
                                      size: size,
                                      fnc: () {
                                        Provider.of<AppStateManager>(context,
                                                listen: false)
                                            .gotomytrips(true);
                                      },
                                      active: true,
                                    )
                                  : Choice_containerAdmin(
                                      content: snapshot
                                          .data['countTripsNeedApprove']
                                          .toString(),
                                      hinttext: 'TRIPS    ',
                                      color: senergyColorg.withOpacity(.5),
                                      size: size,
                                      fnc: () {
                                        Provider.of<AppStateManager>(context,
                                                listen: false)
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
                                    Provider.of<AppStateManager>(context,
                                            listen: false)
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
                                  Provider.of<AppStateManager>(context,
                                          listen: false)
                                      .gotomyharReports(true);
                                },
                                active: true,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  )
                  // Expanded(
                  //   child: SingleChildScrollView(
                  //     child: Container(
                  //       color: Colors.red,
                  //       child: Column(
                  //         children: [
                  //           const SizedBox(height: 10),
                  //           Row(
                  //             mainAxisAlignment: MainAxisAlignment.center,
                  //             children: [
                  //               InkWell(
                  //                 child: Choice_container(
                  //                   hinttext: 'TRIP REQUEST',
                  //                   color: senergyColorg.withOpacity(0.5),
                  //                   size: size,
                  //                   fnc: () {
                  //                     Provider.of<AppStateManager>(context,
                  //                             listen: false)
                  //                         .gototripdetails(true);
                  //                   },
                  //                   active: true,
                  //                 ),
                  //               ),
                  //               !Provider.of<Auth_manager>(context,
                  //                           listen: false)
                  //                       .isAdmin!
                  //                   ? Choice_container(
                  //                       hinttext: 'TRIPS',
                  //                       color: senergyColorg.withOpacity(.5),
                  //                       size: size,
                  //                       fnc: () {
                  //                         Provider.of<AppStateManager>(context,
                  //                                 listen: false)
                  //                             .gotomytrips(true);
                  //                       },
                  //                       active: true,
                  //                     )
                  //                   : Choice_containerAdmin(
                  //                       content: snapshot
                  //                           .data['countTripsNeedApprove']
                  //                           .toString(),
                  //                       hinttext: 'TRIPS    ',
                  //                       color: senergyColorg.withOpacity(.5),
                  //                       size: size,
                  //                       fnc: () {
                  //                         Provider.of<AppStateManager>(context,
                  //                                 listen: false)
                  //                             .gotomytrips(true);
                  //                       },
                  //                       active: true,
                  //                     ),
                  //             ],
                  //           ),
                  //           const SizedBox(height: 10),
                  //           Row(
                  //             mainAxisAlignment: MainAxisAlignment.center,
                  //             children: [
                  //               InkWell(
                  //                 child: Choice_container(
                  //                   hinttext: 'NEW QHSE',
                  //                   color: senergyColorg.withOpacity(0.5),
                  //                   size: size,
                  //                   fnc: () {
                  //                     Provider.of<AppStateManager>(context,
                  //                             listen: false)
                  //                         .gotohardetails(true);
                  //                   },
                  //                   active: true,
                  //                 ),
                  //               ),
                  //               Choice_container(
                  //                 hinttext: 'QHSE REPORTS',
                  //                 color: senergyColorg.withOpacity(.5),
                  //                 size: size,
                  //                 fnc: () {
                  //                   Provider.of<AppStateManager>(context,
                  //                           listen: false)
                  //                       .gotomyharReports(true);
                  //                 },
                  //                 active: true,
                  //               ),
                  //             ],
                  //           ),
                  //         ],
                  //       ),
                  //     ),
                  //   ),
                  // )
                ],
              );
            }
            return Text('E..');
          },
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

class HomeTopPage extends StatefulWidget {
  const HomeTopPage(
      {Key? key,
      required this.size,
      required this.badgeContent,
      required this.userid})
      : super(key: key);
  final Size size;
  final String badgeContent;
  final String userid;

  @override
  State<HomeTopPage> createState() => _HomeTopPageState();
}

class _HomeTopPageState extends State<HomeTopPage> {
  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 3,
      child: Container(
        color: Colors.white,
        height: widget.size.height * .1,
        width: widget.size.width,
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
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: InkWell(
                  onTap: () async {
                    // await Provider.of<HarReport_Manager>(context, listen: false)
                    //     .get_actions_for_user(widget.userid);
                    Provider.of<AppStateManager>(context, listen: false)
                        .gotomyactions(true);
                  },
                  child: Badge(
                    elevation: 3,
                    position: BadgePosition.topEnd(),
                    shape: BadgeShape.circle,

                    // padding: EdgeInsets.all(20),
                    badgeContent: Text(widget.badgeContent,
                        style: const TextStyle(color: Colors.white)),
                    child: Text(
                        Provider.of<Auth_manager>(context, listen: false)
                                .username!
                                .substring(0) +
                            '   '),
                    animationType: BadgeAnimationType.scale,
                  )),
            )
          ],
        ),
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

class Choice_containerAdmin extends StatelessWidget {
  const Choice_containerAdmin(
      {Key? key,
      required this.size,
      required this.color,
      // required this.value,
      required this.fnc,
      required this.hinttext,
      required this.active,
      this.loading = false,
      this.content})
      : super(key: key);
  final String hinttext;
  final Size size;
  final Color color;

  // final String value;
  final Function() fnc;
  final bool active;
  final bool? loading;
  final String? content;
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
            child: Badge(
              elevation: 3,
              // borderRadius: BorderRadius.zero,
              position: BadgePosition.topEnd(),
              shape: BadgeShape.circle,

              badgeColor: Colors.red,
              badgeContent: Text(
                content!,
                style: TextStyle(color: Colors.white),
              ),
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
      ),
    );
  }
}
