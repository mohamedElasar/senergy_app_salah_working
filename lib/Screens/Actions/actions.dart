import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:senergy/Navigation/screens.dart';
import 'package:senergy/constants.dart';
import 'package:senergy/managers/app_state_manager.dart';

import '../../managers/Har_report_requ.dart';
import '../../managers/auth_manager.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

// ignore: must_be_immutable
class ActionsPage extends StatefulWidget {
  final bool? isadmin;

  static MaterialPage page({required bool isadmin}) {
    return MaterialPage(
      name: Senergy_Screens.actions,
      key: ValueKey(Senergy_Screens.mytrips),
      child: ActionsPage(isadmin: isadmin),
    );
  }

  ActionsPage({Key? key, this.isadmin}) : super(key: key);

  @override
  State<ActionsPage> createState() => _ActionsPageState();
}

class _ActionsPageState extends State<ActionsPage> {
  var colors = [
    kbackgroundColor2.withOpacity(1),
    kbackgroundColor2.withOpacity(1),
  ];

  var text_colors = [Colors.black, Colors.black];

  Map<String, dynamic> _add_data = {
    'year': null,
  };

  var yearController = TextEditingController();

  String text_value = '';

  bool _isloading = true;
  ScrollController _sc = new ScrollController();
  String? id;
  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () async {
      Provider.of<HarReport_Manager>(context, listen: false).resetlist();
      id = Provider.of<Auth_manager>(context, listen: false).userid.toString();

      try {
        await Provider.of<HarReport_Manager>(context, listen: false)
            .get_actions_for_user(id!)
            // .then((_) =>
            //     Provider.of<HarReport_Manager>(context, listen: false)
            //         .getMoreData())
            .then((_) {
          setState(() {
            _isloading = false;
          });
        });
      } catch (e) {}
      if (!mounted) return;

      _sc.addListener(() {
        if (_sc.position.pixels == _sc.position.maxScrollExtent) {
          Provider.of<HarReport_Manager>(context, listen: false)
              .get_actions_for_user(id!);
        }
      });
    });
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text(
          'Something Went Wrong',
          style: TextStyle(fontFamily: 'GE-Bold'),
        ),
        content: Text(
          message,
          style: const TextStyle(fontFamily: 'AraHamah1964R-Bold'),
        ),
        actions: <Widget>[
          Center(
            child: TextButton(
              style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all(kbackgroundColor3)),
              // color: kbackgroundColor1,
              child: const Text(
                'OK',
                style: TextStyle(
                    fontFamily: 'AraHamah1964R-Bold', color: Colors.black),
              ),
              onPressed: () {
                Navigator.of(ctx).pop();
              },
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: const Center(
          // child: widget.isadmin!
          //  const Text(
          //       'All Trips',
          //       style: TextStyle(
          //           fontSize: 40,
          //           fontWeight: FontWeight.bold,
          //           fontFamily: 'AraHamah1964B-Bold',
          //           color: senergyColorb),
          //     )
          //   :
          child: Text(
            'MY ACTIONS',
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
                .gotomyactions(false);
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
          ? Center(
              child: LoadingAnimationWidget.twistingDots(
                leftDotColor: const Color(0xFF1A1A3F),
                rightDotColor: const Color(0xFFEA3799),
                size: 50,
              ),
            )
          : Column(
              children: [
                // Container(color: Colors.red),
                // Container(
                //   color: Colors.white,
                //   height: 20,
                // ),
                Expanded(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsetsDirectional.only(
                        start: 5,
                        end: 5,
                        top: 10,
                      ),
                      child: Consumer<HarReport_Manager>(
                          builder: (builder, harManager, child) {
                        if (harManager.actions_for_user!.isEmpty) {
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  'NO ACTIONS REQUIRED',
                                  style: TextStyle(
                                      fontFamily: 'GE-medium',
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: senergyColorg),
                                ),
                                Center(
                                  child: LoadingAnimationWidget.flickr(
                                    leftDotColor: const Color(0xFF1A1A3F),
                                    rightDotColor: const Color(0xFFEA3799),
                                    size: 50,
                                  ),
                                )
                              ],
                            ),
                          );
                        }
                        if (harManager.actions_for_user!.isEmpty) {
                          if (harManager.loading) {
                            return Center(
                                child: Padding(
                              padding: const EdgeInsets.all(8),
                              child: LoadingAnimationWidget.twistingDots(
                                leftDotColor: const Color(0xFF1A1A3F),
                                rightDotColor: const Color(0xFFEA3799),
                                size: 50,
                              ),
                            ));
                          } else if (harManager.error) {
                            return Center(
                              child: InkWell(
                                onTap: () {
                                  harManager.setloading(true);
                                  harManager.seterror(false);
                                  Provider.of<HarReport_Manager>(context,
                                          listen: false)
                                      .get_actions_for_user(id!);
                                },
                                child: const Padding(
                                  padding: EdgeInsets.all(16),
                                  child: Text("error please tap to try again"),
                                ),
                              ),
                            );
                          }
                        } else {
                          return ListView.builder(
                            controller: _sc,
                            itemCount: harManager.actions_for_user!.length +
                                (harManager.hasmore ? 1 : 0),
                            itemBuilder: (BuildContext ctxt, int Index) {
                              if (Index ==
                                  harManager.actions_for_user!.length) {
                                if (harManager.error) {
                                  return Center(
                                      child: InkWell(
                                    onTap: () {
                                      harManager.setloading(true);
                                      harManager.seterror(false);
                                      Provider.of<HarReport_Manager>(context,
                                              listen: false)
                                          .get_actions_for_user(id!);
                                    },
                                    child: const Padding(
                                      padding: EdgeInsets.all(16),
                                      child:
                                          Text("error please tap to try again"),
                                    ),
                                  ));
                                } else {
                                  return Center(
                                      child: Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: LoadingAnimationWidget.twistingDots(
                                      leftDotColor: const Color(0xFF1A1A3F),
                                      rightDotColor: const Color(0xFFEA3799),
                                      size: 50,
                                    ),
                                  ));
                                }
                              }
                              return Container(
                                margin: const EdgeInsets.symmetric(vertical: 5),
                                color: colors[Index % colors.length],
                                child: Material(
                                  elevation: 2,
                                  child: ListTile(
                                    subtitle: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          width: size.width * .8,
                                          height: 40,
                                          child: Text(
                                            harManager.actions_for_user![Index]
                                                        .reportIdd !=
                                                    null
                                                ? harManager
                                                    .actions_for_user![Index]
                                                    .reportIdd!
                                                    .content!
                                                : '',
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            softWrap: false,
                                            style: TextStyle(
                                                color: text_colors[
                                                    Index % colors.length],
                                                fontFamily:
                                                    'AraHamah1964R-Bold'),
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            const Text(
                                              'Assigned By',
                                              style: TextStyle(
                                                  color: senergyColorb,
                                                  fontWeight: FontWeight.bold,
                                                  fontFamily:
                                                      'AraHamah1964R-Bold'),
                                            ),
                                            const SizedBox(
                                              width: 20,
                                            ),
                                            Text(
                                              harManager
                                                          .actions_for_user![
                                                              Index]
                                                          .assignedByy!
                                                          .name ==
                                                      null
                                                  ? ''
                                                  : harManager
                                                      .actions_for_user![Index]
                                                      .assignedByy!
                                                      .name!
                                                      .substring(0),
                                              style: const TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                  fontFamily:
                                                      'AraHamah1964R-Bold'),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            const Text('Due Date',
                                                style: TextStyle(
                                                    color: senergyColorb,
                                                    fontWeight: FontWeight.bold,
                                                    fontFamily:
                                                        'AraHamah1964R-Bold')),
                                            Column(children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(4.0),
                                                child: Material(
                                                  elevation: 3,
                                                  child: Container(
                                                    // margin:
                                                    //     const EdgeInsets.all(
                                                    //         6.0),
                                                    padding:
                                                        const EdgeInsets.all(
                                                            3.0),
                                                    decoration: BoxDecoration(
                                                        color: harManager
                                                                    .actions_for_user![
                                                                        Index]
                                                                    .targetDate! <
                                                                DateTime.now()
                                                                    .toUtc()
                                                                    .millisecondsSinceEpoch
                                                            ? const Color.fromARGB(
                                                                255, 255, 209, 206)
                                                            : const Color.fromARGB(
                                                                255,
                                                                216,
                                                                255,
                                                                218),
                                                        border: Border.all(
                                                            color: senergyColorb
                                                                .withOpacity(.3))),
                                                    child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Text(
                                                            harManager
                                                                        .actions_for_user![
                                                                            Index]
                                                                        .targetDate ==
                                                                    null
                                                                ? ''
                                                                : DateTime.fromMillisecondsSinceEpoch(harManager
                                                                        .actions_for_user![
                                                                            Index]
                                                                        .targetDate!)
                                                                    .toString()
                                                                    .substring(
                                                                        0,
                                                                        harManager.actions_for_user![Index].targetDate!.toString().length +
                                                                            3)
                                                                    .replaceAll(
                                                                        RegExp(
                                                                            ' '),
                                                                        ' , '),
                                                            style: TextStyle(
                                                                color: text_colors[
                                                                    Index %
                                                                        colors
                                                                            .length],
                                                                fontFamily:
                                                                    'AraHamah1964R-Bold'),
                                                          ),
                                                        ]),
                                                  ),
                                                ),
                                              ),
                                              // Container(
                                              //   margin:
                                              //       const EdgeInsets.all(6.0),
                                              //   padding:
                                              //       const EdgeInsets.all(3.0),
                                              //   decoration: BoxDecoration(
                                              //       color: harManager
                                              //                   .actions_for_user![
                                              //                       Index]
                                              //                   .targetDate! <
                                              //               DateTime.now()
                                              //                   .toUtc()
                                              //                   .millisecondsSinceEpoch
                                              //           ? const Color.fromARGB(
                                              //               255, 255, 209, 206)
                                              //           : const Color.fromARGB(
                                              //               255, 216, 255, 218),
                                              //       border: Border.all(
                                              //           color: senergyColorb
                                              //               .withOpacity(.3))),
                                              //   child: Column(
                                              //     mainAxisAlignment:
                                              //         MainAxisAlignment.center,
                                              //     children: [
                                              //       Text(
                                              //         harManager
                                              //                     .actions_for_user![
                                              //                         Index]
                                              //                     .targetDate ==
                                              //                 null
                                              //             ? ''
                                              //             : DateTime.fromMillisecondsSinceEpoch(
                                              //                     harManager
                                              //                         .actions_for_user![
                                              //                             Index]
                                              //                         .targetDate!)
                                              //                 .toString()
                                              //                 .substring(
                                              //                     0,
                                              //                     harManager
                                              //                             .actions_for_user![
                                              //                                 Index]
                                              //                             .targetDate!
                                              //                             .toString()
                                              //                             .length +
                                              //                         3)
                                              //                 .replaceAll(
                                              //                     RegExp(' '),
                                              //                     ' , '),
                                              //         style: TextStyle(
                                              //             color: text_colors[
                                              //                 Index %
                                              //                     colors
                                              //                         .length],
                                              //             fontFamily:
                                              //                 'AraHamah1964R-Bold'),
                                              //       ),
                                              //     ],
                                              //   ),
                                              // ),
                                            ]),
                                          ],
                                        ),
                                      ],
                                    ),
                                    onTap: () {
                                      Provider.of<AppStateManager>(context,
                                              listen: false)
                                          .gotomysingleaction(
                                              true,
                                              harManager
                                                  .actions_for_user![Index]
                                                  .id!);
                                    },
                                    title: Row(
                                      children: [
                                        SizedBox(
                                          width: 200,
                                          child: Text(
                                            harManager.actions_for_user![Index]
                                                        .reportIdd !=
                                                    null
                                                ? harManager
                                                    .actions_for_user![Index]
                                                    .reportIdd!
                                                    .title!
                                                : '',
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            softWrap: false,
                                            style: const TextStyle(
                                                color: senergyColorg,
                                                //  text_colors[
                                                //     Index % colors.length],
                                                fontWeight: FontWeight.bold,
                                                fontFamily:
                                                    'AraHamah1964R-Bold'),
                                          ),
                                        ),
                                        const Spacer(),
                                        harManager.actions_for_user![Index]
                                                        .reportIdd !=
                                                    null ||
                                                harManager
                                                        .actions_for_user![
                                                            Index]
                                                        .reportIdd!
                                                        .event_severity !=
                                                    null
                                            ? buildSeverity(harManager
                                                .actions_for_user![Index]
                                                .reportIdd!
                                                .event_severity!)
                                            : Container(),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        }
                        return Container();
                      }),
                    ),
                  ),
                ),
              ],
            ),
    ));
  }

  Widget buildSeverity(value) {
    // int value = hazard * liklihood;
    if (value >= 20) {
      return const Chip(
        elevation: 1,
        padding: EdgeInsets.all(2),
        backgroundColor: Colors.black,
        label: Text(
          'Extreme',
          style: TextStyle(fontSize: 10, color: Colors.white),
        ), //Text
      );
    } else if (value >= 15 && value < 20) {
      return const Chip(
        elevation: 1,
        padding: EdgeInsets.all(2),
        backgroundColor: Colors.red,
        label: Text(
          'Very High',
          style: TextStyle(fontSize: 10, color: Colors.white),
        ), //Text
      );
    } else if (value >= 10 && value < 15) {
      return const Chip(
        elevation: 1,
        padding: EdgeInsets.all(2),
        backgroundColor: Colors.orange,
        label: Text(
          'High',
          style: TextStyle(fontSize: 10, color: Colors.white),
        ), //Text
      );
    } else if (value >= 5 && value < 10) {
      return const Chip(
        elevation: 1,
        padding: EdgeInsets.all(2),
        backgroundColor: Color.fromARGB(255, 204, 184, 9),
        label: Text(
          'Medium',
          style: TextStyle(fontSize: 10, color: Colors.white),
        ), //Text
      );
    } else if (value >= 3 && value < 5) {
      return const Chip(
        elevation: 1,
        padding: EdgeInsets.all(2),
        backgroundColor: Colors.green,
        label: Text(
          'Low',
          style: TextStyle(fontSize: 10, color: Colors.white),
        ), //Text
      );
    } else if (value >= 1 && value < 3) {
      return const Chip(
        elevation: 1,
        padding: EdgeInsets.all(2),
        backgroundColor: Colors.blue,
        label: Text(
          'Negligible',
          style: TextStyle(fontSize: 10, color: Colors.white),
        ), //Text
      );
    } else {
      return const Chip(
        elevation: 1,
        padding: EdgeInsets.all(2),
        backgroundColor: Colors.blue,
        label: Text(
          'Negligible',
          style: TextStyle(fontSize: 10, color: Colors.white),
        ), //Text
      );
    }
  }
}
