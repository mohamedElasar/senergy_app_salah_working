import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:provider/provider.dart';
import 'package:senergy/Navigation/screens.dart';
import 'package:senergy/Screens/Trip_final/final_checklist.dart';
import 'package:senergy/managers/Har_report_requ.dart';
import 'package:senergy/managers/app_state_manager.dart';
import 'package:senergy/managers/trip_manager.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../constants.dart';
import '../../httpexception.dart';
import 'package:senergy/managers/auth_manager.dart';

import '../../managers/har_text_manager.dart';
import '../../managers/trip_text_manager.dart';

class ActionFInal extends StatefulWidget {
  // ignore: non_constant_identifier_names
  final int? har_id;
  final bool? isadmin;
  static MaterialPage page({required int actionid, required bool isadmin}) {
    return MaterialPage(
      name: Senergy_Screens.actionfinal,
      key: ValueKey(Senergy_Screens.actionfinal),
      child: ActionFInal(
        har_id: actionid,
        isadmin: isadmin,
      ),
    );
  }

  // ignore: non_constant_identifier_names
  const ActionFInal({Key? key, this.har_id, this.isadmin}) : super(key: key);

  @override
  State<ActionFInal> createState() => _ActionFInalState();
}

var _isloading = true;
var colors = [
  kbackgroundColor2.withOpacity(1),
  kbackgroundColor2.withOpacity(1),
];

var text_colors = [Colors.black, Colors.black];
bool _isLoading = false;

class _ActionFInalState extends State<ActionFInal> {
  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () async {
      setState(() {
        _isloading = true;
      });
      try {
        await Provider.of<HarReport_Manager>(context, listen: false)
            .get_single_action(widget.har_id!)
            .then((_) {
          setState(() {
            _isloading = false;
          });
        });
      } catch (e) {}
      if (!mounted) return;
    });
  }

  bool actionView = false;
  void setActionView(bool value) {
    setState(() {
      actionView = value;
    });
  }

  TextEditingController action_controller = TextEditingController();
  FocusNode focus1 = FocusNode();

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text(
          'Something went wrong',
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
                      MaterialStateProperty.all(kbackgroundColor1)),
              // color: kbackgroundColor1,
              child: const Text(
                'OK',
                style: TextStyle(
                    fontFamily: 'AraHamah1964R-Regular', color: Colors.black),
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

  void _submit(int actionid) async {
    try {
      if (Provider.of<AppStateManager>(context, listen: false)
              .actionDueTimeUnix ==
          null) {
        _showErrorDialog('you should select action Date');
        return;
      }

      if (action_controller.text == '') {
        _showErrorDialog('you should Type Action Description ');
        return;
      }

      setState(() {
        _isLoading = true;
      });

      await Provider.of<HarReport_Manager>(context, listen: false)
          .closeAction2(
        closingNote: action_controller.text,
        // closingDate: ,
        id: actionid,

        closingDate: Provider.of<AppStateManager>(context, listen: false)
            .actionDueTimeUnix
            .toUtc()
            .millisecondsSinceEpoch,
      )
          .then((_) {
        // Navigator.pop(context);
        Provider.of<AppStateManager>(context, listen: false).gotoHome();
      }).then((_) {
        Provider.of<HarTextManager>(context, listen: false).clearAll();
        Provider.of<TripTextManager>(context, listen: false).clearAll();
      }).then(
        (value) => ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.green[300],
            content: const Text(
              'Your Action SENT SUCCESSFULLY',
              style: TextStyle(fontFamily: 'GE-medium'),
            ),
            duration: const Duration(seconds: 3),
          ),
        ),
      );
    } on HttpException catch (error) {
      // _showErrorDialog(error.toString());
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.black26,
          content: Text(
            error.toString(),
            style: const TextStyle(fontFamily: 'GE-medium'),
          ),
          duration: const Duration(seconds: 3),
        ),
      );
    } catch (error) {
      print(error.toString());
      const errorMessage = 'Try again later';
      _showErrorDialog(error.toString());
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final userid = Provider.of<Auth_manager>(context, listen: false).userid;

    print(_isLoading);
    return SafeArea(
        child: Scaffold(
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add_task_rounded),
          onPressed: () {
            setActionView(!actionView);
          },
          // child: const Icon(Icons.add_sharp),
          backgroundColor: senergyColorg),
      appBar: AppBar(
        title: const Center(
          child: Text(
            'REPORT ACTION',
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
            Provider.of<AppStateManager>(context, listen: false).clearactoin();
            Provider.of<AppStateManager>(context, listen: false).clearactoin();
            Provider.of<AppStateManager>(context, listen: false)
                .gotomysingleaction(false, 1);
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
                Consumer<HarReport_Manager>(
                  builder: (builder, harManager, child) => harManager
                              .single_action!.id ==
                          null
                      ? const Padding(
                          padding: EdgeInsets.all(20.0),
                          child: Text(
                            'NO ACTIONS',
                            style: TextStyle(fontFamily: 'AraHamah1964R-Bold'),
                          ),
                        )
                      : Column(
                          children: [
                            Container(
                              margin: const EdgeInsets.symmetric(vertical: 5),
                              color: colors[1 % colors.length],
                              child: Material(
                                color: kbackgroundColor2.withOpacity(.5),
                                child: ListTile(
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width: size.width * .8,
                                        // height: 40,
                                        child: Text(
                                          harManager.single_action!.reportIdd !=
                                                  null
                                              ? harManager.single_action!
                                                  .reportIdd!.content!
                                              : '',
                                          maxLines: 10,
                                          overflow: TextOverflow.ellipsis,
                                          softWrap: false,
                                          style: TextStyle(
                                              color: text_colors[
                                                  0 % colors.length],
                                              fontFamily: 'AraHamah1964R-Bold'),
                                        ),
                                      ),
                                    ],
                                  ),
                                  onTap: () {
                                    // Provider.of<AppStateManager>(context,
                                    //         listen: false)
                                    //     .gotomysinglehar(
                                    //         true, harManager.single_har!.id!);
                                  },
                                  title: Row(
                                    children: [
                                      SizedBox(
                                        width: 200,
                                        child: Text(
                                          harManager.single_action!.reportIdd !=
                                                  null
                                              ? harManager.single_action!
                                                  .reportIdd!.title!
                                              : '',
                                          maxLines: 3,
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
                                      harManager.single_action!.reportIdd !=
                                              null
                                          ? buildSeverity(harManager
                                              .single_action!
                                              .reportIdd!
                                              .event_severity!)
                                          : Container()
                                    ],
                                  ),
                                ),
                              ),
                            ),

                            !actionView
                                ? Consumer<HarReport_Manager>(
                                    builder: (builder, harManager, child) =>
                                        Column(
                                      children: [
                                        const SizedBox(height: 10),
                                        Items(
                                          size: size,
                                          title: 'Assigned By: ',
                                          item: harManager.single_action!
                                                  .assignedByy!.name ??
                                              '',
                                        ),
                                        Container(
                                          alignment: Alignment.topCenter,
                                          child: const Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 5, horizontal: 20),
                                            child: Text(
                                              'Action Needed',
                                              style: TextStyle(
                                                fontSize: 15,
                                                fontFamily: 'GE-medium',
                                                color: senergyColorg,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          width: size.width * .9,
                                          alignment: Alignment.topLeft,
                                          // width: widget.size.width / 2,
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 20, vertical: 5),
                                          // height: 40,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            // borderRadius: BorderRadius.circular(20),
                                            border:
                                                Border.all(color: Colors.grey),
                                          ),
                                          child: Text(
                                            harManager.single_action!
                                                    .actionDetails ??
                                                '',
                                            maxLines: 10,
                                            overflow: TextOverflow.ellipsis,
                                            softWrap: false,
                                            style: TextStyle(
                                                color: text_colors[
                                                    0 % colors.length],
                                                fontFamily:
                                                    'AraHamah1964R-Bold'),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                : Column(
                                    children: [
                                      Container(
                                        width: size.width * .4,
                                        alignment: Alignment.topLeft,
                                        child: const Padding(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 5, horizontal: 20),
                                          child: Text(
                                            'MY ACTION',
                                            style: TextStyle(
                                              fontSize: 15,
                                              fontFamily: 'GE-medium',
                                              color: senergyColorb,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          Container(
                                            width: size.width * .4,
                                            alignment: Alignment.topLeft,
                                            child: const Padding(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 5, horizontal: 20),
                                              child: Text(
                                                'Action Date',
                                                style: TextStyle(
                                                  fontSize: 15,
                                                  fontFamily: 'GE-medium',
                                                  color: senergyColorg,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Container(
                                            alignment: Alignment.centerRight,
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 20),
                                            height: 40,
                                            width: size.width * .5,
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              border: Border.all(
                                                color: Colors.grey,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            child: InkWell(
                                              onTap: () {
                                                DatePicker.showDateTimePicker(
                                                    context,
                                                    showTitleActions: true,
                                                    onChanged: (date) {},
                                                    onConfirm: (date) {
                                                  Provider.of<AppStateManager>(
                                                          context,
                                                          listen: false)
                                                      .setactionDueTime(date);
                                                }, currentTime: DateTime.now());
                                              },
                                              child: Consumer<AppStateManager>(
                                                builder: (context,
                                                        tripTextManager,
                                                        child) =>
                                                    Row(
                                                  children: [
                                                    // const Icon(Icons.add_circle_outline_outlined),
                                                    // const Spacer(),
                                                    tripTextManager
                                                                .actionDueTimeUnix ==
                                                            null
                                                        ? const Icon(Icons
                                                            .add_circle_outline_outlined)
                                                        : Text(
                                                            tripTextManager
                                                                .actionDueTimeUnix
                                                                .toString()
                                                                .substring(
                                                                    0,
                                                                    tripTextManager
                                                                            .actionDueTimeUnix
                                                                            .toString()
                                                                            .length -
                                                                        7)
                                                                .replaceAll(
                                                                    RegExp(' '),
                                                                    ' , '),
                                                            style: const TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          )
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const Divider(),
                                      Container(
                                        alignment: Alignment.topCenter,
                                        child: const Padding(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 5, horizontal: 20),
                                          child: Text(
                                            'Action Description',
                                            style: TextStyle(
                                              fontSize: 15,
                                              fontFamily: 'GE-medium',
                                              color: senergyColorg,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                      build_edit_field_area(
                                          item: 'content',
                                          hint: 'Action Description',
                                          controller: action_controller,
                                          inputType: TextInputType.number,
                                          focus: focus1,
                                          width1: size.width * .8 / 2,
                                          width2: size.width * .9),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: SizedBox(
                                          width: size.width * .9,
                                          child: TextButton(
                                            style: ButtonStyle(
                                                elevation:
                                                    MaterialStateProperty.all(
                                                        2),
                                                backgroundColor:
                                                    MaterialStateProperty.all(
                                                        kbuttonColor3)),
                                            onPressed: () => _submit(
                                                harManager.single_action!.id!),
                                            child: const Text(
                                              'Submit Action',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15,
                                                  fontFamily: 'GE-Bold',
                                                  color: Colors.black),
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                            const Divider(),
                            // harManager.single_har!.image != null
                            if (harManager.single_action!.reportIdd != null &&
                                harManager.single_action!.reportIdd!.image !=
                                    null &&
                                !actionView)
                              Container(
                                width: size.width * .95,
                                child: Image.network(
                                  'http://10.0.2.2:5000/images/' +
                                      // 'images/2022-07-03T19-59-43.585Zb52f0a3a-5509-48c6-be18-05e04b4ef91f8874079307014466216.jpg'
                                      harManager
                                          .single_action!.reportIdd!.image!
                                          .split(r'\')[1],
                                  fit: BoxFit.fill,
                                  loadingBuilder: (BuildContext context,
                                      Widget child,
                                      ImageChunkEvent? loadingProgress) {
                                    if (loadingProgress == null) return child;
                                    return Center(
                                      child: CircularProgressIndicator(
                                        value: loadingProgress
                                                    .expectedTotalBytes !=
                                                null
                                            ? loadingProgress
                                                    .cumulativeBytesLoaded /
                                                loadingProgress
                                                    .expectedTotalBytes!
                                            : null,
                                      ),
                                    );
                                  },
                                ),
                              )
                            // : Container(),
                            // Divider(),
                          ],
                        ),
                ),
              ]),
            ),
    ));
  }

  Center build_edit_field_area({
    required String item,
    required String hint,
    bool small = false,
    required TextEditingController controller,
    required TextInputType inputType,
    Function(String)? validate,
    FocusNode? focus,
    double? width1,
    double? width2,
  }) {
    return Center(
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        alignment: Alignment.centerRight,
        width: small ? width1 : width2,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        // height: 55,
        decoration: BoxDecoration(
          color: Colors.white,
          // borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey),
        ),
        child: TextFormField(
          // maxLength: 6,
          minLines: 5,
          keyboardType: TextInputType.multiline,
          maxLines: null,
          focusNode: focus,
          textInputAction: TextInputAction.next,
          onSaved: (value) {
            // _register_data[item] = value!;
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

  Container Select_widget(
      BuildContext context, dynamic text, VoidCallback modalsheet) {
    final size = MediaQuery.of(context).size;
    return Container(
      alignment: Alignment.centerRight,
      width: size.width / 2,
      padding: const EdgeInsets.symmetric(horizontal: 20),
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
                    width: size.width / 4,
                    child: const Text(
                      'Pick Name',
                      style: TextStyle(
                        overflow: TextOverflow.ellipsis,
                        fontSize: 20,
                        fontFamily: 'AraHamah1964R-Regular',
                      ),
                    ),
                  )
                : SizedBox(
                    width: size.width / 4,
                    child: Text(
                      text,
                      style: const TextStyle(
                        overflow: TextOverflow.ellipsis,
                        fontSize: 20,
                        fontFamily: 'AraHamah1964R-Regular',
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

class Items extends StatelessWidget {
  const Items({
    Key? key,
    required this.size,
    required this.title,
    required this.item,
  }) : super(key: key);

  final Size size;
  final String title;
  final String item;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Container(
            width: size.width * .4,
            alignment: Alignment.topLeft,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 15,
                  fontFamily: 'GE-medium',
                  color: senergyColorg,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Container(
            width: size.width * .5,
            alignment: Alignment.centerRight,
            // width: widget.size.width / 2,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            height: 40,
            decoration: BoxDecoration(
              color: Colors.white,
              // borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.grey),
            ),
            child: Row(
              children: [
                SizedBox(
                  // width: size.width / 4,
                  child: Text(
                    item,
                    style: const TextStyle(
                      overflow: TextOverflow.ellipsis,
                      fontSize: 15,
                      fontFamily: 'GE-bold',
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
