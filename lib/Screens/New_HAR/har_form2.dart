import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:senergy/Screens/Trip_final/trip_final.dart';
import 'package:senergy/constants.dart';
import 'package:senergy/managers/auth_manager.dart';
import 'package:senergy/managers/har_text_manager.dart';
import 'package:senergy/managers/trip_text_manager.dart';

import '../../managers/Har_report_requ.dart';

class HarForm2 extends StatefulWidget {
  const HarForm2({Key? key, this.size}) : super(key: key);
  final size;
  @override
  State<HarForm2> createState() => _HarForm2State();
}

class _HarForm2State extends State<HarForm2> {
  Map<String, dynamic> _register_data = {};
  final focus1 = FocusNode();
  final focus2 = FocusNode();
  final focus3 = FocusNode();
  final focus4 = FocusNode();
  final focus5 = FocusNode();
  final focus6 = FocusNode();
  var driver_name_controller = TextEditingController();
  var car_number_controller = TextEditingController();
  var passengers_controller = TextEditingController();
  var from_controller = TextEditingController();
  var to_controller = TextEditingController();
  var phone_controller = TextEditingController();

  List<String> weekdays = [
    'SAT',
    'SUN',
    'MON',
    'TUE',
    'WED',
    'THU',
    'FRI',
  ];
  TimeOfDay _timeStart = TimeOfDay.now();
  TimeOfDay _timeEnd = TimeOfDay.now();

  void _selectTimeStart(context) async {
    final localizations = MaterialLocalizations.of(context);

    final TimeOfDay? newTime = await showTimePicker(
      context: context,
      initialTime: _timeStart,
    );
    if (newTime != null) {
      setState(() {
        _timeStart = newTime;
      });
    }
    Provider.of<TripTextManager>(context, listen: false)
        .setstart_clock(localizations.formatTimeOfDay(newTime!));
  }

  void _selectTimeEnd(context) async {
    final localizations = MaterialLocalizations.of(context);

    final TimeOfDay? newTime = await showTimePicker(
      context: context,
      initialTime: _timeEnd,
    );
    if (newTime != null) {
      setState(() {
        _timeEnd = newTime;
      });
      Provider.of<TripTextManager>(context, listen: false)
          .setend_clock(localizations.formatTimeOfDay(newTime));
    }
  }

  // ignore: prefer_final_fields
  Map<String, dynamic> _data = {'day_start': null, 'day_arrival': null};

  void _modalBottomSheet_location(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (builder) {
          return Container(
            height: 250.0,
            color: Colors.transparent,
            child: Column(
              children: [
                Consumer<HarTextManager>(
                  builder: (context, hartextmanager, child) => Container(
                    height: 40,
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: senergyColorg,
                    ),
                    child: const Center(
                        child: Text(
                      'Locations',
                      style: TextStyle(
                          fontSize: 20,
                          fontFamily: 'GE-bold',
                          color: Colors.white),
                    )),
                  ),
                ),
                Expanded(
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                    ),
                    child: Consumer<HarReport_Manager>(
                      builder: (_, harmanager, child) {
                        if (harmanager.report_location!.isEmpty) {
                          return const Center(child: Text('No Locations'));
                        } else {
                          return ListView.builder(
                            itemCount: harmanager.report_location!.length,
                            itemBuilder: (BuildContext ctxt, int index) {
                              return ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.white, // background
                                  onPrimary: Colors.white, // foreground
                                ),
                                onPressed: () {
                                  Provider.of<HarTextManager>(context,
                                          listen: false)
                                      .set_har_location(
                                          harmanager.report_location![index]);

                                  Navigator.pop(context);
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      harmanager.report_location![index].name
                                          .toString(),
                                      style: const TextStyle(
                                          color: Colors.black,
                                          fontFamily: 'AraHamah1964R-Bold'),
                                    )
                                  ],
                                ),
                              );
                            },
                          );
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }

  void _modalBottomSheet_segment(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (builder) {
          return Container(
            height: 250.0,
            color: Colors.transparent,
            child: Column(
              children: [
                Consumer<HarTextManager>(
                  builder: (context, hartextmanager, child) => Container(
                    height: 40,
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: senergyColorg,
                    ),
                    child: const Center(
                        child: Text(
                      'Segments',
                      style: TextStyle(
                          fontSize: 20,
                          fontFamily: 'GE-bold',
                          color: Colors.white),
                    )),
                  ),
                ),
                Expanded(
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                    ),
                    child: Consumer<HarReport_Manager>(
                      builder: (_, harmanager, child) {
                        if (harmanager.report_location!.isEmpty) {
                          return const Center(child: Text('No departments'));
                        } else {
                          return ListView.builder(
                            itemCount: harmanager.report_location!.length,
                            itemBuilder: (BuildContext ctxt, int index) {
                              return ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.white, // background
                                  onPrimary: Colors.white, // foreground
                                ),
                                onPressed: () {
                                  Provider.of<HarTextManager>(context,
                                          listen: false)
                                      .set_har_department(
                                          harmanager.report_department![index]);

                                  Navigator.pop(context);
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      harmanager.report_department![index]
                                          .departmentName
                                          .toString(),
                                      style: const TextStyle(
                                          color: Colors.black,
                                          fontFamily: 'AraHamah1964R-Bold'),
                                    )
                                  ],
                                ),
                              );
                            },
                          );
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }

  void _modalBottomSheet_har_type(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (builder) {
          return Container(
            height: 250.0,
            color: Colors.transparent,
            child: Column(
              children: [
                Consumer<HarTextManager>(
                  builder: (context, hartextmanager, child) => Container(
                    height: 40,
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: senergyColorg,
                    ),
                    child: const Center(
                        child: Text(
                      'Report Type',
                      style: TextStyle(
                          fontSize: 20,
                          fontFamily: 'GE-bold',
                          color: Colors.white),
                    )),
                  ),
                ),
                Expanded(
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                    ),
                    child: Consumer<HarReport_Manager>(
                      builder: (_, harmanager, child) {
                        if (harmanager.report_har_types!.isEmpty) {
                          return const Center(child: Text('No types'));
                        } else {
                          return ListView.builder(
                            itemCount: harmanager.report_har_types!.length,
                            itemBuilder: (BuildContext ctxt, int index) {
                              return ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.white, // background
                                  onPrimary: Colors.white, // foreground
                                ),
                                onPressed: () {
                                  Provider.of<HarTextManager>(context,
                                          listen: false)
                                      .set_har_report_type(
                                          harmanager.report_har_types![index]);

                                  Navigator.pop(context);
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      harmanager.report_har_types![index].type
                                          .toString(),
                                      style: const TextStyle(
                                          color: Colors.black,
                                          fontFamily: 'AraHamah1964R-Bold'),
                                    )
                                  ],
                                ),
                              );
                            },
                          );
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }

  void _modalBottomSheet_har_type_(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (builder) {
          return Container(
            height: 250.0,
            color: Colors.transparent,
            child: Column(
              children: [
                Consumer<HarTextManager>(
                  builder: (context, hartextmanager, child) => Container(
                    height: 40,
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: senergyColorg,
                    ),
                    child: const Center(
                        child: Text(
                      'Event Type',
                      style: TextStyle(
                          fontSize: 20,
                          fontFamily: 'GE-bold',
                          color: Colors.white),
                    )),
                  ),
                ),
                Expanded(
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                    ),
                    child: Consumer<HarReport_Manager>(
                      builder: (_, harmanager, child) {
                        if (harmanager.report_har_types!.isEmpty) {
                          return const Center(child: Text('No types'));
                        } else {
                          return ListView.builder(
                            itemCount: harmanager.report_har_types!.length,
                            itemBuilder: (BuildContext ctxt, int index) {
                              return ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.white, // background
                                  onPrimary: Colors.white, // foreground
                                ),
                                onPressed: () {
                                  Provider.of<HarTextManager>(context,
                                          listen: false)
                                      .set_har_report_type_(
                                          harmanager.report_type_s![index]);
                                  Navigator.pop(context);
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      harmanager.report_type_s![index].type
                                          .toString(),
                                      style: const TextStyle(
                                          color: Colors.black,
                                          fontFamily: 'AraHamah1964R-Bold'),
                                    )
                                  ],
                                ),
                              );
                            },
                          );
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }

  // void _modalBottomSheet_har_severity(BuildContext context) {
  //   showModalBottomSheet(
  //       context: context,
  //       builder: (builder) {
  //         return Container(
  //           height: 250.0,
  //           color: Colors.transparent,
  //           child: Column(
  //             children: [
  //               Consumer<HarTextManager>(
  //                 builder: (context, hartextmanager, child) => Container(
  //                   height: 40,
  //                   width: double.infinity,
  //                   decoration: const BoxDecoration(
  //                     color: senergyColorg,
  //                   ),
  //                   child: const Center(
  //                       child: Text(
  //                     'Severity',
  //                     style: TextStyle(
  //                         fontSize: 20,
  //                         fontFamily: 'GE-bold',
  //                         color: Colors.white),
  //                   )),
  //                 ),
  //               ),
  //               Expanded(
  //                 child: Container(
  //                   decoration: const BoxDecoration(
  //                     color: Colors.white,
  //                   ),
  //                   child: Consumer<HarReport_Manager>(
  //                     builder: (_, harmanager, child) {
  //                       if (harmanager.report_har_types!.isEmpty) {
  //                         return const Center(child: Text('No Severity'));
  //                       } else {
  //                         return ListView.builder(
  //                           itemCount: harmanager.report_har_types!.length,
  //                           itemBuilder: (BuildContext ctxt, int index) {
  //                             return ElevatedButton(
  //                               style: ElevatedButton.styleFrom(
  //                                 primary: Colors.white, // background
  //                                 onPrimary: Colors.white, // foreground
  //                               ),
  //                               onPressed: () {
  //                                 Provider.of<HarTextManager>(context,
  //                                         listen: false)
  //                                     .set_har_report_severity(
  //                                         harmanager.report_severitys![index]);
  //                                 Navigator.pop(context);
  //                               },
  //                               child: Row(
  //                                 mainAxisAlignment: MainAxisAlignment.center,
  //                                 children: [
  //                                   Text(
  //                                     harmanager
  //                                         .report_severitys![index].severity
  //                                         .toString(),
  //                                     style: const TextStyle(
  //                                         color: Colors.black,
  //                                         fontFamily: 'AraHamah1964R-Bold'),
  //                                   )
  //                                 ],
  //                               ),
  //                             );
  //                           },
  //                         );
  //                       }
  //                     },
  //                   ),
  //                 ),
  //               ),
  //             ],
  //           ),
  //         );
  //       });
  // }

  void _modalBottomSheet_har_likelihood(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (builder) {
          return Container(
            height: 250.0,
            color: Colors.transparent,
            child: Column(
              children: [
                Consumer<HarTextManager>(
                  builder: (context, hartextmanager, child) => Container(
                    height: 40,
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: senergyColorg,
                    ),
                    child: const Center(
                        child: Text(
                      'Liklihood',
                      style: TextStyle(
                          fontSize: 20,
                          fontFamily: 'GE-bold',
                          color: Colors.white),
                    )),
                  ),
                ),
                Expanded(
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                    ),
                    child: Consumer<HarReport_Manager>(
                      builder: (_, harmanager, child) {
                        if (harmanager.report_likelihoods!.isEmpty) {
                          return const Center(child: Text('No Liklihoods'));
                        } else {
                          return ListView.builder(
                            itemCount: harmanager.report_likelihoods!.length,
                            itemBuilder: (BuildContext ctxt, int index) {
                              return ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.white, // background
                                  onPrimary: Colors.white, // foreground
                                ),
                                onPressed: () {
                                  Provider.of<HarTextManager>(context,
                                          listen: false)
                                      .set_har_report_likelihood(harmanager
                                          .report_likelihoods![index]);
                                  Navigator.pop(context);
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      harmanager
                                          .report_likelihoods![index].likelihood
                                          .toString(),
                                      style: const TextStyle(
                                          color: Colors.black,
                                          fontFamily: 'AraHamah1964R-Bold'),
                                    )
                                  ],
                                ),
                              );
                            },
                          );
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }

  void _modalBottomSheet_har_category(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (builder) {
          return Container(
            height: 250.0,
            color: Colors.transparent,
            child: Column(
              children: [
                Consumer<HarTextManager>(
                  builder: (context, hartextmanager, child) => Container(
                    height: 40,
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: senergyColorg,
                    ),
                    child: const Center(
                        child: Text(
                      'Hazard Category',
                      style: TextStyle(
                          fontSize: 20,
                          fontFamily: 'GE-bold',
                          color: Colors.white),
                    )),
                  ),
                ),
                Expanded(
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                    ),
                    child: Consumer<HarReport_Manager>(
                      builder: (_, harmanager, child) {
                        if (harmanager.report_categorys!.isEmpty) {
                          return const Center(child: Text('No Severity'));
                        } else {
                          return ListView.builder(
                            itemCount: harmanager.report_categorys!.length,
                            itemBuilder: (BuildContext ctxt, int index) {
                              return ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.white, // background
                                  onPrimary: Colors.white, // foreground
                                ),
                                onPressed: () {
                                  Provider.of<HarTextManager>(context,
                                          listen: false)
                                      .set_har_report_category(
                                          harmanager.report_categorys![index]);
                                  Navigator.pop(context);
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      harmanager.report_categorys![index]
                                          .hazardCategory
                                          .toString(),
                                      style: const TextStyle(
                                          color: Colors.black,
                                          fontFamily: 'AraHamah1964R-Bold'),
                                    )
                                  ],
                                ),
                              );
                            },
                          );
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Consumer<Auth_manager>(
        builder: (context, authManager, child) => Column(
          children: [
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    width: 120,
                    alignment: Alignment.topLeft,
                    child: const Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                      child: Text(
                        'location',
                        style: TextStyle(
                          fontSize: 15,
                          fontFamily: 'GE-medium',
                          color: senergyColorg,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Consumer<HarTextManager>(
                    builder: (context, hartextmanager, child) => Select_widget(
                        context, hartextmanager.har_location.name, () {
                      _modalBottomSheet_location(context);
                    }),
                  ),
                ],
              ),
            ),
            Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  width: 120,
                  alignment: Alignment.topLeft,
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                    child: Text(
                      'Segment',
                      style: TextStyle(
                        fontSize: 15,
                        fontFamily: 'GE-medium',
                        color: senergyColorg,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Consumer<HarTextManager>(
                  builder: (context, hartextmanager, child) => Select_widget(
                      context, hartextmanager.har_department.departmentName,
                      () {
                    _modalBottomSheet_segment(context);
                  }),
                )
              ],
            ),
            Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  width: 120,
                  alignment: Alignment.topLeft,
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                    child: Text(
                      'Type',
                      style: TextStyle(
                        fontSize: 15,
                        fontFamily: 'GE-medium',
                        color: senergyColorg,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Consumer<HarTextManager>(
                  builder: (context, hartextmanager, child) => Select_widget(
                      context, hartextmanager.har_report_type.type, () {
                    _modalBottomSheet_har_type(context);
                  }),
                )
              ],
            ),
            // Divider(),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceAround,
            //   children: [
            //     Container(
            //       width: 120,
            //       alignment: Alignment.topLeft,
            //       child: const Padding(
            //         padding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
            //         child: Text(
            //           'Area',
            //           style: TextStyle(
            //             fontSize: 15,
            //             fontFamily: 'GE-medium',
            //             color: senergyColorg,
            //             fontWeight: FontWeight.bold,
            //           ),
            //         ),
            //       ),
            //     ),
            //     Consumer<HarTextManager>(
            //       builder: (context, hartextmanager, child) => Select_widget(
            //           context, hartextmanager.har_location.name, () {
            //         _modalBottomSheet_location(context);
            //       }),
            //     )
            //   ],
            // ),
            Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  width: 120,
                  alignment: Alignment.topLeft,
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                    child: Text(
                      'Event Type',
                      style: TextStyle(
                        fontSize: 15,
                        fontFamily: 'GE-medium',
                        color: senergyColorg,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Consumer<HarTextManager>(
                  builder: (context, hartextmanager, child) => Select_widget(
                      context, hartextmanager.har_report_type_.type, () {
                    _modalBottomSheet_har_type_(context);
                  }),
                )
              ],
            ),
            // Divider(),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceAround,
            //   children: [
            //     Container(
            //       width: 120,
            //       alignment: Alignment.topLeft,
            //       child: const Padding(
            //         padding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
            //         child: Text(
            //           'Severity',
            //           style: TextStyle(
            //             fontSize: 15,
            //             fontFamily: 'GE-medium',
            //             color: senergyColorg,
            //             fontWeight: FontWeight.bold,
            //           ),
            //         ),
            //       ),
            //     ),
            //     Consumer<HarTextManager>(
            //       builder: (context, hartextmanager, child) => Select_widget(
            //           context, hartextmanager.har_report_severity.severity, () {
            //         _modalBottomSheet_har_severity(context);
            //       }),
            //     )
            //   ],
            // ),
            Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  width: 120,
                  alignment: Alignment.topLeft,
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                    child: Text(
                      'Likelihood',
                      style: TextStyle(
                        fontSize: 15,
                        fontFamily: 'GE-medium',
                        color: senergyColorg,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Consumer<HarTextManager>(
                  builder: (context, hartextmanager, child) => Select_widget(
                    context,
                    hartextmanager.har_report_likelihood.likelihood,
                    () {
                      _modalBottomSheet_har_likelihood(context);
                    },
                  ),
                )
              ],
            ),
            Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  width: 120,
                  alignment: Alignment.topLeft,
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                    child: Text(
                      'Hazard Category',
                      style: TextStyle(
                        fontSize: 15,
                        fontFamily: 'GE-medium',
                        color: senergyColorg,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Consumer<HarTextManager>(
                  builder: (context, hartextmanager, child) => Select_widget(
                      context,
                      hartextmanager.har_report_category.hazardCategory, () {
                    _modalBottomSheet_har_category(context);
                  }),
                )
              ],
            ),
            Divider(),
            Consumer<HarTextManager>(builder: (context, hartextmanager, child) {
              if (hartextmanager.har_report_category.id != null &&
                  hartextmanager.har_report_likelihood.id != null) {
                Map<String, Color> value_severity = wht_severity(
                    hartextmanager.har_report_category.id!,
                    hartextmanager.har_report_likelihood.id!);
                return Center(
                  /** Chip Widget **/
                  child: Chip(
                    elevation: 20,
                    padding: EdgeInsets.all(8),
                    backgroundColor: value_severity.values.first,
                    shadowColor: value_severity.values.first,
                    // avatar: CircleAvatar(
                    //     // backgroundColor: , //NetwordImage
                    //     ), //CircleAvatar
                    label: Text(
                      value_severity.keys.first,
                      style: TextStyle(fontSize: 15, color: Colors.white),
                    ), //Text
                  ), //Chip
                );
              } else {
                return Text('');
              }
            })
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceAround,
            //   children: [
            //     Container(
            //       width: 120,
            //       alignment: Alignment.topLeft,
            //       child: const Padding(
            //         padding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
            //         child: Text(
            //           'Event Type',
            //           style: TextStyle(
            //             fontSize: 15,
            //             fontFamily: 'GE-medium',
            //             color: senergyColorg,
            //             fontWeight: FontWeight.bold,
            //           ),
            //         ),
            //       ),
            //     ),
            //     Consumer<HarTextManager>(
            //       builder: (context, hartextmanager, child) => Select_widget(
            //           context, hartextmanager.har_location.name, () {
            //         _modalBottomSheet_location(context);
            //       }),
            //     )
            //   ],
            // ),
          ],
        ),
      ),
    );
  }

  Container Select_widget(
      BuildContext context, dynamic text, VoidCallback modalsheet) {
    return Container(
      alignment: Alignment.centerRight,
      width: widget.size.width / 2,
      padding: EdgeInsets.symmetric(horizontal: 20),
      height: 40,
      decoration: BoxDecoration(
        color: Colors.white,
        // borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey),
      ),
      child: InkWell(
        onTap: modalsheet,
        child: Row(
          children: [
            text == null
                ? SizedBox(
                    width: widget.size.width / 4,
                    child: const Text(
                      'select',
                      style: TextStyle(
                        overflow: TextOverflow.ellipsis,
                        fontSize: 15,
                        fontFamily: 'GE-bold',
                      ),
                    ),
                  )
                : SizedBox(
                    width: widget.size.width / 4,
                    child: Text(
                      text,
                      style: const TextStyle(
                        overflow: TextOverflow.ellipsis,
                        fontSize: 15,
                        fontFamily: 'GE-bold',
                      ),
                    ),
                  ),
            Spacer(),
            Icon(Icons.keyboard_arrow_down)
          ],
        ),
      ),
    );
  }

  // ignore: non_constant_identifier_names
  Center build_edit_field({
    required String item,
    required String hint,
    bool small = false,
    required TextEditingController controller,
    required TextInputType inputType,
    Function(String)? validate,
    FocusNode? focus,
  }) {
    return Center(
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        alignment: Alignment.centerRight,
        width: small ? widget.size.width * .9 / 2 : widget.size.width * .9,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        height: 55,
        decoration: BoxDecoration(
          color: Colors.white,
          // borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey),
        ),
        child: TextFormField(
          // maxLength: 6,

          focusNode: focus,
          textInputAction: TextInputAction.next,
          onSaved: (value) {
            _register_data[item] = value!;
          },
          keyboardType: inputType,
          controller: controller,
          validator: (value) {
            if (value!.isEmpty) {
              return '*';
            }
            return null;
          },
          onChanged: (value) {
            Provider.of<TripTextManager>(context, listen: false)
                .setdata(item, controller.text);
          },
          decoration: InputDecoration(
            focusedErrorBorder: InputBorder.none,
            errorBorder: InputBorder.none,
            errorStyle: const TextStyle(
              decoration: TextDecoration.none,
              fontSize: 12,
            ),
            hintText: hint,
            hintStyle: const TextStyle(fontFamily: 'GE-light', fontSize: 15),
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
          ),
        ),
      ),
    );
  }

  Center build_edit_field_area({
    required String item,
    required String hint,
    bool small = false,
    required TextEditingController controller,
    required TextInputType inputType,
    Function(String)? validate,
    FocusNode? focus,
  }) {
    return Center(
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        alignment: Alignment.centerRight,
        width: small ? widget.size.width * .9 / 2 : widget.size.width * .9,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        // height: 55,
        decoration: BoxDecoration(
          color: Colors.white,
          // borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey),
        ),
        child: TextFormField(
          // maxLength: 6,
          minLines: 8,
          keyboardType: TextInputType.multiline,
          maxLines: null,
          focusNode: focus,
          textInputAction: TextInputAction.next,
          onSaved: (value) {
            _register_data[item] = value!;
          },
          controller: controller,
          validator: (value) {
            if (value!.isEmpty) {
              return '*';
            }
            return null;
          },
          onChanged: (value) {
            Provider.of<TripTextManager>(context, listen: false)
                .setdata(item, controller.text);
          },
          decoration: InputDecoration(
            focusedErrorBorder: InputBorder.none,
            errorBorder: InputBorder.none,
            errorStyle: const TextStyle(
              decoration: TextDecoration.none,
              fontSize: 12,
            ),
            hintText: hint,
            hintStyle: const TextStyle(fontFamily: 'GE-light', fontSize: 15),
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
          ),
        ),
      ),
    );
  }

  Map<String, Color> wht_severity(int hazard, int liklihood) {
    int value = hazard * liklihood;
    if (value >= 20) {
      return {'Extreme': Colors.black};
    } else if (value >= 15 && value < 20) {
      return {'Very high': Colors.red};
    } else if (value >= 15 && value < 20) {
      return {'Very high': Colors.red};
    } else if (value >= 10 && value < 15) {
      return {'High': Colors.orange};
    } else if (value >= 5 && value < 10) {
      return {'Medium': Color.fromARGB(255, 204, 184, 9)};
    } else if (value >= 3 && value < 5) {
      return {'Low': Colors.green};
    } else if (value >= 1 && value < 3) {
      return {'Negligible': Colors.blue};
    } else {
      return {'Negligible': Colors.blue};
    }
  }
}
