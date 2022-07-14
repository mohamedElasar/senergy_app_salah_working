import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:senergy/Navigation/screens.dart';
import 'package:senergy/constants.dart';
import 'package:senergy/managers/app_state_manager.dart';
import 'package:senergy/managers/trip_manager.dart';

import '../../httpexception.dart';

// ignore: must_be_immutable
class MyTrips extends StatefulWidget {
  final bool? isadmin;

  static MaterialPage page({required bool isadmin}) {
    return MaterialPage(
      name: Senergy_Screens.mytrips,
      key: ValueKey(Senergy_Screens.mytrips),
      child: MyTrips(isadmin: isadmin),
    );
  }

  MyTrips({Key? key, this.isadmin}) : super(key: key);

  @override
  State<MyTrips> createState() => _MyTripsState();
}

class _MyTripsState extends State<MyTrips> {
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
      Provider.of<TripManager>(context, listen: false).resetlist();
      try {
        !widget.isadmin!
            ? await Provider.of<TripManager>(context, listen: false)
                .getMoreData(mine: true)
                // .then((_) => Provider.of<TripManager>(context, listen: false)
                //     .getMoreData(mine: true))
                .then((_) {
                setState(() {
                  _isloading = false;
                });
              })
            : await Provider.of<TripManager>(context, listen: false)
                .getMoreData()
                // .then((_) => Provider.of<TripManager>(context, listen: false)
                //     .getMoreData())
                .then((_) {
                setState(() {
                  _isloading = false;
                });
              });
      } catch (e) {}
      if (!mounted) return;

      _sc.addListener(() {
        if (_sc.position.pixels == _sc.position.maxScrollExtent) {
          widget.isadmin!
              ? Provider.of<TripManager>(context, listen: false).getMoreData()
              : Provider.of<TripManager>(context, listen: false)
                  .getMoreData(mine: true);
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
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: Center(
          child: widget.isadmin!
              ? const Text(
                  'All Trips',
                  style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'AraHamah1964B-Bold',
                      color: senergyColorb),
                )
              : const Text(
                  'My Trips',
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
                .gotomytrips(false);
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
          ? const Center(
              child: CircularProgressIndicator(),
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
                      child: Consumer<TripManager>(
                          builder: (builder, tripManager, child) {
                        if (tripManager.trips!.isEmpty) {
                          if (tripManager.loading) {
                            return const Center(
                                child: Padding(
                              padding: EdgeInsets.all(8),
                              child: CircularProgressIndicator(),
                            ));
                          } else if (tripManager.error) {
                            return Center(
                              child: InkWell(
                                onTap: () {
                                  tripManager.setloading(true);
                                  tripManager.seterror(false);
                                  Provider.of<TripManager>(context,
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
                            itemCount: tripManager.trips!.length +
                                (tripManager.hasmore ? 1 : 0),
                            itemBuilder: (BuildContext ctxt, int Index) {
                              print(tripManager.trips!.length);
                              // (tripManager.hasmore ? 1 : 0));
                              if (Index == tripManager.trips!.length) {
                                if (tripManager.error) {
                                  return Center(
                                      child: InkWell(
                                    onTap: () {
                                      tripManager.setloading(true);
                                      tripManager.seterror(false);
                                      Provider.of<TripManager>(context,
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
                                  return const Center(
                                      child: Padding(
                                    padding: EdgeInsets.all(8),
                                    child: CircularProgressIndicator(),
                                  ));
                                }
                              }
                              return Container(
                                margin: const EdgeInsets.symmetric(vertical: 5),
                                color: colors[Index % colors.length],
                                child: Dismissible(
                                  background: Container(
                                    color: Colors.red,
                                    child: const Align(
                                      alignment: Alignment.centerRight,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Icon(
                                          Icons.delete,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                  key: Key(
                                      tripManager.trips![Index].id.toString()),
                                  onDismissed: (DismissDirection) async {
                                    try {
                                      String? driverName = tripManager
                                          .trips![Index].userProfile!.name!;

                                      await Provider.of<TripManager>(context,
                                              listen: false)
                                          .delete_single_trip(
                                              tripManager.trips![Index].id!);
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                              backgroundColor: Colors.black45,
                                              content: Text(
                                                  'Trip of $driverName was deleted',
                                                  style: const TextStyle(
                                                      color: Colors.white,
                                                      fontFamily:
                                                          'AraHamah1964R-Bold'))));
                                    } on HttpException catch (error) {
                                      _showErrorDialog(error.toString());
                                    } catch (e) {
                                      _showErrorDialog('Try again');
                                    }
                                  },
                                  child: Material(
                                    elevation: 2,
                                    child: ListTile(
                                        subtitle: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              tripManager.trips![Index]
                                                          .userProfile ==
                                                      null
                                                  ? ''
                                                  : tripManager.trips![Index]
                                                      .userProfile!.name!,
                                              style: TextStyle(
                                                  color: text_colors[
                                                      Index % colors.length],
                                                  fontFamily:
                                                      'AraHamah1964R-Bold'),
                                            ),
                                            Text(
                                              tripManager.trips![Index]
                                                      .passengers ??
                                                  '',
                                              style: TextStyle(
                                                  color: text_colors[
                                                      Index % colors.length],
                                                  fontFamily:
                                                      'AraHamah1964R-Bold'),
                                            ),
                                            Row(
                                              children: [
                                                Column(children: [
                                                  const SizedBox(
                                                    height: 5,
                                                  ),
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        children: [
                                                          const Text(
                                                            'Vehicle',
                                                            style: TextStyle(
                                                                color:
                                                                    senergyColorb,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontFamily:
                                                                    'AraHamah1964R-Bold'),
                                                          ),
                                                          const SizedBox(
                                                            width: 20,
                                                          ),
                                                          Text(
                                                            tripManager
                                                                        .trips![
                                                                            Index]
                                                                        .car ==
                                                                    null
                                                                ? ''
                                                                : tripManager
                                                                    .trips![
                                                                        Index]
                                                                    .car!
                                                                    .name!,
                                                            style: const TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontFamily:
                                                                    'AraHamah1964R-Bold'),
                                                          ),
                                                        ],
                                                      ),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        children: [
                                                          const Text(
                                                            'Purpose',
                                                            style: TextStyle(
                                                                color:
                                                                    senergyColorb,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontFamily:
                                                                    'AraHamah1964R-Bold'),
                                                          ),
                                                          const SizedBox(
                                                            width: 20,
                                                          ),
                                                          Text(
                                                            tripManager
                                                                        .trips![
                                                                            Index]
                                                                        .purpose ==
                                                                    null
                                                                ? ''
                                                                : tripManager
                                                                    .trips![
                                                                        Index]
                                                                    .purpose!
                                                                    .name!,
                                                            style: const TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontFamily:
                                                                    'AraHamah1964R-Bold'),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),

                                                  Container(
                                                    margin:
                                                        const EdgeInsets.all(
                                                            6.0),
                                                    padding:
                                                        const EdgeInsets.all(
                                                            3.0),
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
                                                            tripManager
                                                                        .trips![
                                                                            Index]
                                                                        .startUnixTime ==
                                                                    null
                                                                ? ''
                                                                : DateTime.fromMillisecondsSinceEpoch(tripManager
                                                                        .trips![
                                                                            Index]
                                                                        .startUnixTime!)
                                                                    .toString()
                                                                    .substring(
                                                                        0,
                                                                        tripManager.trips![Index].startUnixTime!.toString().length +
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
                                                  const Text('to'),
                                                  Container(
                                                    margin:
                                                        const EdgeInsets.all(
                                                            6.0),
                                                    padding:
                                                        const EdgeInsets.all(
                                                            3.0),
                                                    decoration: BoxDecoration(
                                                        color: DateTime.now()
                                                                        .toUtc()
                                                                        .millisecondsSinceEpoch >
                                                                    tripManager
                                                                        .trips![
                                                                            Index]
                                                                        .endUnixTime! &&
                                                                !tripManager
                                                                    .trips![
                                                                        Index]
                                                                    .isClosed!
                                                            ? const Color
                                                                    .fromARGB(
                                                                255,
                                                                255,
                                                                209,
                                                                206)
                                                            : Colors.white,
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
                                                            tripManager
                                                                        .trips![
                                                                            Index]
                                                                        .endUnixTime ==
                                                                    null
                                                                ? ''
                                                                : DateTime.fromMillisecondsSinceEpoch(tripManager
                                                                        .trips![
                                                                            Index]
                                                                        .endUnixTime!)
                                                                    .toString()
                                                                    .substring(
                                                                        0,
                                                                        tripManager.trips![Index].endUnixTime!.toString().length +
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

                                                  //  Icon(
                                                  //   Icons.cancel_outlined,
                                                  //   color: Colors.red,
                                                  //   size: 30,
                                                  // ),
                                                ]),
                                                const Spacer(),
                                                if (tripManager
                                                    .trips![Index].danger!)
                                                  const Text(
                                                    'DANGER!!',
                                                    style: TextStyle(
                                                        color: Colors.red,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  )
                                              ],
                                            )
                                          ],
                                        ),
                                        onTap: () {
                                          Provider.of<AppStateManager>(context,
                                                  listen: false)
                                              .gotomysingletrips(
                                                  true,
                                                  tripManager
                                                      .trips![Index].id!);
                                        },
                                        title: Row(
                                          children: [
                                            SizedBox(
                                              width: 70,
                                              child: Align(
                                                alignment: Alignment.center,
                                                child: Text(
                                                  tripManager
                                                      .trips![Index].from!,
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  softWrap: false,
                                                  style: const TextStyle(
                                                      color: senergyColorg,
                                                      // text_colors[
                                                      //     Index % colors.length],
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontFamily:
                                                          'AraHamah1964R-Bold'),
                                                ),
                                              ),
                                            ),
                                            const Text(' - '),
                                            SizedBox(
                                              width: 70,
                                              child: Align(
                                                alignment: Alignment.center,
                                                child: Text(
                                                  tripManager.trips![Index].to!,
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  softWrap: false,
                                                  style: const TextStyle(
                                                      color: senergyColorg,
                                                      //  text_colors[
                                                      //     Index % colors.length],
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontFamily:
                                                          'AraHamah1964R-Bold'),
                                                ),
                                              ),
                                            ),
                                            Spacer(),
                                            Chip(
                                              elevation: 1,
                                              padding: EdgeInsets.all(2),
                                              backgroundColor: tripManager
                                                      .trips![Index].isApproved!
                                                  ? Colors.green
                                                  : Colors.red,
                                              label: const Text(
                                                'Approved ',
                                                style: TextStyle(
                                                    fontSize: 10,
                                                    color: Colors.white),
                                              ), //Text
                                            ),
                                            const SizedBox(
                                              width: 3,
                                            ),
                                            Chip(
                                              elevation: 1,
                                              padding: EdgeInsets.all(2),
                                              backgroundColor: tripManager
                                                      .trips![Index].isClosed!
                                                  ? Colors.green
                                                  : Colors.red,
                                              label: const Text(
                                                'Closed ',
                                                style: TextStyle(
                                                    fontSize: 10,
                                                    color: Colors.white),
                                              ), //Text
                                            ),
                                          ],
                                        )),
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
}
