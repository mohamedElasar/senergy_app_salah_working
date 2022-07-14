import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:senergy/Navigation/screens.dart';
import 'package:senergy/Screens/Trip_final/final_checklist.dart';
import 'package:senergy/managers/app_state_manager.dart';
import 'package:senergy/managers/trip_manager.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../constants.dart';
import '../../httpexception.dart';
import 'package:senergy/managers/auth_manager.dart';

class TripFinal extends StatefulWidget {
  // ignore: non_constant_identifier_names
  final int? trip_id;
  final bool? isadmin;
  static MaterialPage page({required int tripid, required bool isadmin}) {
    return MaterialPage(
      name: Senergy_Screens.tripfinal,
      key: ValueKey(Senergy_Screens.tripfinal),
      child: TripFinal(
        trip_id: tripid,
        isadmin: isadmin,
      ),
    );
  }

  // ignore: non_constant_identifier_names
  const TripFinal({Key? key, this.trip_id, this.isadmin}) : super(key: key);

  @override
  State<TripFinal> createState() => _TripFinalState();
}

var _isloading = true;
var colors = [
  kbackgroundColor2.withOpacity(1),
  kbackgroundColor2.withOpacity(1),
];

var text_colors = [Colors.black, Colors.black];

class _TripFinalState extends State<TripFinal> {
  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () async {
      setState(() {
        _isloading = true;
      });
      // Provider.of<TripManager>(context, listen: false).resetlist();
      try {
        await Provider.of<TripManager>(context, listen: false)
            .get_single_trips(widget.trip_id!)
            .then((_) {
          // print(Provider.of<TripManager>(context, listen: false)
          //     .single_trip!
          //     .isApproved);
          setState(() {
            _isloading = false;
          });
        });
      } catch (e) {}
      if (!mounted) return;

      // _sc.addListener(() {
      //   if (_sc.position.pixels == _sc.position.maxScrollExtent) {
      //     Provider.of<GroupManager>(context, listen: false).getMoreData();
      //   }
      // });
    });
  }

  bool _isLoading = false;
  void _danger() async {
    // print('asdasdasd');
    setState(() {
      _isLoading = true;
    });
    try {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red[300],
          content: const Text(
            'DANGER ALARM SENT',
            style: TextStyle(fontFamily: 'AraHamah1964R-Bold'),
          ),
          duration: const Duration(seconds: 3),
        ),
      );
      await Provider.of<TripManager>(context, listen: false)
          .danger_single_trips(widget.trip_id!)
          .then((value) => Provider.of<Auth_manager>(context, listen: false)
              .sendNotification('DANGER', 'NEED YOUR HELP'));
    } on HttpException catch (error) {
      // _showErrorDialog(error.toString());
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.black26,
          content: Text(
            error.toString(),
            style: const TextStyle(fontFamily: 'AraHamah1964R-Bold'),
          ),
          duration: const Duration(seconds: 3),
        ),
      );
    } catch (error) {
      print(error.toString());
      // const errorMessage = 'Try again later';
      // _showErrorDialog(errorMessage);
    }
    if (!mounted) return;

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    print(_isLoading);
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            'Trip Details',
            style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                fontFamily: 'AraHamah1964B-Bold',
                color: senergyColorb),
          ),
        ),
        elevation: 2,
        leading: InkWell(
          onTap: () {
            Provider.of<AppStateManager>(context, listen: false)
                .gotomysingletrips(false, 1);
          },
          child: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.grey[350],
      body: _isloading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(children: [
                Consumer<TripManager>(
                  builder: (builder, tripManager, child) => tripManager
                          .trips!.isEmpty
                      ? const Padding(
                          padding: EdgeInsets.all(20.0),
                          child: Text(
                            'NO TRIPS',
                            style: TextStyle(fontFamily: 'AraHamah1964R-Bold'),
                          ),
                        )
                      : Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 6, horizontal: 2),
                              child: Material(
                                color: kbackgroundColor2.withOpacity(.5),
                                child: ListTile(
                                    trailing: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        CircleAvatar(
                                          child: const Text('A'),
                                          backgroundColor: tripManager
                                                  .single_trip!.isApproved!
                                              ? Colors.green
                                              : Colors.red,
                                          radius: 10,
                                        ),
                                        CircleAvatar(
                                          backgroundColor:
                                              tripManager.single_trip!.isClosed!
                                                  ? Colors.green
                                                  : Colors.red,
                                          radius: 10,
                                          child: const Text('C'),
                                        ),
                                      ],
                                    ),
                                    subtitle: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          tripManager.single_trip!
                                                      .userProfile ==
                                                  null
                                              ? ''
                                              : tripManager.single_trip!
                                                  .userProfile!.name!,
                                          style: const TextStyle(
                                              color: Colors.black,
                                              fontFamily: 'AraHamah1964R-Bold'),
                                        ),
                                        Text(
                                          tripManager.single_trip!.passengers ??
                                              '',
                                          style: const TextStyle(
                                              color: Colors.black,
                                              fontFamily: 'AraHamah1964R-Bold'),
                                        ),
                                        Row(
                                          children: [
                                            Column(children: [
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      const Text(
                                                        'Vehicle',
                                                        style: TextStyle(
                                                            color:
                                                                senergyColorb,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontFamily:
                                                                'AraHamah1964R-Bold'),
                                                      ),
                                                      const SizedBox(
                                                        width: 20,
                                                      ),
                                                      Text(
                                                        tripManager.single_trip!
                                                                    .car ==
                                                                null
                                                            ? ''
                                                            : tripManager
                                                                .single_trip!
                                                                .car!
                                                                .name!,
                                                        style: const TextStyle(
                                                            color: Colors.black,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontFamily:
                                                                'AraHamah1964R-Bold'),
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      const Text(
                                                        'Purpose',
                                                        style: TextStyle(
                                                            color:
                                                                senergyColorb,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontFamily:
                                                                'AraHamah1964R-Bold'),
                                                      ),
                                                      const SizedBox(
                                                        width: 20,
                                                      ),
                                                      Text(
                                                        tripManager.single_trip!
                                                                    .purpose ==
                                                                null
                                                            ? ''
                                                            : tripManager
                                                                .single_trip!
                                                                .purpose!
                                                                .name!,
                                                        style: const TextStyle(
                                                            color: Colors.black,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontFamily:
                                                                'AraHamah1964R-Bold'),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                              Container(
                                                margin:
                                                    const EdgeInsets.all(6.0),
                                                padding:
                                                    const EdgeInsets.all(3.0),
                                                decoration: BoxDecoration(
                                                    border: Border.all(
                                                        color: senergyColorb
                                                            .withOpacity(.3))),
                                                child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Text(
                                                        tripManager.single_trip!
                                                                    .startUnixTime ==
                                                                null
                                                            ? ''
                                                            : DateTime.fromMillisecondsSinceEpoch(
                                                                    tripManager
                                                                        .single_trip!
                                                                        .startUnixTime!)
                                                                .toString()
                                                                .substring(
                                                                    0,
                                                                    tripManager
                                                                            .single_trip!
                                                                            .startUnixTime!
                                                                            .toString()
                                                                            .length +
                                                                        3)
                                                                .replaceAll(
                                                                    RegExp(' '),
                                                                    ' , '),
                                                        style: const TextStyle(
                                                            // color: text_colors[
                                                            //     Index %
                                                            //         colors
                                                            //             .length],
                                                            fontFamily:
                                                                'AraHamah1964R-Bold'),
                                                      ),
                                                    ]),
                                              ),
                                              const Text('to'),
                                              Container(
                                                margin:
                                                    const EdgeInsets.all(6.0),
                                                padding:
                                                    const EdgeInsets.all(3.0),
                                                decoration: BoxDecoration(
                                                    color: DateTime.now()
                                                                    .toUtc()
                                                                    .millisecondsSinceEpoch >
                                                                tripManager
                                                                    .single_trip!
                                                                    .endUnixTime! &&
                                                            !tripManager
                                                                .single_trip!
                                                                .isClosed!
                                                        ? const Color.fromARGB(
                                                            255, 255, 209, 206)
                                                        : null,
                                                    border: Border.all(
                                                        color: senergyColorb
                                                            .withOpacity(.3))),
                                                child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Text(
                                                        tripManager.single_trip!
                                                                    .endUnixTime ==
                                                                null
                                                            ? ''
                                                            : DateTime.fromMillisecondsSinceEpoch(
                                                                    tripManager
                                                                        .single_trip!
                                                                        .endUnixTime!)
                                                                .toString()
                                                                .substring(
                                                                    0,
                                                                    tripManager
                                                                            .single_trip!
                                                                            .endUnixTime!
                                                                            .toString()
                                                                            .length +
                                                                        3)
                                                                .replaceAll(
                                                                    RegExp(' '),
                                                                    ' , '),
                                                        style: const TextStyle(
                                                            // color: text_colors[
                                                            //     Index %
                                                            //         colors
                                                            //             .length],
                                                            fontFamily:
                                                                'AraHamah1964R-Bold'),
                                                      ),
                                                    ]),
                                              ),

                                              //  Icon(
                                              //   Icons.cancel_outlined,
                                              //   color: Colors.red,
                                              //   size: 30,
                                              // ),
                                            ]),
                                            const Spacer(),
                                            if (widget.isadmin!)
                                              TextButton(
                                                style: ButtonStyle(
                                                  foregroundColor:
                                                      MaterialStateProperty.all<
                                                          Color>(Colors.white),
                                                  backgroundColor:
                                                      MaterialStateProperty.all<
                                                          Color>(Colors.green),
                                                  overlayColor:
                                                      MaterialStateProperty
                                                          .resolveWith<
                                                              Color?>((Set<
                                                                  MaterialState>
                                                              states) {
                                                    if (states.contains(
                                                        MaterialState
                                                            .focused)) {
                                                      return Colors.red;
                                                    }
                                                    return null; // Defer to the widget's default.
                                                  }),
                                                ),
                                                onPressed: () {
                                                  launch(
                                                      "tel://${tripManager.single_trip!.phone!.toString()}");
                                                },
                                                child: const Icon(Icons.call),
                                              ),
                                            if (!widget.isadmin!)
                                              TextButton(
                                                style: ButtonStyle(
                                                  foregroundColor:
                                                      MaterialStateProperty.all<
                                                          Color>(Colors.white),
                                                  backgroundColor:
                                                      MaterialStateProperty.all<
                                                          Color>(Colors.red),
                                                  overlayColor:
                                                      MaterialStateProperty
                                                          .resolveWith<
                                                              Color?>((Set<
                                                                  MaterialState>
                                                              states) {
                                                    if (states.contains(
                                                        MaterialState
                                                            .focused)) {
                                                      return Colors.red;
                                                    }
                                                    return null; // Defer to the widget's default.
                                                  }),
                                                ),
                                                onPressed: _danger,
                                                child: const Icon(
                                                    Icons.ring_volume),
                                              )
                                          ],
                                        )

                                        // Row(children: [
                                        //   Container(
                                        //     margin: const EdgeInsets.all(6.0),
                                        //     padding: const EdgeInsets.all(3.0),
                                        //     decoration: BoxDecoration(
                                        //         border: Border.all(
                                        //             color: senergyColorb
                                        //                 .withOpacity(.3))),
                                        //     child: Column(
                                        //         mainAxisAlignment:
                                        //             MainAxisAlignment.center,
                                        //         children: [
                                        //           Text(
                                        //             tripManager.single_trip!
                                        //                         .driverName ==
                                        //                     null
                                        //                 ? ''
                                        //                 : tripManager
                                        //                     .single_trip!
                                        //                     .startTime!,
                                        //             style: const TextStyle(
                                        //                 fontSize: 20,
                                        //                 color: Colors.black,
                                        //                 fontFamily:
                                        //                     'AraHamah1964R-Regular'),
                                        //           ),
                                        //           Text(
                                        //             tripManager.single_trip!
                                        //                         .startday ==
                                        //                     null
                                        //                 ? ''
                                        //                 : tripManager
                                        //                     .single_trip!
                                        //                     .startday!,
                                        //             style: const TextStyle(
                                        //                 color: Colors.black,
                                        //                 fontFamily:
                                        //                     'AraHamah1964R-Bold'),
                                        //           ),
                                        //         ]),
                                        //   ),
                                        //   const Text('-'),
                                        //   Container(
                                        //     margin: const EdgeInsets.all(6.0),
                                        //     padding: const EdgeInsets.all(3.0),
                                        //     decoration: BoxDecoration(
                                        //         border: Border.all(
                                        //             color: senergyColorb
                                        //                 .withOpacity(.3))),
                                        //     child: Column(
                                        //         mainAxisAlignment:
                                        //             MainAxisAlignment.center,
                                        //         children: [
                                        //           Text(
                                        //             tripManager.single_trip!
                                        //                         .driverName ==
                                        //                     null
                                        //                 ? ''
                                        //                 : tripManager
                                        //                     .single_trip!
                                        //                     .eArrivalTime!,
                                        //             style: const TextStyle(
                                        //                 fontSize: 20,
                                        //                 color: Colors.black,
                                        //                 fontFamily:
                                        //                     'AraHamah1964R-Regular'),
                                        //           ),
                                        //           Text(
                                        //             tripManager.single_trip!
                                        //                         .startday ==
                                        //                     null
                                        //                 ? ''
                                        //                 : tripManager
                                        //                     .single_trip!
                                        //                     .eArrivalday!,
                                        //             style: const TextStyle(
                                        //                 color: Colors.black,
                                        //                 fontFamily:
                                        //                     'AraHamah1964R-Bold'),
                                        //           ),
                                        //         ]),
                                        //   ),
                                        //   const Spacer(),
                                        //   if (widget.isadmin!)
                                        //     TextButton(
                                        //       style: ButtonStyle(
                                        //         foregroundColor:
                                        //             MaterialStateProperty.all<
                                        //                 Color>(Colors.white),
                                        //         backgroundColor:
                                        //             MaterialStateProperty.all<
                                        //                 Color>(Colors.green),
                                        //         overlayColor:
                                        //             MaterialStateProperty
                                        //                 .resolveWith<Color?>(
                                        //                     (Set<MaterialState>
                                        //                         states) {
                                        //           if (states.contains(
                                        //               MaterialState.focused)) {
                                        //             return Colors.red;
                                        //           }
                                        //           return null; // Defer to the widget's default.
                                        //         }),
                                        //       ),
                                        //       onPressed: () {
                                        //         launch(
                                        //             "tel://${tripManager.single_trip!.phone!.toString()}");
                                        //       },
                                        //       child: const Icon(Icons.call),
                                        //     ),
                                        //   if (!widget.isadmin!)
                                        //     TextButton(
                                        //       style: ButtonStyle(
                                        //         foregroundColor:
                                        //             MaterialStateProperty.all<
                                        //                 Color>(Colors.white),
                                        //         backgroundColor:
                                        //             MaterialStateProperty.all<
                                        //                 Color>(Colors.red),
                                        //         overlayColor:
                                        //             MaterialStateProperty
                                        //                 .resolveWith<Color?>(
                                        //                     (Set<MaterialState>
                                        //                         states) {
                                        //           if (states.contains(
                                        //               MaterialState.focused)) {
                                        //             return Colors.red;
                                        //           }
                                        //           return null; // Defer to the widget's default.
                                        //         }),
                                        //       ),
                                        //       onPressed: _danger,
                                        //       child:
                                        //           const Icon(Icons.ring_volume),
                                        //     )
                                        // ])
                                      ],
                                    ),
                                    title: Row(
                                      children: [
                                        Text(
                                          tripManager.single_trip!.from!,
                                          style: const TextStyle(
                                              color: senergyColorg,
                                              // text_colors[
                                              //     Index % colors.length],
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'AraHamah1964R-Bold'),
                                        ),
                                        const Text(' - '),
                                        Text(
                                          tripManager.single_trip!.to!,
                                          style: const TextStyle(
                                              color: senergyColorg,
                                              //  text_colors[
                                              //     Index % colors.length],
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'AraHamah1964R-Bold'),
                                        ),
                                      ],
                                    )),
                              ),
                            ),
                            FinalChecklist(
                              tirepressure:
                                  tripManager.single_trip!.tirepressure!,
                              wear: tripManager.single_trip!.wear!,
                              walldamage: tripManager.single_trip!.walldamage!,
                              dust: tripManager.single_trip!.dust!,
                              wheel: tripManager.single_trip!.wheel!,
                              spare: tripManager.single_trip!.spare!,
                              jack: tripManager.single_trip!.jack!,
                              roadside: tripManager.single_trip!.roadside!,
                              flash: tripManager.single_trip!.flash!,
                              engine: tripManager.single_trip!.engine!,
                              brake: tripManager.single_trip!.brake!,
                              gear: tripManager.single_trip!.gear!,
                              clutch: tripManager.single_trip!.clutch!,
                              washer: tripManager.single_trip!.washer!,
                              radiator: tripManager.single_trip!.radiator!,
                              battery: tripManager.single_trip!.battery!,
                              terminals: tripManager.single_trip!.terminals!,
                              belts: tripManager.single_trip!.belts!,
                              fans: tripManager.single_trip!.fans!,
                              ac: tripManager.single_trip!.ac!,
                              rubber: tripManager.single_trip!.rubber!,
                              leakage: tripManager.single_trip!.leakage!,
                              driver: tripManager.single_trip!.driver!,
                              vehicle: tripManager.single_trip!.vehicle!,
                              passes: tripManager.single_trip!.passes!,
                              fuel: tripManager.single_trip!.fuel!,
                              scaba: tripManager.single_trip!.scaba!,
                              extinguishers:
                                  tripManager.single_trip!.extinguishers!,
                              first: tripManager.single_trip!.first!,
                              seat: tripManager.single_trip!.seat!,
                              drinking: tripManager.single_trip!.drinking!,
                              head: tripManager.single_trip!.head!,
                              back: tripManager.single_trip!.back!,
                              side: tripManager.single_trip!.side!,
                              interior: tripManager.single_trip!.interior!,
                              warning: tripManager.single_trip!.warning!,
                              brakelights:
                                  tripManager.single_trip!.brakelights!,
                              turn: tripManager.single_trip!.turn!,
                              reverse: tripManager.single_trip!.reverse!,
                              windscreen: tripManager.single_trip!.windscreen!,
                              air: tripManager.single_trip!.air!,
                              couplings: tripManager.single_trip!.couplings!,
                              winch: tripManager.single_trip!.winch!,
                              horn: tripManager.single_trip!.horn!,
                              secured: tripManager.single_trip!.secured!,
                              clean: tripManager.single_trip!.clean!,
                              left: tripManager.single_trip!.left!,
                              right: tripManager.single_trip!.right!,
                              notes: tripManager.single_trip!.notes!,
                              tripid: tripManager.single_trip!.id!,
                              closed: tripManager.single_trip!.isClosed!,
                              closedat: tripManager.single_trip!.isClosedAt,
                              isadmin: widget.isadmin!,
                              isapproved: tripManager.single_trip!.isApproved!,
                            )
                          ],
                        ),
                ),
              ]),
            ),
    ));
  }
}
