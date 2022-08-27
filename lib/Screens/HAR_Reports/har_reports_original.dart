import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';

import 'package:senergy/constants.dart';
import 'package:senergy/managers/app_state_manager.dart';

import '../../managers/Har_report_requ.dart';

// ignore: must_be_immutable

class HarReportsView extends StatefulWidget {
  bool? mine;
  HarReportsView({Key? key, this.mine}) : super(key: key);

  @override
  State<HarReportsView> createState() => _HarReportsViewState();
}

class _HarReportsViewState extends State<HarReportsView> {
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

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () async {
      Provider.of<HarReport_Manager>(context, listen: false).resetlist();

      try {
        widget.mine!
            ? await Provider.of<HarReport_Manager>(context, listen: false)
                .getMoreData(mine: true)
                // .then((_) =>
                //     Provider.of<HarReport_Manager>(context, listen: false)
                //         .getMoreData(mine: true))
                .then((_) {
                setState(() {
                  _isloading = false;
                });
              })
            : await Provider.of<HarReport_Manager>(context, listen: false)
                .getMoreData()
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
          widget.mine!
              ? Provider.of<HarReport_Manager>(context, listen: false)
                  .getMoreData(mine: true)
              : Provider.of<HarReport_Manager>(context, listen: false)
                  .getMoreData();
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

    return _isloading
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
                      // if (widget.mine == true && harManager.data!.isEmpty) {
                      //   return const Center(
                      //       child: Text(
                      //     'YOU DONT HAVE HARS!!',
                      //     style: TextStyle(
                      //         fontFamily: 'GE-medium',
                      //         fontSize: 20,
                      //         fontWeight: FontWeight.bold,
                      //         color: senergyColorg),
                      //   ));
                      // }
                      if (harManager.data!.isEmpty) {
                        if (harManager.loading) {
                          return const Center(
                              child: Padding(
                            padding: EdgeInsets.all(8),
                            child: CircularProgressIndicator(),
                          ));
                        } else if (harManager.error) {
                          return Center(
                            child: InkWell(
                              onTap: () {
                                harManager.setloading(true);
                                harManager.seterror(false);
                                Provider.of<HarReport_Manager>(context,
                                        listen: false)
                                    .getMoreData();
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
                          itemCount: harManager.data!.length +
                              (harManager.hasmore ? 1 : 0),
                          itemBuilder: (BuildContext ctxt, int Index) {
                            if (Index == harManager.data!.length) {
                              if (harManager.error) {
                                return Center(
                                    child: InkWell(
                                  onTap: () {
                                    harManager.setloading(true);
                                    harManager.seterror(false);
                                    Provider.of<HarReport_Manager>(context,
                                            listen: false)
                                        .getMoreData();
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
                                          harManager.data![Index].content ?? '',
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          softWrap: false,
                                          style: TextStyle(
                                              color: text_colors[
                                                  Index % colors.length],
                                              fontFamily: 'AraHamah1964R-Bold'),
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          const Text(
                                            'Reporter',
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
                                            harManager.data![Index]
                                                        .reportReporter!.name ==
                                                    null
                                                ? ''
                                                : harManager.data![Index]
                                                    .reportReporter!.name!
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
                                          const Text('Event Date',
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
                                                      const EdgeInsets.all(3.0),
                                                  decoration: BoxDecoration(
                                                      border: Border.all(
                                                          color: senergyColorb
                                                              .withOpacity(
                                                                  .3))),
                                                  child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Text(
                                                          harManager
                                                                      .data![
                                                                          Index]
                                                                      .reportDate ==
                                                                  0
                                                              ? ''
                                                              : DateTime.fromMillisecondsSinceEpoch(
                                                                      harManager
                                                                          .data![
                                                                              Index]
                                                                          .reportDate!)
                                                                  .toString()
                                                                  .substring(
                                                                      0,
                                                                      harManager
                                                                              .data![
                                                                                  Index]
                                                                              .reportDate!
                                                                              .toString()
                                                                              .length +
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
                                          ]),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Chip(
                                            elevation: 1,
                                            padding: EdgeInsets.all(2),
                                            backgroundColor: Colors.white,
                                            label: Text(
                                              'Closed',
                                              style: TextStyle(
                                                  fontSize: 10,
                                                  color: harManager.data![Index]
                                                              .status ==
                                                          0
                                                      ? Colors.red
                                                      : Colors.green),
                                            ), //Text
                                          ),
                                          const SizedBox(
                                            width: 20,
                                          ),
                                          Chip(
                                            elevation: 1,
                                            padding: EdgeInsets.all(2),
                                            backgroundColor: Colors.white,
                                            label: Text(
                                              'acknowledged ',
                                              style: TextStyle(
                                                  fontSize: 10,
                                                  color: harManager.data![Index]
                                                              .acknowledgedBy ==
                                                          null
                                                      ? Colors.red
                                                      : Colors.green),
                                            ), //Text
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                  onTap: () {
                                    Provider.of<AppStateManager>(context,
                                            listen: false)
                                        .gotomysinglehar(
                                            true, harManager.data![Index].id!);
                                  },
                                  title: Row(
                                    children: [
                                      SizedBox(
                                        width: 200,
                                        child: Text(
                                          harManager.data![Index].title!,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          softWrap: false,
                                          style: const TextStyle(
                                              color: senergyColorg,
                                              //  text_colors[
                                              //     Index % colors.length],
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'AraHamah1964R-Bold'),
                                        ),
                                      ),
                                      const Spacer(),
                                      harManager.data![Index]
                                                      .reportLikelihood ==
                                                  null ||
                                              harManager.data![Index]
                                                      .reportCategory ==
                                                  null
                                          ? Container()
                                          : buildSeverity(
                                              harManager.data![Index]
                                                  .reportLikelihood!.id!,
                                              harManager.data![Index]
                                                  .reportCategory!.id!)
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
          );
  }

  Widget buildSeverity(hazard, liklihood) {
    int value = hazard * liklihood;
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
