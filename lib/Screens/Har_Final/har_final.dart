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

class HarFinal extends StatefulWidget {
  // ignore: non_constant_identifier_names
  final int? har_id;
  final bool? isadmin;
  static MaterialPage page({required int harid, required bool isadmin}) {
    return MaterialPage(
      name: Senergy_Screens.harfinal,
      key: ValueKey(Senergy_Screens.harfinal),
      child: HarFinal(
        har_id: harid,
        isadmin: isadmin,
      ),
    );
  }

  // ignore: non_constant_identifier_names
  const HarFinal({Key? key, this.har_id, this.isadmin}) : super(key: key);

  @override
  State<HarFinal> createState() => _HarFinalState();
}

var _isloading = true;
var colors = [
  kbackgroundColor2.withOpacity(1),
  kbackgroundColor2.withOpacity(1),
];

var text_colors = [Colors.black, Colors.black];
bool _isLoading = false;

class _HarFinalState extends State<HarFinal> {
  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () async {
      setState(() {
        _isloading = true;
      });
      try {
        await Provider.of<HarReport_Manager>(context, listen: false)
            .get_single_har(widget.har_id!)
            .then((_) {
          Provider.of<HarReport_Manager>(context, listen: false)
              .get_classifications_for_report(widget.har_id!.toString())
              .then((_) =>
                  Provider.of<HarReport_Manager>(context, listen: false)
                      .get_users());

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
                      'Assigned To',
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
                        if (harmanager.users!.isEmpty) {
                          return const Center(child: Text('No Users'));
                        } else {
                          return ListView.builder(
                            itemCount: harmanager.users!.length,
                            itemBuilder: (BuildContext ctxt, int index) {
                              return ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.white, // background
                                  onPrimary: Colors.white, // foreground
                                ),
                                onPressed: () {
                                  Provider.of<AppStateManager>(context,
                                          listen: false)
                                      .set_har_action_assigned_to(
                                          harmanager.users![index]);
                                  Navigator.pop(context);
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      harmanager.users![index].name.toString(),
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

  TextEditingController action_controller = TextEditingController();
  FocusNode focus1 = FocusNode();

  void _submit(int reportid) async {
    try {
      if (Provider.of<AppStateManager>(context, listen: false)
              .action_assignedTo
              .id ==
          null) {
        _showErrorDialog('you should select User');
        return;
      }
      if (Provider.of<AppStateManager>(context, listen: false)
              .actionDueTimeUnix ==
          null) {
        _showErrorDialog('you should select Target Date');
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
          .add_Action2(
        actionDetails: action_controller.text,
        dueDate: Provider.of<AppStateManager>(context, listen: false)
            .actionDueTimeUnix
            .toUtc()
            .millisecondsSinceEpoch,
        assignedTo: Provider.of<AppStateManager>(context, listen: false)
            .action_assignedTo
            .id,
        assignedBy: Provider.of<Auth_manager>(context, listen: false).userid,
        reportID: reportid,
      )
          .then((_) {
        Navigator.pop(context);
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

    return SafeArea(
        child: Scaffold(
      floatingActionButton:
          Provider.of<HarReport_Manager>(context, listen: false)
                      .single_har!
                      .reporter ==
                  userid
              ? FloatingActionButton(
                  onPressed: () {
                    setActionView(!actionView);
                  },
                  child: const Icon(Icons.add_sharp),
                  backgroundColor: senergyColorg)
              : null,
      appBar: AppBar(
        title: const Center(
          child: Text(
            'HAR REPORT',
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
                .gotomysinglehar(false, 1);
            Provider.of<AppStateManager>(context, listen: false).clearactoin();
            Provider.of<AppStateManager>(context, listen: false).clearactoin();
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
                              .single_har!.id ==
                          null
                      ? const Padding(
                          padding: EdgeInsets.all(20.0),
                          child: Text(
                            'NO HAR',
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
                                          harManager.single_har!.content ?? '',
                                          maxLines: 10,
                                          overflow: TextOverflow.ellipsis,
                                          softWrap: false,
                                          style: TextStyle(
                                              color: text_colors[
                                                  0 % colors.length],
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
                                            harManager.single_har!
                                                        .reportReporter!.name ==
                                                    null
                                                ? ''
                                                : harManager.single_har!
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
                                            Container(
                                              margin: const EdgeInsets.all(6.0),
                                              padding:
                                                  const EdgeInsets.all(3.0),
                                              decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color: senergyColorb
                                                          .withOpacity(.3))),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    harManager.single_har!
                                                                .reportDate ==
                                                            null
                                                        ? ''
                                                        : DateTime.fromMillisecondsSinceEpoch(
                                                                harManager
                                                                    .single_har!
                                                                    .reportDate!)
                                                            .toString()
                                                            .substring(
                                                                0,
                                                                harManager
                                                                        .single_har!
                                                                        .reportDate!
                                                                        .toString()
                                                                        .length +
                                                                    3)
                                                            .replaceAll(
                                                                RegExp(' '),
                                                                ' , '),
                                                    style: TextStyle(
                                                        color: text_colors[
                                                            0 % colors.length],
                                                        fontFamily:
                                                            'AraHamah1964R-Bold'),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ]),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Chip(
                                            elevation: 1,
                                            padding: const EdgeInsets.all(2),
                                            backgroundColor: Colors.white,
                                            label: Text(
                                              'Closed',
                                              style: TextStyle(
                                                  fontSize: 10,
                                                  color: harManager.single_har!
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
                                            padding: const EdgeInsets.all(2),
                                            backgroundColor: Colors.white,
                                            label: Text(
                                              'acknowledged ',
                                              style: TextStyle(
                                                  fontSize: 10,
                                                  color: harManager.single_har!
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
                                            true, harManager.single_har!.id!);
                                  },
                                  title: Row(
                                    children: [
                                      SizedBox(
                                        width: 200,
                                        child: Text(
                                          harManager.single_har!.title!,
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
                                      buildSeverity(
                                          harManager.single_har!
                                              .reportLikelihood!.id!,
                                          harManager
                                              .single_har!.reportCategory!.id!)
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
                                          title: 'Location: ',
                                          item: harManager.single_har!
                                                  .reportLocation!.name ??
                                              '',
                                        ),
                                        Items(
                                          size: size,
                                          title: 'Segment: ',
                                          item: harManager
                                                  .single_har!
                                                  .reportDepartment!
                                                  .departmentName ??
                                              '',
                                        ),
                                        Items(
                                          size: size,
                                          title: 'Type: ',
                                          item: harManager.single_har!
                                                  .reportHarType!.type ??
                                              '',
                                        ),
                                        Items(
                                          size: size,
                                          title: 'Event Type: ',
                                          item: harManager.single_har!
                                                  .reportType_!.type ??
                                              '',
                                        ),
                                        Items(
                                          size: size,
                                          title: 'Liklihood: ',
                                          item: harManager
                                                  .single_har!
                                                  .reportLikelihood!
                                                  .likelihood ??
                                              '',
                                        ),
                                        Items(
                                          size: size,
                                          title: 'Hazard Category: ',
                                          item: harManager
                                                  .single_har!
                                                  .reportCategory!
                                                  .hazardCategory ??
                                              '',
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
                                            'Need Action',
                                            style: TextStyle(
                                              fontSize: 15,
                                              fontFamily: 'GE-medium',
                                              color: senergyColorb,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
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
                                                'Assigned To',
                                                style: TextStyle(
                                                  fontSize: 15,
                                                  fontFamily: 'GE-medium',
                                                  color: senergyColorg,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Consumer<AppStateManager>(
                                            builder: (context, hartextmanager,
                                                    child) =>
                                                Select_widget(
                                                    context,
                                                    hartextmanager
                                                        .action_assignedTo
                                                        .name, () {
                                              _modalBottomSheet_har_category(
                                                  context);
                                            }),
                                          )
                                        ],
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
                                                'Due Date',
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
                                                harManager.single_har!.id!),
                                            child: const Text(
                                              'Submit',
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
                            if (harManager.single_har!.image != null &&
                                !actionView)
                              Container(
                                width: size.width * .95,
                                child: Image.network(
                                  'http://10.0.2.2:5000/images/' +
                                      // 'images/2022-07-03T19-59-43.585Zb52f0a3a-5509-48c6-be18-05e04b4ef91f8874079307014466216.jpg'
                                      harManager.single_har!.image!
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
